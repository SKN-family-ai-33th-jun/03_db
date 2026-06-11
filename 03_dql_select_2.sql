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


### menudb 계정
# cross join (카테시안곱, 곱집합)
# 조인되는 두 테이블의 모든 경우의 수를 처리한 것 (A의 모든 행 + B의 모든 행 조합 --> A개수 * B개수)
select count(*) from tbl_menu; # 22행
select * from tbl_menu; # 22행
select count(*) from tbl_category # 12행

# 22 * 12 = 264
select
    *
from
    tbl_menu
cross join
        tbl_category


# self join
# - 하나의 테이블에서 한 행이 다른 행을 참조하는 관계가 있는 경우
# 같은 테이블끼리 조인하는 것
# [tip] 똑같은 테이블이 2개 있다고 생각하면 쉬움
select * from tbl_category;          # 1. 여러 음식들이 있고, 한식 중식 일식 등의 카테고리가 같이 정리됨
                                     # 2. 여러 음식들이 카테고리의 주요키를 참조로 사용됨
                                     # 3. 해당 키로 묶여있는 것끼리 정리되어 테이블이 출력됨
                                     # ex) 한식:1, 중식:2, 일식:3 --> 여러 음식들이 각각 이 키들을 가짐.
                                        # --> 그거에 맞게 순차적으로 재정리됨.

select
    child.category_code,
    child.category_name,
    parent.category_name as "상위 카테고리"
from
    tbl_category child
join
    tbl_category parent
on
    child.ref_category_code = parent.category_code
# where
#     parent.category_name = '식사';


# multiple join (다중 조인)
# - 3개 이상의 테이블을 조인하는 것
# - join 순서가 매우 중요함 (순서가 잘못되면 join이 되지 않음)
                        # 예시) a join b join c
                        # --> (a+b) join c
                        # --> (a+b+c)

select * from tbl_order;
select * from tbl_order_menu;
select * from tbl_menu;

select
    *
from
    tbl_order o
join
    tbl_order_menu om
on
    o.order_code = om.order_code    # ~ 현 위치: o와 om이 합쳐진 relation 생성됨

join
    tbl_menu m
on
    m.menu_code = om.menu_code;


# employeedb로 변경
select * from employee;
select * from department;
select * from location;

select * from employee e
join department d on e.DEPT_CODE = d.DEPT_ID
join location l on d.LOCATION_ID = l.LOCAL_CODE;