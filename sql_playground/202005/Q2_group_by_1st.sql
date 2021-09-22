/*
Based on the payment table, calculate the annual active buyer by date.
Output:
- date
- annual_active_buyer: number of new active buyers on the date. Note that if a buyer has been counted in a previous date, the buyer should not be counted again.
- first_used_payment_channel: the first payment channel used by a new active buyer.
- total_payment_amount: total payment amount of all new annual active buyers on the date.
*/

WITH active_buyer AS (
    SELECT
        *
    FROM
        (
            SELECT
                *,
                date(timestamp) date,
                ROW_NUMBER() OVER(PARTITION BY user_id ORDER BY transaction_id) rk_u
            FROM
                payment
        ) ru
    WHERE
        rk_u = 1
)
SELECT
    u.date,
    u.annual_active_buyer,
    p.payment_channel,
    u.total_payment_amount
FROM
    (
        SELECT
            date,
            COUNT(DISTINCT user_id) annual_active_buyer,
            SUM(payment_amount) total_payment_amount
        FROM
            active_buyer
        GROUP BY
            date
    ) u
    LEFT JOIN (
        SELECT
            date,
            payment_channel
        FROM
            (
                SELECT
                    date,
                    payment_channel,
                    ROW_NUMBER() OVER(PARTITION BY date ORDER BY transaction_id) rk_d
                FROM
                    active_buyer
            ) rd
        WHERE
            rk_d = 1
    ) p ON u.date = p.date

