# DDL (Data Definition Language)
# - 데이터베이스 스키마(객체)를         # UPDATE: 전체 수정, MODIFY: 부분 수정, ALTER: 구조 수정(변경)
#   '만들고(CREATE)', '수정(ALTER)'하고, '삭제(DROP)'하는 구문
# ***************************************************************************#
# ***************************************************************************#
# - DDL 구문은 실행 시 바로 DB에 반영된다. <--> Transaction을 거치지 않음 (DML만 해당)
# ***************************************************************************#
# ***************************************************************************#

# [주의사항]
# *** 절대 DML과 DDL을 혼용해서 작성 금지 ***
# 1. DML 구문 수행 -> 트랜잭션에 담김
# 2. 중간에 DDL 구문 수행
# 3. 트랜잭션 내용이 자동 COMMIT
# --> DML로 작업 도중 commit을 하지 않았음에도 DDL을 사용하게 되면 기존 DML 내용도 모두 자동 COMMIT 됨.

# ==========================================================
### create table
/*  [작성법]
    create table [if not exists] 테이블명(
        컬럼1 자료형 [제약조건|auto increment] [default-가본값 옵션] [comment-주석(for human)],
        컬럼2 자료형 [제약조건] [default-가본값 옵션] [comment],
        컬럼3 자료형 [제약조건] [default-가본값 옵션] [comment],
        컬럼4 자료형 [제약조건] [default-가본값 옵션] [comment]
        ...
    );
*/

# auto_increment: 숫자 자동 증가 옵션
# 기본적으로 PK(Primary Key) 컬럼에만 사용 가능

# default: 값이 들어가지 않은 null 상태로 주어지면 해당 셀의 값은 default 값으로 기록됨

create table if not exists product(     # 컬럼 구조:  id | 이름 | 가격 | 생성시점
    id int primary key auto_increment comment '상품식별코드',
    name varchar(100) not null comment '상품명',
    price bigint not null default 0 comment '상품가격',
    created_at datetime default current_timestamp comment '상품등록일시'
);

# 생성한 테이블 조회
select * from product;

# 생성한 테이블 DDL 구문 확인
show create table product;

# 생성한 테이블 설명 조회
desc product;

# 테이블의 메타 정보를 조회하는 구문(데이터 분석 전문가들이 주로 사용)       # 메타 정보: 각종 정보를 모은 것
select
    *
from
    information_schema.tables
where
    TABLE_SCHEMA = 'menudb'
and
    TABLE_NAME = 'product'

# product 테이블에 데이터 추가 (insert)
insert into product(name) values('텀블러');    # name을 제외한 나머지 컬럼에
                                                    # default 값이 있기에 이와 같이 사용 가능
insert into product(name, price) values('머그컵', 5000);

select * from product;

commit;


# ================================================================
### 제약조건 (constraint)
# - 테이블 컬럼에 붙어 INSERT, UPDATE 시
# 각 컬럼에 기록되는 값에 대한 조건을 설정하는 방법  <-- 데이터 무결성을 보장하는 목적으로 사용
# - 종류: NOT NULL, UNIQUE, PRIMARY KEY, FOREIGN KEY, CHECK

# 제약조건 확인 방법
# 1.
desc product;

# 2.
select
    *
from
    information_schema.TABLE_CONSTRAINTS
where
    CONSTRAINT_SCHEMA = 'menudb'
and
    TABLE_NAME = 'product'


# NOT NULL: 지정된 컬럼은 NULL일 수 없다 == 값 필수
# UNIQUE: 지정된 컬럼에는 중복되는 값을 저장할 수 없다.
        # 중복되는 값:
DROP TABLE IF EXISTS user_unique;

CREATE TABLE IF NOT EXISTS user_unique (
    user_no INT NOT NULL,
    user_id VARCHAR(255) NOT NULL,
    user_pwd VARCHAR(255) NOT NULL,
    user_name VARCHAR(255) NOT NULL,
    gender VARCHAR(3),
    phone VARCHAR(255) NOT NULL UNIQUE, # 컬럼레벨 제약 조건 설정
    email VARCHAR(255)
#     ,UNIQUE (phone)   # 테이블 레벨 제약조건 설정    (마지막 행에 기입)
) ENGINE=INNODB;

