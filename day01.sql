-- crud (create, read, update, delete)
-- database 사용하는 언어: SQL (Structured Query Language) 표준, Stored Procedure
show databases;   
-- 주석(단문 주석)

/*복문 주석
	여러라인 주석
*/
-- 데이터베이스 생성
-- CREATE DATABASE [IF NOT EXISTS] 데이터베이스명;  
CREATE DATABASE if not exists SCHOOLDB;

-- 사용할 데이터베이스를 지정
-- USE 데이터베이스명;
-- 지금부터 이 데이터 베이스를 사용하겠으니, 모든 쿼리(SQL문)는 이 DB에서 실행하란 의미임.
USE SCHOOLDB; 

-- 해당 데이터베이스의 테이블 목록을 확인해보자
-- show tables;
show tables;

/*
학생(Entity ==> Table) 테이블 생성
	- 학번 (Attribute => 필드, 컬럼) => 유니크한 값을 갖는 식별자 역할을 해야한다. Primary key
    - 이름
    - 연락처
    - 주소
    - 등록일
    - 학급명
    - 교실번호
*/

-- create table 테이블명(
-- 	컬럼명 자료형(크기)
--     컬럼명 자료형(크기)
--     컬럼명 자료형(크기)
--     제약조건
-- );

create table student(
	num int primary key, -- PK 식별자 역할을 한다
    name varchar(30) not null, -- NN
    tel varchar(15) not null,
    addr varchar(100),
    cname varchar(50),
    croom int 
);

-- 테이블 삭제
-- drop table 테이블명;

drop table student;

show tables;

desc student;

-- 학생 등록 
-- Insert 문 이용
-- insert into 테이블명(컬러명1, 컬럼명2, ...)
-- 		values(값1, 값2, ...)
-- crud 중 create 문에 해당함
insert into student(num, name, tel, addr, cname, croom)
values (3, 'yeah', '010-2222', '부산시', '빅데이터', 2);

-- reade 조회
-- select 컬럼명1, 컬럼명2 from 테이블명;
select num, name, cname, croom from student;

select * from student;

insert into student(num, name, tel) -- not null인 것만 넣어도 에러는 나지 않는다. 
values(4, 'go', '010-');

insert into student(num, name, tel) -- not null인 것만 넣어도 에러는 나지 않는다. 
values(5, '홍', '인공지능');

insert into student(num, name,tel) -- not null인 것만 넣어도 에러는 나지 않는다. 
values(6, 'choi', '010-8989');


-- 컬럼명을 생략하고 insert하면 values에 모든값을 다 기술해야 한다.
insert into student
values(7, '강', '051', '부산', '코딩', '4');

-- 빅데이터sw반: 3명 추가
-- ai서비스: 2명
-- 풀스택: 1명

insert into student
values(8, 'kang', '051', 'ulsan', 'ai', '1');

insert into student(num, name, tel, cname)
values(9, 'hong', '051', 'ai');

insert into student(num, name, tel, cname, croom)
values(10, 'jang', '032','ai', '1');

insert into student
values(11, 'jin', '051', 'ulsan', '빅데이터', '2');

insert into student(num, name, tel, cname)
values(12, 'park', '051', '빅데이터');

insert into student(num, name, tel, cname)
values(13, 'pong', '012', 'full-stack');

select * from student order by num desc;

select count(num) from student;

-- 빅데이터sw반의 학생 수
select count(num) from student
where cname = '빅데이터'; -- 5

select count(num) from student
where cname = "ai"; -- 3

select count(num) from student
where cname = "full-stack"; -- 1

select count(*) from student
where cname like '%데%'; -- 5 

-- 학급별 인원수
select count(*) from student
group by cname;

select * from student order by name asc;

-- update 수정
-- update 테이블명 set 컬럼명=수정할값, 컬럼명2=수정할값2
-- where 조건절; 

-- 4번 cname 바꾸기
update student set cname='full-stack'
where num = 4;

-- delete 삭제
-- delete from 테이블명 where 조건절; 

delete from student where num=5;
delete from student where num=6;

insert into student(num, name, tel, cname, croom)
values(14, 'choi-Ujin', '02', '빅데이터', '3');

select * from student
where croom = 2;

-- student 삭제하고 다시 생성하자
-- 부모테이블 학급(MCLASS) 1----------1대 다 관계-----------N 학생(Student) 자식테이블
delete from student;

select * from student;

drop table student;

show tables;

-- 학급 테이블 만들기(학급번호(pk), 학급명, 교실번호)

create table mclass(
	cnum int auto_increment primary key, -- 4byte
    cname varchar(30) not null,
    croom smallint -- 2byte
);

show tables;
desc mclass;

insert into mclass(cnum, cname, croom)
values(null, '빅데이터', '201');

select * from mclass;

select @@auto_increment_increment;

insert into mclass(cname, croom)
values('ai', 202);

insert into mclass(cname, croom)
values('full-stack', 203);

commit;
-- rollback;
-- oracle: 수동 커밋
--  mysql: 자동 커밋
select * from mclass;

select @@autocommit;

-- 학생 테이블(학급 테이블의 학급번호를 외래키로 참조한다)

create table student(
num int auto_increment primary key,
name varchar(30) not null,
tel varchar(15) not null,
addr varchar(100),
cnum_fk int,
-- 외래키 제약조건 
foreign key (cnum_fk) references mclass (cnum)
);

show tables;

desc student;

-- 홍길동 부산시 1번학급
insert into student(name, tel, addr)
values('홍길동', '0101', '부산시');

select * from student;

insert into student(name, tel, addr, cnum_fk)
values('김길동', '010-1', '부산시', 1);

insert into student(name, tel, addr, cnum_fk)
values('김길동', '010-1', '부산시', 2);

insert into student(name, tel, addr, cnum_fk)
values('김수진', '01', '부산', '3');

insert into student(name, tel, addr, cnum_fk)
values('이수진', '01', '부산', '1');

-- 두 개의 테이블로 정규화
-- join 문을 이용해서 하나로 합칠 수 있다.alter

-- select 컬럼명1, 컬럼명2, ... from 테이블1
-- join
-- 테이블2
-- on 테이블1pk = 테이블fk

select cnum, cname, name, tel, addr, cnum_fk, croom
from mclass join student
on mclass.cnum = student.cnum_fk and mclass.cnum=2;

select * from student;

-- mclass의 2번 학급 명칭을 'ai웹'으로 수정
update mclass set cname = 'ai웹' where cnum = 2;

select * from mclass;

select * from dept;

select * from emp;

select * from salgrade;

select * from member;
select * from category;
select * from products;
select * from supply_comp;

select * from emp;

 -- 사번, 사원명, 급여, 입사일 
 
 select empno, ename, sal, hiredate
 from emp;

-- 산술 표현식
select ename, sal, sal+300 from emp;
select empno, ename, sal, comm, sal+comm from emp;

-- null 값이 연산에 사용될 경우 결과는 null로 나온다
-- null 값을 0으로 치환하여 변환하는 함수 ifnull()을 이용해야 한다
select empno, ename, sal, comm, sal+comm, sal+ifnull(comm, 0) as "1년 월급" from emp;






