/*
Based on the payment table, identify customers who used only single payment channel.
Output:
- user_id
- single_channel_name: name of the single payment channel.
- total_payment_amount: total payment amount of user.
*/

SELECT
    user_id,
    MIN(payment_channel) single_payment_channel,
    SUM(payment_amount) total_payment_amount
FROM
    payment
GROUP BY
    user_id
HAVING
    COUNT(DISTINCT payment_channel) = 1

