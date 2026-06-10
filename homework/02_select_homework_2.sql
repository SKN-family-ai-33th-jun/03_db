-- ====== SELECT(2)
# Q1.
select
    EMP_ID,
    EMP_NAME,
    PHONE,
    HIRE_DATE,
    ENT_YN
from
    employee
where
    ENT_YN = 'N'
and
    PHONE like '%2'
order by
    HIRE_DATE desc
limit 3;


# Q2.
select
    employee.EMP_NAME,
    JOB_CODE,
    employee.SALARY,
    employee.EMP_ID,
    employee.EMAIL,
    employee.PHONE,
    employee.HIRE_DATE
from
    employee
where
    ENT_YN = 'N'
order by
    SALARY desc;


select * from employee