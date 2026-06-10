create user skn_ai@'%' identified by '1234'; # 계정 생성

# MySQL에서는 database와 schema가 같은 의미로 사용됨
## - database (데이터 창고)
## - schema (창고의 설계도, 명세서)
create database menudb; # 데이터베이스 (데이터 저장 공간(파일) 생성)
create schema employeedb; # 스키마 생성

show databases; # 데이터베이스 목록 조회

grant all privileges on menudb.* to skn_ai@'%'; # 사용자에게 권한 부여
grant all privileges on employeedb.* to skn_ai@'%'; # 사용자에게 권한 부여

show grants for skn_ai@'%'; # skn_ai 계정에 부여된 권한 목록 조회