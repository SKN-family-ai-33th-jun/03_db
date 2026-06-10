-- =============================
-- JOIN
-- =============================
-- 두개 이상의 테이블의 레코드를 연결해서 가상테이블(relation) 생성
-- 연관성을 가지고 있는 컬럼을 기준(데이터)으로 조합

# relation을 생성하는 2가지 방법
-- 1. join : 특정컬럼 기준으로 행과 행을 연결한다. (가로)
-- 2. union : 컬럼과 컬럼을 연결한다.(세로)
-- join은 두 테이블의 행사이의 공통된 데이터를 기준으로 **선을 연결해서** 새로운 하나의 행을 만든다.

# JOIN 구분
-- 1. Equi JOIN : 일반적으로 사용하는 Equality Condition(=)에 의한 조인
-- 2. Non-Equi JOIN : 동등조건(=)이 아닌 BETWEEN AND, IS NULL, IS NOT NULL, IN, NOT IN, !=  등으로 사용.

# EQUI JOIN 구분
-- 1. INNER JOIN(내부 조인) : 교집합 (일반적으로 사용하는 JOIN)
-- 2. OUTER JOIN(외부 조인) : 합집합
        -- LEFT (OUTER) JOIN (왼쪽 외부 조인)
        -- RIGHT (OUTER) JOIN (오른쪽 외부 조인)
-- 3. CROSS JOIN
-- 4. SELF JOIN(자가 조인)
-- 5. MULTIPLE JOIN(다중 조인)


## inner join(내부 조인)
# - 두 테이블의 교집합을 반환하는 SQL JOIN
# - ==> 조인에 사용될 두 테이블의 특정 컬럼 값이 같은 행만 JOIN

# tbl_menu, tbl_category 두 테이블을 inner join
# join 조건: category_code 값이 같은 행끼리 join
select
    *
from
    tbl_menu a # 별칭: a
inner join  # inner는 생략해도 됨 (기본값임)
    tbl_category b # 별칭: b
on
    a.category_code = b.category_code;


# 메뉴명, 가격, 카테고리명을 가격 내림차순으로 조회
select
    a.menu_name,
    a.menu_price,
    b.category_name
from
    tbl_menu a
join
    tbl_category b
on
    a.category_code = b.category_code
order by
    menu_price desc;


# ==============================================
# outer join
# - 좌/우측 기준 테이블의 모든 행을 relation에 포함하는 join
# - left [outer] join
# - right [outer] join  # outer는 생략 가능

insert into tbl_menu(menu_name, menu_price, category_code, orderable_status)
values('초콜릿 덮밥', 10000, 7, 'Y');
commit;

update
    tbl_menu
set
    category_code

select * from tbl_menu;


# employeedb로 변경
select
    emp_name, dept_code
from
    employee;

select
    *
from
    department;


# employee 테이블과 department 테이블 inner join
# -> employee (23행), department(9행)
# -> join 결과: 21행
## 이유: employee.dept_code에 값이 없는(null) 행이 존재했기 때문
                ## 하동운, 이오리 두 행이 조인 결과(relation)에 포함되지 않았기 때문

select
    employee.EMP_ID,
    employee.EMP_NAME,
    employee.DEPT_CODE,
    department.DEPT_ID,
    department.DEPT_TITLE

from
    employee
join
        department
on employee.DEPT_CODE = department.DEPT_ID
order by
    employee.EMP_ID asc


## left outer join ##
# join 구문 기준 왼쪽에 작성된 테이블의 모든 행이 relation에 포함되게 하기
# relation에 포함되게 하기
select
    employee.EMP_ID,
    employee.EMP_NAME,
    employee.DEPT_CODE,
    department.DEPT_ID,
    department.DEPT_TITLE

from
    employee
left outer join # 왼쪽에 있는 테이블인 employee에 있는 모든 행이 relation에 포함되어야 한다는 의미.
        department
on employee.DEPT_CODE = department.DEPT_ID
order by
    employee.EMP_ID asc


## right outer join ##
# join 구문 기준 왼쪽에 작성된 테이블의 모든 행이 relation에 포함되게 하기
# relation에 포함되게 하기
# - inner join 결과 21행 + department join 안 된 3행 = 24행
select
    employee.EMP_ID,
    employee.EMP_NAME,
    employee.DEPT_CODE,
    department.DEPT_ID,
    department.DEPT_TITLE

from
    employee
right outer join # 오른쪽에 있는 테이블인 employee에 있는 모든 행이 relation에 포함되어야 한다는 의미.
        department
on employee.DEPT_CODE = department.DEPT_ID
order by
    employee.EMP_ID asc