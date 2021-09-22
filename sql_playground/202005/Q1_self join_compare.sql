/*
Based on the salary table, select all the employees whose monthly salary is higher than their manager by month.
Output:
- month
- emplyee
- manager
- salary_employee
- salary_manager
*/

SELECT
    e.month,
    e.employee,
    e.manager,
    e.salary AS salary_employee,
    m.salary AS salary_manager
FROM
    salary e,
    salary m
WHERE
    e.salary > m.salary
    AND e.manager = m.employee
    AND e.month = m.month
