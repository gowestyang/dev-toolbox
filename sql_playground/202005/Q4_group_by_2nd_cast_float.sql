/*
Based on the payment_success table, calculate the 2nd time payment success rate by payment_channel and user_id.
Output:
- payment_channel
- user_count: number of users used this payment channel.
- total_2nd_time_transactions: total number of 2nd time transactions from all users.
- total_2nd_time_success_transactions: total number of 2nd time transactions which were successful.
- second_payment_success_rate: total_2nd_time_success_transactions / total_2nd_time_transactions.
*/

WITH transaction2 AS (
    SELECT
        *
    FROM
        (
            SELECT
                *,
                ROW_NUMBER() OVER(PARTITION BY payment_channel, user_id ORDER BY transaction_id) rk
            FROM
                payment_success
        ) u
    WHERE
        rk = 2
)
SELECT
    *,
    total_2nd_time_success_transactions / CAST(total_2nd_time_transactions AS FLOAT) second_payment_success_rate
FROM
    (
        SELECT
            payment_channel,
            COUNT(DISTINCT transaction_id) total_2nd_time_transactions,
            COUNT(DISTINCT CASE STATUS WHEN 'SUCCESS' THEN transaction_id ELSE NULL END) total_2nd_time_success_transactions
        FROM
            transaction2
        GROUP BY
            payment_channel
    ) t

