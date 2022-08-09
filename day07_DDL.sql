-- day07_DDL.sql

-- ddl: create, drop, alter
-- 테이블 생성
/* -- 컬럼 수준에서 제약
	create table 테이블명(
		컬럼명 컬럼타입 제약조건 
        ... 
	);
    
    -- 테이블 수준에 제약
	create table 테이블명(
		컬럼명 컬럼타입,
        ... ,
        제약조건
	);
*/

-- 테이블 수준에서 제약 
create table test_tab1(
	id int,
    name varchar(10),
    constraint test_tab1_id_pk primary key (id) -- 테이블 지정해서 pk 주기
);

desc test_tab1;

-- 컬럼 수준에서 제약
create table test_tab2(
	id int primary key,
    name varchar(10)
);

desc test_tab2;

-- 제약 조건 삭제
-- alter table 테이블명 drop 제약조건 유형
-- test_tab1에서 primary key 제약조건을 삭제하세요
alter table test_tab1 drop primary key;

desc test_tab1;

-- 제약 조건 추가
-- alter table 테이블명 add 제약조건유형 (컬럼명);

-- test_tab1 에 primary key 제약조건을 다시 추가하세요
alter table test_tab1 add primary key (id); 

alter table test_tab1 add constraint test_tab1_id_pk primary key (id); 

desc test_tab1;

-- 예약 테이블을 아래와 같은 조건으로 생성하세요
/*
	num int 
    userid varchar(16)
    reserve_date date
    room_num smallint
    room_type enum('single', 'double')
    
    num 컬럼에 primary key 제약조건을 테이블 수준에서 주기 
*/
drop table resevation;
create table reservation(
	num int ,
    constraint test_tab3_num_pk primary key (num), -- 혹은 primary key (num) 만 줘도 됨
    userid varchar(16),
    reserve_date date default (current_date), -- 디폴트로 현재시간이 들어가게 함 
    room_num smallint unsigned, -- unsigned = 양수만들어감
    room_type enum('single', 'double')
);
insert into reservation
values(1, 'hong', curdate(), 101, 'single');

insert into reservation
values(2, 'kim', curdate(), 201, 'double');

desc reservation;
select * from reservation;

-- 2. foreign key (외래키) 제약 조건
-- 부모 테이블의 기본키를 참조하는 컬럼 또는 컬럼들의 집합 
-- 기본키의 컬럼과 외래키의 자료형이 일치해야 한다
-- 외래키에 의해 참조되고 있는 기본키는 삭제할 수 없다
-- on elete cascade / on update cascade 옵션을 주면
-- 정의된 외래키는 그 기본키가 삭제(수정) 될 때 같이 삭제(수정) 된다.


-- master 테이블
create table dept_tab(
	deptno int,
    dname char(14),
    loc char(15),
    primary key (deptno)
    );
    
-- detail 테이블
create table emp_tab(
	empno int primary key,
    ename varchar(10),
    job varchar(10),
    mgr int,
    hiredate datetime default now(),
    sal decimal(7,2),
    comm decimal(7,2),
    deptno int,
    foreign key (deptno) references dept_tab (deptno) on delete cascade,
    -- mgr 컬럼을 외래키로 제약하자. empno를 참조하도록
    foreign key (mgr) references emp_tab (empno)
);
drop table emp_tab;
desc emp_tab;

insert into emp_tab(empno, ename, deptno)
values(1111, 'scott', 1);
insert into emp_tab(empno, ename, deptno)
values(2222, 'smith', 2);

insert into emp_tab(empno, ename, deptno)
values(3333, 'bob', 3);
    
select * from dept_tab;
select * from emp_tab;

insert into dept_tab
values(1, 'accounting', 'newyork');
insert into dept_tab
values(2, 'sales', 'newyork');
insert into dept_tab
values(3, 'operation', 'seoul');

delete from dept_tab where deptno = 3;
-- on delete cascade를 주면 해당 부서의 소속된 사원이 있어도 해당부서를 삭제할 수 있다.
rollback;
select *from dept;
select * from dept_tab;
    
create table uni_tab(
num int auto_increment primary key,
namer varchar(10) not null,
userid varchar(8),
unique (userid)
);
    
desc uni_tab;

