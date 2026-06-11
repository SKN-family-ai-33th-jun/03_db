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
    employee.EMP_NAME as `직원명`,
    department.DEPT_TITLE as 직급명,
    employee.SALARY as 급여,
    employee.EMP_ID as 사원번호,
    employee.EMAIL as 이메일,
    employee.PHONE as 전화번호,
    employee.HIRE_DATE as 입사일
from
    employee
join
    department
on
    employee.DEPT_CODE = department.DEPT_ID

where
    employee.ENT_YN = 'N'
order by
    employee.SALARY desc;


select * from employee;
select * from department;