INSERT INTO user_unique
(user_no, user_id, user_pwd, user_name, gender, phone, email)
VALUES
(1, 'user01', 'pass01', '홍길동', '남', '010-1234-5678', 'hong123@gmail.com'),
(2, 'user02', 'pass02', '유관순', '여', '010-777-7777', 'yu77@gmail.com');

SELECT * FROM user_unique;

# UNIQUE 제약조건 위배
INSERT INTO user_unique
(user_no, user_id, user_pwd, user_name, gender, phone, email)
VALUES
(3, 'user03', 'pass03', '이순신', '남', '010-777-7777', 'lee222@gmail.com');
# [23000][1062] Duplicate entry '010-777-7777' for key 'user_unique.phone'

# phone 값 변경 -> UNIQUE 제약조건 위배 해결
# '+ NOT NULL 제약조건 위배'
INSERT INTO user_unique
(user_no, user_id, user_pwd, user_name, gender, phone, email)
VALUES
(3, NULL, 'pass03',
 '이순신', '남', '010-8888-8888', 'lee222@gmail.com');
# [23000][1048] Column 'user_id' cannot be null

# NOT NULL 제약조건 해결
INSERT INTO user_unique
(user_no, user_id, user_pwd, user_name, gender, phone, email)
VALUES
(3, 'user03', 'pass03',
 '이순신', '남', '010-8888-8888', 'lee222@gmail.com');

select * from user_unique;

# PRIMARY KEY (중요)
# 테이블 내 행을 구별하기 위한 '식별자 역할의 컬럼'에 추가하는 제약조건
# - NOT NULL + UNIQUE 특징을 가짐: 중복되지 않는 필수 값
# - PRIMARY KEY는 테이블 내에 1개만 설정 가능
#   단, PK 설정이 적용되는 컬럼은 1개 또는 여러 개 '묶음 가능'
    # 묶음으로 하는 경우 조합이 일치하지 않으면 됨.
# 예를 들어, A와 B 칼럼이 있을 때 '1:간장', '1: 된장'과 같이 조합이 일치하지 않으면 사용 가능
DROP TABLE IF EXISTS user_primarykey;
CREATE TABLE IF NOT EXISTS user_primarykey (
--     user_no INT PRIMARY KEY,
    user_no INT,
    user_id VARCHAR(255) NOT NULL,
    user_pwd VARCHAR(255) NOT NULL,
    user_name VARCHAR(255) NOT NULL,
    gender VARCHAR(3),
    phone VARCHAR(255) NOT NULL,
    email VARCHAR(255),
    PRIMARY KEY (user_no)
) ENGINE=INNODB;

INSERT INTO user_primarykey
(user_no, user_id, user_pwd, user_name, gender, phone, email)
VALUES
(1, 'user01', 'pass01', '홍길동', '남', '010-1234-5678', 'hong123@gmail.com'),
(2, 'user02', 'pass02', '유관순', '여', '010-777-7777', 'yu77@gmail.com');

SELECT * FROM user_primarykey;
DESC user_primarykey;

# PK 컬럼에 NULL
INSERT INTO user_primarykey
(user_no, user_id, user_pwd, user_name, gender, phone, email)
VALUES
(null, 'user03', 'pass03', '이순신', '남', '010-777-7777', 'lee222@gmail.com');
# [23000][1048] Column 'user_no' cannot be null

# PK 컬럼에 중복값
INSERT INTO user_primarykey
(user_no, user_id, user_pwd, user_name, gender, phone, email)
VALUES
(2, 'user03', 'pass03', '이순신', '남', '010-777-7777', 'lee222@gmail.com');
# [23000][1062] Duplicate entry '2' for key 'user_primarykey.PRIMARY'