insert into uni_tab
values(null, '김영희', null);
    
select * from uni_tab;
    
-- 4. not null 제약조건
-- null 값이 들어가는것을 방지한다

create table nn_tab(
	deptno int not null,
    dname varchar(10)
);
    
desc nn_tab;

insert into nn_tab values(1, null);

insert into nn_tab values(null, 'tom'); -- deptno 는 not null이기 때문에 꼭 값을 넣어줘야 한다.

select * from nn_tab;

-- 컬럼 추가
alter table nn_tab add loc char(10);

-- dname에 not null추가하기 
alter table nn_tab modify column dname varchar(10) not null; -- 이미 null 값이 있어서 변경 불가. null 말고 일반값 있으면 실행됨
    
delete from nn_tab; -- nn_tab 초기화
commit; -- 커밋 
select * from nn_tab;
desc nn_tab;
    
    
-- 5. check 제약 조건
-- 행이 만족해야 하는 조건을 정의한다.

create table member_tab(
	num int auto_increment primary key, -- auto_increment 하려면 primary key도 함께 줘야함
    name varchar(20) not null,
    age tinyint unsigned null check( age >19), -- 홀수 허용하지 않음
    phone char(13)
);

desc member_tab;

insert into member_tab
values(null, '홍길동', 20, '1111');
insert into member_tab
values(null, '홍길동', 2, '1112');
-- Error Code: 3819. Check constraint 'member_tab_chk_1' is violated. : chk 는 체크제약조건을 말한다
-- 체크제약 조건 때문에 저장 안 된다는 뜻


select * from member_tab;

use schooldb;

create table if not exists user_tab(
	no int,
    name varchar(20),
    userid varchar(25),
    tel char(13),
    email varchar(50),
    primary key (no),
    unique (userid)
);

select * from user_tab;

desc user_tab;

-- name 컬럼에 not null 제약 조건 추가
-- not null 제약조건을 컬럼 수준에서 제약해야 한다.
alter table user_tab modify name varchar(20) not null;

create table if not exists board(
	idx int auto_increment primary key,
    userid varchar(15),
    title varchar(100),
    content varchar(1000),
    writedate datetime default now(),
    foreign key (userid) references user_tab (userid)
);

desc board;

-- subquery 를 이용한 테이블 생성

-- create table 테이블명 as subquery

-- 사원 테이블에서 30번 부서에 근무하는 사원의 정보만 추출하여
-- 	          EMP_30 테이블을 생성하여라. 단 열은 사번,이름,업무,입사일자,
-- 		  급여,보너스를 포함한다
create table emp_30
as select empno, ename, job, hiredate, sal, comm from emp
where deptno = 30;

select * from emp_30;

-- [문제1]
-- 		EMP테이블에서 부서별로 인원수,평균 급여, 급여의 합, 최소 급여,
-- 		최대 급여를 포함하는 EMP_DEPTNO 테이블을 생성하라.

create table emp_deptno
as select deptno, count(*) cnt, avg(sal) avg_sal, sum(sal) sum_sal,
 min(sal) min_sal, max(sal) max_sal from emp
group by deptno;

select * from emp_deptno;
-- 		
-- 	[문제2]	EMP테이블에서 사번,이름,업무,입사일자,부서번호만 포함하는
-- 		EMP_TEMP 테이블을 생성하는데 자료는 포함하지 않고 구조만
-- 		생성하여라.

create table emp_temp
as select empno, ename, job, hiredate, deptno
from emp where 1=4;

select * from emp_temp;

-- drop table [if exists] 테이블명; -- if exists =  존재한다면~

drop table emp_temp;

-- alter 문장 
-- 컬럼 추가/ 변경 / 삭제하고자 할 때 사용 

-- 추가 
-- alter table 테이블명 add 추가할 컬럼정보
-- 수정
-- alter table 테이블명 modify 수정할 컬럼정보
-- 삭제
-- alter table 테이블명 drop column 삭제할 컬럼명 
-- 컬럼명 수정
-- -- alter tabel 테이블명 rename column old_col to new_col

create table test_tab(
no int);

-- test_tab에 name 컬럼을 추가하세요 varchar(20) not null 
alter table test_tab add name varchar(20);
alter table test_tab modify name varchar(20) not null;

