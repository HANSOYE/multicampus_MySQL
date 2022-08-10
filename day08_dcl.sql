-- day08_dcl.sql

-- root 계정: 관리자 계정 
-- 전체 DBMS를 관리하는 데이터베이스가 존재한다. ==> mysql
-- mysql 데이터 베이스는 root 관리자만 사용할 수 있는 데이터베이스이다. 
-- mysql의 테이블 중 user 테이블 => 사용자에 대한 정보를 가지고 있음
-- 					db 테이블 => 사용자가 이용할 데이터베이스 정보를 가짐
show databases;
use mysql;
show tables;
select * from user;
select * from db;

-- 사용자 추가 
-- create user 사용자명@host identified by '비밀번호' 
create user scott@localhost identified by 'tiger';
-- 외부에서도 접근할 수 있는 권한을 부여하려면 host '%'로 하여 똑같은 계정을 추가한다. 
-- %의 의미는 외부에서의 접근을 허용
create user 'scott'@'%' identified by 'tiger';
select * from user;

-- 사용자 삭제 
-- drop user 사용자명 
drop user scott@localhost;
drop user 'scott'@'%';

-- 사용자를 추가하세요 'king' 비번 '1234' 생성하되 로컬과 외부에서 접속할 수 있도로 생성하세요
create user king@localhost identified by '1234';
create user 'king'@'%' identified by '1234';
select * from user;

-- 데이터베이스 생성
create database campusdb default character set utf8;

-- king 사용자에게 데이터베이스 사용 권한을 부여해보자.
-- DCL : GRANT, REVOKE
-- 권한 부여 :  grant all privileges on db명. 테이블 to 계정아이디@host 
grant all privileges on campusdb.* to king@localhost;

flush privileges;

-- 사용자에게 부여된 권한 확인
show grants for king@localhost;

select * from db;

-- 사용자에게 부여한 권한을 회수 (제거)
-- revoke
revoke all on campusdb.* from king@localhost;