### PK 복합키 할인
create table order_composite_pk (
    user_id int,
    prod_id int,
    count int default 1,
    ordered_at datetime default (current_timestamp),
    primary key(user_id, prod_id, ordered_at)
);
insert into order_composite_pk
values (1, 1, 10, now());
insert into order_composite_pk
values (1, 1, 5, now());
insert into order_composite_pk
values (3, 100, default, now());

SELECT * FROM order_composite_pk;

# PK 컬럼 값 3개가 모두 일치하는 중복 데이터 삽입
insert into order_composite_pk(
    select * from order_composite_pk where user_id = 3
) # [23000][1062] Duplicate entry '3-100-2026-06-12 11:31:35' for key 'order_composite_pk.PRIMARY'


### FOREIGN KEY (외래키)
# - 참조(REFERENCE)된 다른 테이블에서 제공하는 값만 사용 가능
# - 참조 무결성을 위배하지 않기 위해 사용
# - 참조는 다른 테이블의 'PK 또는 UNIQUE가 설정된 컬럼'만 참조 가능하다.
# - FK 제약조건 설정 시 두 테이블간의 관계(RELATIONSHIP)가 형성된다.
  # - 부모 테이블: 참조를 당해서 컬럼 값을 제공하는 테이블
  # - 자식 테이블: 참조를 이용해서 다른 테이블의 컬럼 값을 이용
# - 제공되는 값 외에 NULL 사용 가능
DROP TABLE IF EXISTS user_grade;
CREATE TABLE IF NOT EXISTS user_grade (
    grade_code INT NOT NULL UNIQUE,
    grade_name VARCHAR(255) NOT NULL
) ENGINE=INNODB;

INSERT INTO user_grade
VALUES
(10, '일반회원'),
(20, '우수회원'),
(30, '특별회원');

SELECT * FROM user_grade;

DROP TABLE IF EXISTS user_foreignkey1;
CREATE TABLE IF NOT EXISTS user_foreignkey1 (
    user_no INT PRIMARY KEY,
    user_id VARCHAR(255) NOT NULL,
    user_pwd VARCHAR(255) NOT NULL,
    user_name VARCHAR(255) NOT NULL,
    gender VARCHAR(3),
    phone VARCHAR(255) NOT NULL,
    email VARCHAR(255),
    grade_code INT ,        # user_grade의 grade_code에 있는 값만 삽입 가능
    FOREIGN KEY (grade_code)
		REFERENCES user_grade (grade_code)
) ENGINE=INNODB;

INSERT INTO user_foreignkey1
(user_no, user_id, user_pwd, user_name, gender, phone, email, grade_code)
VALUES
(1, 'user01', 'pass01', '홍길동', '남', '010-1234-5678', 'hong123@gmail.com', 10),
(2, 'user02', 'pass02', '유관순', '여', '010-777-7777', 'yu77@gmail.com', 20);

SELECT * FROM user_foreignkey1;

# 부모 테이블에서 제공하지 않는 값 삽입
INSERT INTO user_foreignkey1
(user_no, user_id, user_pwd, user_name, gender, phone, email, grade_code)
VALUES
(3, 'user03', 'pass03', '이순신', '남', '010-777-7777', 'lee222@gmail.com', 50);
# [23000][1452] Cannot add or update a child row:
# a foreign key constraint fails
# (`menudb`.`user_foreignkey1`, CONSTRAINT `user_foreignkey1_ibfk_1`
# FOREIGN KEY (`grade_code`)
# REFERENCES `user_grade` (`grade_code`))


### FK 삭제 옵션 설정
# - 기본값: 부모 컬럼 값을 자식이 참조 중이면  변경, 삭제 불가능

# - UPDATE/DELETE SET NULL:
#   부모 컬럼 값을 자식이 참조 중이면 변경, 삭제 시
#   자식 컬럼 값을 NULL로 변경

# - UPDATE/DELETE CASCADE:
#   부모 컬럼 값을 자식이 참조 중이면 변경, 삭제 시
#   자식 테이블에서 참조 값이 포함된 모든 행을 삭제