select * from test_tab;
desc test_tab;

-- test_tab no 컬럼의 자료형을 char(2)로 수정하세요
alter table test_tab modify no char(2);

-- test_tab의 name컬럼을 삭제하세요
alter table test_tab drop column name;

-- test_tab의 no 컬럼명을 num 으로 변경
-- alter tabel 테이블명 rename column old_col to new_col
alter table test_tab rename column no to num; 

-- view
-- 가상의 테이블
-- 데이터의 복잡성을 감소시킴 
-- 복잡한 질의문을 단순화시킨다 
-- 테이블 데이터를 다양한 관점으로 보여준다

-- create view 뷰이름
--  as select 컬럼명1, 컬럼명2 from 테이블명 where 조건절 

-- EMP테이블에서 20번 부서의 모든 컬럼을 포함하는 EMP20_VIEW를 생성하라.
create view emp20_view
as select * from emp where deptno = 20;

select * from emp20_view;

-- EMP테이블에서 30번 부서만 EMPNO를 EMP_NO로 ENAME을 NAME으로
-- 	SAL를 SALARY로 바꾸어 EMP30_VIEW를 생성하여라
create view emp30_view
as select empno emp_no, ename name, sal salary from emp
where deptno = 30;

select * from emp30_view;

-- 고객테이블의 고객 정보 중 나이가 19세 이상인
-- 	고객의 정보를
-- 	확인하는 뷰를 만들어보세요.
-- 	단 뷰의 이름은 MEMBER_19로 하세요.
create view member_19
as select * from member
where age >= 19;

-- category와 products, supply_comp 3개의 테이블을 join하여
-- view 를 생성하세요. products_info_view

create or replace view products_info_view
as select c.*, p.*, s.*
from category c join products p
on c.category_code = p.category_fk
join supply_comp s
on p.ep_code_fk = s.ep_code;

select * from products_info_view;

-- with check option 절 이용
create or replace view emp10_view
as select * from emp
where deptno = 10 with check option;

select * from emp10_view;

update emp10_view set job= 'salesman' where empno = 7782;

-- view를 수정하면 원본 테이블도 변경이 된다. 
update emp10_view set deptno = 20 where empno = 7782; -- 안 됨. 위에 with check option을 줬기 때문임
update emp set deptno=20 where empno = 7782; -- 그래서 원본 테이블에서 그냥 수정해야함

-- 뷰 소스 확인
show create view emp10_view;

-- 뷰 삭제
-- drop view 뷰이름

drop view emp10_view;

-- index 생성
-- create index 인덱스명 on 테이블명 (컬럼명1[, 컬럼명2])  대괄호는 옵션이다. 

-- emp의 ename 컬럼에 대해 인덱스를 생성하세요 emp_ename_indx
create index emp_ename_indx on emp (ename); 

-- index확인
-- show index from 테이블명;
show index from emp;

-- alter로 인덱스 추가
alter table member add index member_name_indx(name);
show index from member;

select * from member where name like '%홍%';

-- 인덱스 삭제
-- drop index 인덱스명;
-- alter table 테이블명 drop index 인덱스명

alter table member drop index member_name_indx;

show index from member;

-- 상품 테이블에서 인덱스를 걸면 좋을 컬럼을 찾아 인덱스를 생성하세요
create index products_category_indx on products (category_fk);
create index products_ep_code_indx on products (ep_code_fk);

show index from products;

-- products_category_indx/products_ep_code_indx 삭제하세요
alter table products drop index products_category_indx;
alter table products drop index products_ep_code_indx;


create table zipcode(
	post1 char(3),
    post2 char(3),
    constraint zipcode_pk primary key (post1, post2), 
    addr varchar(100) not null
);

select * from zipcode;
desc zipcode;

create table members_tab(
	id varchar(16) primary key,
    name varchar(30) not null,
    gender char(1),
    jumin1 char(6),
    jumin2 char(7),
	tel varchar(15),
    post1 char(3),
    post2 char(3),
    addr1 varchar(100),
    addr2 varchar(100),
    foreign key (post1, post2) references zipcode(post1, post2),
    constraint members_tab_jumin1_jumi2 unique(jumin1, jumin2),
    check (gender in ('M', 'F'))
);

desc members_tab;