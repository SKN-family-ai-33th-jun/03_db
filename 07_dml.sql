-- ===================================
-- DML
-- ===================================
-- DML(Data Manipulation Language)
-- Data를 조작(삽입, 수정, 삭제, 조회)하기 위해 사용하는 언어
-- Data를 이용하려는 사용자와 DB사이의 인터페이스를 직접적으로 제공하는 언어로써 가장 많이 사용됨
-- INSERT, UPDATE, DELETE, SELECT(DQL)

# INSERT
-- 새로운 '행을 추가'하는 구문이다.
-- 테이블의 행의 수가 증가한다.
-- insert요청시 처리된 '행의 수'가 반환된다. (PyCharm에서 Service뷰-Output탭에서 확인이 가능)

# 문법
-- 1. INSERT INTO <테이블명> VALUES (입력데이터1, 입력데이터2, ... );
-- 2. INSERT INTO <테이블명>(컬럼명1,컬럼명2,...) VALUES (입력데이터1, 입력데이터2, ... );`
--      - null을 허용하는 컬럼은 생략가능하다(생략되면 null값이 대입)
--      - not null인 컬럼은 생략할 수 없다.(단, default값이 지정되면 생략가능)
-- 3. INSERT INTO <테이블명>(컬럼명1,컬럼명2,...) VALUES
--      (입력데이터1, 입력데이터2, ... ), (입력데이터1, 입력데이터2, ... ), ... ;

# 행(record) 추가
# - 제약조건에 위배되는 컬럼값이 하나라도 있으면 추가할 수 없다.
# - not null컬럼에는 null값이 있을 수 없다.
# - pk, unique컬럼에는 중복값이 들어갈 수 없다.
# - fk컬럼 참조하는 컬럼 이외의 값을 들어갈 수 없다.
# - check컬럼 제시된 도메인외의 값을 들어갈 수 없다.


# 문법 1. 테이블에 작성된 '컬럼 순서대로' 모든 값 작성
insert into tbl_menu
values(
       null,    # auto increment가 숫자 대입
       '바나나해장국',
       9500,
       4,
       'Y'
      );

select * from tbl_menu;

desc tbl_menu; # tbl_menu 테이블 정보 조회
                ## 이 중 null이 의미하는 것: 해당 열에 null이 들어갈 수 없음
insert into tbl_menu
values(
       null,    # auto increment가 숫자 대입
       null,    # Column 'menu_name' cannot be null
       9500,
       4,
       'Y'
      );
# [23000][1048] Column 'menu_name' cannot be null


# 문법 2. 작성한 컬럼 값 제공

# menu_code 제외 --> 자동으로 null --> auto increment 적용
insert into
    tbl_menu(menu_price,
             orderable_status,
             menu_name,
             category_code)
values(
       6500,
       'Y',
       '카카오 죽',
       '6'
      );

select * from tbl_menu;


# 문법 3. 대량 데이터 추가
insert into
    tbl_menu
values
    (null, '참치맛 아이스크림', 1700, 12, 'Y'),
    (null, '멸치맛 아이스크림', 1700, 12, 'Y'),
    (null, '소시지맛 커피', 2300, 8, 'Y');

select * from tbl_menu;


# ===========================================================
# update (수정)
# - 테이블 기존 행의 컬럼 값을 수정하는 구문
# - 바꾸고 싶은 컬럼 값이 존재하는 행을 잘 찾는 것이 중요
#   (where)
/*
    update 테이블명
    set
        컬럼명1 = 값,
        컬럼명2 = 값,
        컬럼명3 = 값,
        컬럼명4 = 값,
         ...
    where
        행 선택 조건;
 */

select * from tbl_menu;
# 19번 까나리코코넛쥬스 가격 1000원 인상
update tbl_menu
set
    menu_price = menu_price + 1000  # =의 의미: DB에서는 원래 '같다'라는 의미이지만 update 명령어에 한해 '대입'으로 작용
where
    menu_code = 19;

select * from tbl_menu;


# '한식'의 가격을 모두 500원 인상
update tbl_menu
set
    menu_price = menu_price + 500
where
    category_code = (
        select category_code
        from tbl_category
        where
            category_name = '한식'
        );

select * from tbl_menu where category_code = 4;


# ===========================================================
# delete (삭제)
# - 지정된 행을 삭제 (where)
/*
    delete
    from 테이블명
    where 조건;
*/

select * from tbl_menu;

# 특정 행 삭제
delete from tbl_menu where menu_code = 27;

# 메뉴 코드가 21보다 큰 메뉴 모두 삭제
delete from tbl_menu where menu_code > 21;


# ==========================================================
# replace
# - insert + update (upsert 구문)
## - 새로운 데이터를 테이블에 삽입할 때
## - 1. pk(식별자) 컬럼 값이 중복되는 것이 없으면 insert
## - 2. pk(식별자) 컬럼 값이 중복되면 update
        ## 즉, 특정 식별자로 기존에 값이 없으면 insert, 있으면 update
/*
    REPLACE INTO <테이블명>
    VALUES (입력데이터1, 입력데이터2, ... );
*/

replace into tbl_menu
values(100,
       '참기름 커피',
       3000,
       8,
       'Y');

select * from tbl_menu;

# replace(update) 확인    --> 업데이트의 모습을 갖지만 실제로는 'delete 후 insert가 수행'됨
replace into tbl_menu
values(100,
       '소주맛 커피',
       5000,
       8,
       'Y');

select * from tbl_menu;