DROP TABLE IF EXISTS user_foreignkey2;
CREATE TABLE IF NOT EXISTS user_foreignkey2 (
    user_no INT PRIMARY KEY,
    user_id VARCHAR(255) NOT NULL,
    user_pwd VARCHAR(255) NOT NULL,
    user_name VARCHAR(255) NOT NULL,
    gender VARCHAR(3),
    phone VARCHAR(255) NOT NULL,
    email VARCHAR(255),
    grade_code INT ,
    FOREIGN KEY (grade_code)
		REFERENCES user_grade (grade_code)
        ON UPDATE SET NULL
        ON DELETE SET NULL
) ENGINE=INNODB;

INSERT INTO user_foreignkey2
(user_no, user_id, user_pwd, user_name, gender, phone, email, grade_code)
VALUES
(1, 'user01', 'pass01', '홍길동', '남', '010-1234-5678', 'hong123@gmail.com', 10),
(2, 'user02', 'pass02', '유관순', '여', '010-777-7777', 'yu77@gmail.com', 20);

SELECT * FROM user_foreignkey2;


DROP TABLE IF EXISTS user_foreignkey1;

# 부모 테이블 컬럼 값 수정
UPDATE user_grade
SET grade_code = 50
WHERE grade_code = 10;

-- 자식 테이블의 grade_code가 10이 었던 회원의 grade_code값이 NULL이 된 것을 확인
SELECT * FROM user_foreignkey2;


DELETE FROM user_grade
WHERE grade_code = 20;

-- 자식 테이블의 grade_code가 20이 었던 회원의 grade_code값이 NULL이 된 것을 확인
SELECT * FROM user_foreignkey2;
SELECT * FROM user_grade;


### CHECK 제약조건
# 컬럼에 삽입될 수 있는 값에 대한 조건을 설정
DROP TABLE IF EXISTS user_check;
CREATE TABLE IF NOT EXISTS user_check (
    user_no INT AUTO_INCREMENT PRIMARY KEY,
    user_name VARCHAR(255) NOT NULL,
    gender VARCHAR(3) CHECK (gender IN ('남','여')),
    age INT CHECK (age >= 19)
) ENGINE=INNODB;

INSERT INTO user_check
VALUES
    (null, '홍길동', '남', 25),
    (null, '이순신', '남', 33);

SELECT * FROM user_check;

# 위배1 (GENDER 선택)
INSERT INTO user_check
VALUES (null, '안중근', '남성', 27);
# 체크제약조건 위배: [HY000][3819] Check constraint 'user_check_chk_1' is violated.

# 위배2 (AGE 선택)
INSERT INTO user_check
VALUES (null, '유관순', '여', 17);
# 체크제약조건 위배: [HY000][3819] Check constraint 'user_check_chk_2' is violated.


# =================================================================================
# alter 테이블 수정
-- alter table 테이블명 [서브명령어] ....
-- - add 컬럼/제약조건 추가
-- - drop 컬럼/제약조건 삭제
-- - modify 컬럼 자료형/not null/기본값 변경
-- - change 컬럼명 변경
-- - rename 테이블명 변경
select * from product;

# 컬럼 추가
alter table product
add description varchar(255)
not null
default '설명 없음'
after price;

select * from product;

alter table product
drop description;

select * from product;

# 제약조건 추가
alter table product
add unique (name);

desc product;

# 제약조건 삭제 (name unique 삭제)
alter table product
drop constraint name;   # constraint: 제약

# not null은 modify만 가능
desc product;

alter table product
modify name varchar(100) null;

# 컬럼명 변경
alter table product
change name product_name varchar(100) not null;
# 'name을 product_name으로 바꾸고 기타 하위 내용으로 설정하겠다'는 의미

# =============================================================
### DROP: 버림
DROP TABLE IF EXISTS product;   # table을 없애는 쿼리

desc product;   # [42S02][1146] Table 'menudb.product' doesn't exist


