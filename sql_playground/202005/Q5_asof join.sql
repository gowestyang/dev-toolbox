/*
You are given two tables, buses and passengers (examples in data folder).
Each row of table buses contains information about a single bus's origin, destination and time of departure.
Each row of table passenger contains information about the station they're travelling from, to, and time they will arrive a the departure station.

Passengers will board the earliest possible bus that travels directly to their desired destination.
Passengers can still board a bus it it departs in the same minute that they arrive at the station.
All passengers who are still at the station at 23:59 and don't board any of the 23:59 buses will leave the platformwithout boarding any bus.

You can assume that no two buses with the same origin and destination depart at the same time.

Query for each bus, the number of passengers boarding it, and order by bus id in ascending order.
Based on the buses and passengers, calculate the 2nd time payment success rate by payment_channel and user_id.
Output:
- id (bus id)
- passengers_on_board
*/

WITH tsorted AS (
  SELECT row_number() over () rn, *
  FROM(
    SELECT *
    FROM (
    SELECT NULL b_id, id p_id, origin, destination, time FROM passengers
    UNION ALL
    SELECT id b_id, NULL p_id, origin, destination, time FROM buses) bp_unorder
    ORDER BY time DESC, p_id DESC) bp
)

SELECT b_id id, SUM(CASE WHEN p_id IS NULL THEN 0 ELSE 1 END) passengers_on_board
FROM (
  SELECT FIRST_VALUE(b_id) over (partition by b_part, origin, destination ORDER BY rn) b_id, p_id
  FROM(
    SELECT SUM(CASE WHEN b_id IS NULL THEN 0 ELSE 1 END) OVER (PARTITION BY origin, destination ORDER BY rn) b_part, *
    FROM tsorted
    ) t
  ) t1
WHERE b_id IS NOT NULL
GROUP BY b_id
ORDER BY b_id
