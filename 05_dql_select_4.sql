# "내장 함수"
# - mysql dbms에 이미 구현된 함수
# - 문자형, 숫자형, 날짜형 별 함수가 따로 제공
# - 반드시 반환값을 갖는다.

# 문자열 관련 함수
# ASCII: 아스키 코드 값 추출
# CHAR: 아스키 코드로 문자 추출
SELECT ASCII('A'), CHAR(65);    # 값 치환

-- ============================================
# 문자 인코딩: 컴퓨터에서 '문자를 표시하는 방법'
# UTF-8: 아스키코드 문자는 1byte, '나머지는 3byte'로 표시 (mysql도 차용)
# UTF-16: '모든 문자'를 2byte(16bit)로 표시
-- ============================================

# BIT_LENGTH: 할당된 비트 크기 반환
# CHAR_LENGTH: 문자열의 길이 반환
# LENGTH: 할당된 BYTE 크기 반환`
SELECT BIT_LENGTH('pie'), CHAR_LENGTH('pie'), LENGTH('pie');
SELECT
    menu_name,
    CHAR_LENGTH(menu_name),
    LENGTH(menu_name),
    BIT_LENGTH(menu_name)
from
    tbl_menu;


# CONCAT: 문자열을 이어붙임
# CONCAT_WS: 구분자와 함께 문자열을 이어붙임  # ws: whitespace (공백)
SELECT CONCAT('호랑이', '기린', '토끼'); # 호랑이기린토끼
SELECT CONCAT_WS(',', '호랑이', '기린', '토끼'); # 호랑이,기린,토끼
SELECT CONCAT_WS('-', '2023', '05', '31');


## indexof 함수와 유사
# INSTR(기준문자열, 부분문자열): 기준 문자열에서 부분 문자열의 시작 위치 반환
select instr('사과딸기바나나', '바나나');
select instr('사과딸기바나나', '포도');  # 없는 것에 대해 '0'으로 표시

# 메뉴 테이블에서 메뉴명에 '마늘'이 포함된 메뉴만 조회
select
    tbl_menu.menu_name,
    instr(menu_name, '마늘')
from
    tbl_menu
where
#     instr(menu_name, '마늘') > 0
    menu_name like '%마늘%'


# LPAD: 문자열을 길이만큼 왼쪽으로 '늘린 후에 빈 곳'을 문자열로 채운다.
# RPAD: 문자열을 길이만큼 오른쪽으로 '늘린 후에 빈 곳'을 문자열로 채운다.
SELECT LPAD('왼쪽', 6, '@'), RPAD('오른쪽', 6 ,'@');

# SUBSTRING: 시작 위치부터 길이만큼의 문자를 반환
# (길이를 생략하면 시작 위치부터 끝까지 반환)
SELECT
    SUBSTRING('안녕하세요 반갑습니다.', 7, 2),
    SUBSTRING('안녕하세요 반갑습니다.', 7),
    SUBSTRING('안녕하세요 반갑습니다.', INSTR('안녕하세요 반갑습니다.', '반갑'));

# CEILING: 올림값 반환
# FLOOR: 내림값 반환
# ROUND: 반올림값 반환
# TRUNCATE(n, 소수점자리): 버림 (지정 소수점 자리 외 버림)
SELECT
    CEILING(1234.56),
    FLOOR(1234.56),
    ROUND(1234.56),
    TRUNCATE(1234.56, 0);
#음수
select
    CEILING(-1.5),  # 01234//56789  <->  양수와 반대
    FLOOR(-1.5),
    ROUND(-1.5),
    TRUNCATE(-1.5, 0);

select
    truncate(1234.56, 1),
    truncate(1234.56, 0),
    truncate(1234.56, -1),  # -로 이동하였기에, 1의 자리부터 버려라
    truncate(1234.56, -2);  # -로 이동하였기에, 10의 자리부터 버려라


# RAND: 0이상 1 미만의 실수를 구한다. (0.0 <= n <= 1.0)
select rand(), rand(), rand();

# 1~45 사이 난수 1개 조회
# 0.0 <= x < 1.0
# 0.0 <= x * 45 < 45.0
select rand() * 45;    # 왜냐하면 rand() 자체는 0~1이기에 값 변경을 위해 n을 곱함

select floor(rand() * 45 + 1);
select floor(rand() * 45 + 1);
select floor(rand() * 45 + 1);
select floor(rand() * 45 + 1);
select floor(rand() * 45 + 1); # 로또


# =========================================================
# 날짜 관련 함수

# now(): 현재시간
# adddate(date, 일수) --> 하루 증가
# subdate(date, 일수) --> 하루 감소
select
    now(),
    adddate(now(), 1),
    subdate(now(), 1),
    subdate(now(), interval 3 month);   # day, month, week, year


# DATEDIFF: 날짜1 - 날짜2의 일수를 반환
# TIMEDIFF: 시간1 - 시간2의 결과를 구함
SELECT
    DATEDIFF('2026-11-20', NOW()),
    TIMEDIFF('17:07:11', '13:06:10');


# extract (단위 from date)
# - date에서 해당하는 단위 추출
# - 단위: year, quarter, month,
#    week, day, hour, minute, second, microsecond
select
    now(),
    extract(year from now()),
    extract(month from now()),
    extract(day from now())     # 숫자형으로 반환


-- =====================================================
-- =====================================================
# date_format(datetime, 형식문자열) -> 문자열
select
    date_format(now(), '%y/%m/%d'),
    date_format(now(), '%Y/%m/%d'),
    date_format(now(), '%h:%m');

# str_to_date(문자열, 형식문자열) -> datetime
select
    str_to_date('25/04/21', '%y/%m/%d'),
    str_to_date('2025/04/21', '%Y/%m/%d'),
    cast('2025/04/21' as date); -- 날짜시간형식 유추가 가능한 경우

# 기타함수
# null처리 함수 - ifnull(값, null일때 값)
select
    ifnull(ref_category_code, '미지정') ref_category_code
from
    tbl_category;

# 삼항연산처리 - if(조건식, 참일때 값, 거짓일때 값)
select
    isnull(category_code),
    if(isnull(category_code), '미지정', category_code) category_code
from
    tbl_menu;

select
    menu_name,
    menu_price,
    if(menu_price < 10000, '싼', '비싼') price_clf
from
    tbl_menu;