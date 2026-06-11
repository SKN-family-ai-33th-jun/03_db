# 그룹 함수
# - 그룹의 '통계를 반환하는 함수'
# - sum(), avg(), max(), min(), count()

# sum (컬럼명): 합계
# - null: 빈칸 '상태'를 나타냄        --> null인 항목이 있으면 자동 제외
select
    sum(menu_price)
from
    tbl_menu;

# avg (컬럼명): 평균
# - null: 빈칸 '상태'를 나타냄        --> null인 항목이 있으면 자동 제외
select
    avg(menu_price)
from
    tbl_menu;

# 카테고리 코드가 10인 메뉴의 평균 가격
# avg (컬럼명): 평균
# - null: 빈칸 '상태'를 나타냄        --> null인 항목이 있으면 자동 제외
select
    avg(menu_price)
from
    tbl_menu
where
    category_code = 10;

# 메뉴 가격 최대값, 최소값
# - null: 빈칸 '상태'를 나타냄        --> null인 항목이 있으면 자동 제외
select
    max(menu_price) '최대값',
    min(menu_price) '최소값'
from
    tbl_menu;

# select 1 + null;    # null과 '연산'을 수행하면 모든 결과가 null이 됨

# 합계, 평균 -> 숫자 데이터 컬럼에만 적용 가능
# 최대, 최소 -> 숫자 및 문자, 날짜 모두 사용 가능 (아스키코드,,, 문자, 날짜도 모두 숫자임)
select
    max(menu_name), # 흑마늘아메리카노
    min(menu_name)  # 갈릭미역파르페
from
    tbl_menu;

# count(*): 모든 행(null 포함)의 '개수'를 출력
# count(컬럼명): 지정된 컬럼 값 중 'null인 컬럼을 제외'한 행의 개수

select
    count(*),                   # null이 포함된 행의 개수: 9    (그룹의 행의 개수)
    count(ref_category_code)    # null이 제외댄 행의 개수: 12
from
    tbl_category;
-- ==================================================================
-- ==================================================================
# 그룹함수: table 값 전체를 '하나의 그룹으로서 간주'함 --> 이에 따라 그룹함수(sum, avg, max, min, count) 사용 가능
-- ==================================================================
-- ==================================================================

# group by절
# - 지정된 컬럼 값에서 각각 일치하는 행을 그룹화시키는 구문
#####
# 그룹함수: 그룹이 여러 개면 모든 그룹에 대해 그룹함수를 한 번씩 모두 적용함
#####
select
    category_code,
    count(*),    # 각 그룹의 모든 행의 개수        4가 4개, 5가 1개, ... 있음
    sum(menu_price),    # '각 그룹의' 값 합계
    avg(menu_price),    # '각 그룹의' 값 평균
    min(menu_price),    # '각 그룹의' 값 최소값
    max(menu_price)     # '각 그룹의' 값 최대값
from
    tbl_menu
group by
    category_code;  # category_code 컬럼 값이 같은 것을 그룹화 함


# group by 사용시 주의사항
## 1. null끼리도 묶임 (like 기타 등등)
## 2. 이미 group by를 한 번 한 경우에는 table 내부 자체가 이미 그룹화가 되어있기에
    # 개별적으로 값을 불러오거나 확인할 수 없다. 개별 행 단위가 아닌 그룹 단위로 접근됨.
    # --> 그룹 함수로만 접근 가능
## 3.
select
    ref_category_code
#     category_name   # 그룹화 컬럼으로 인한 오류
from
    tbl_category
group by
    ref_category_code;

## 3. 그럼에도 불구하고 개별 특정 값 접근을 원할 때
select
    category_code,
    orderable_status,    # 하위 그룹 내용을 출력
    count(*)    # 2차 그룹화된 orderable_status의 카운트
from
    tbl_menu
group by
    category_code,
    orderable_status    # 그룹 내에 하위 그룹을 또 만듬     ## 예시, 해당 그룹에서 yes or no 구분 필요시
order by
    category_code asc;

### where + group by: 필터링된 행 중 컬럼값이 같은 행 그룹화
# - where: 지정된 테이블에서 행을 필터링하는 것
# - group by: 컬럼 값이 같은 행들을 그룹화 시킴

# 메뉴 테이블에서 카테고리별 개수, 합계를 구하기
# 메뉴 가격이 10,000원 이상인 메뉴만
select
    category_code,
    count(*),
    sum(menu_price)
from
    tbl_menu
where
    menu_price >= 10000
group by
    category_code;


# 메뉴 테이블에서 주문이 가능한 메뉴 중 카테고리 코드가 4, 10인 메뉴의
# 카테고리별 개수 조회
select
    tbl_menu.category_code,
    count(*),
    tbl_category.category_name
from
    tbl_menu
join
    tbl_category
on
    tbl_menu.category_code = tbl_category.category_code
where
    orderable_status = 'Y'
and
    tbl_menu.category_code in (4,10)
group by
    tbl_menu.category_code


# ========================================================
# having 절
# - group by를 통해 만들어진 '그룹에 대한 조건'을 작성하는 구문 <--> where (전체에 대한 조건)
# - having 절 작성시 '항상 그룹함수가 포함'된다.

# 메뉴 테이블에서 카테고리별 메뉴 개수가 2개 이상인 카테고리의
# 카테고리 번호, 개수를 출력
select
    category_code,
    count(*)
from
    tbl_menu
group by
    category_code
having
    count(category_code) >= 2;


# 카테고리 테이블에서 부모 카테고리(ref_category_code)별로 개수 3개 이상인
# 부모 카테고리 번호, 개수 조회
# 부모 카테고리 오름차순으로 조회
select
    ref_category_code, count(*)
from
    tbl_category
group by
    ref_category_code
having
    count(*) >= 3
order by
    ref_category_code asc;
# 위 쿼리 결과에서 null 제외
select
    ref_category_code, count(*)
from
    tbl_category
where
    ref_category_code is not null
group by
    ref_category_code
having
    count(*) >= 3
# and
#     ref_category_code is not null       # having 보다는 where에서 먼저 하는 것을 권장함.
order by
    ref_category_code asc;


# select 구문에 작성 가능한 모든 절 사용
select
    ref_category_code, count(*)
from
    tbl_category
where
    ref_category_code is not null
group by
    ref_category_code
having
    count(*) >= 3
# and
#     ref_category_code is not null       # having 보다는 where에서 먼저 하는 것을 권장함.
order by
    count(*) asc
limit 1;    # 가장 최사위 행 1개만 추출