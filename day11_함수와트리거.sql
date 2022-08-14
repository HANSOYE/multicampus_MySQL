-- day11_함수와트리거.sql

-- stored function
-- 프로시저와 비슷하지만 차이점은 함수의 경우 return 값을 반환해야 한다. 
-- 함수의 매개변수는 모두 in 파라미터다. in을 붙이지 않는다. 
-- 프로시저는 호출 시 call을 이용하지만, 함수는 select문 안에서 호출된다. 

-- 2개의 정수를 매개변수로 받아서 두 정수의 합을 반환하는 함수
delimiter //
create function plus(x int , y int)
returns int
begin
	return x+y;
end //
delimiter ;

-- 함수호출

select plus(10, 20);
/*
Error Code: 1418. This function has none of DETERMINISTIC, NO SQL, 
or READS SQL DATA in its declaration and binary logging is enabled 
(you *might* want to use the less safe log_bin_trust_function_creators variable)
*/

-- 저장함수를 사용하기 위해서는 함수 생성 권한을 허용해줘야 한다.
set global log_bin_trust_function_creators =1;

-- [문제1] 인파라미터로 사원명을 전달하면 해당 사원의 사번을 반환해주는
--       스토어드 함수를 작성하시오.
delimiter //
create function get_no(pname varchar(20))
returns int 
begin
	declare veno int;
    select empno
    into veno
    from emp where ename = pname;
    return veno;
end //
delimiter ;

select get_no('scott');

-- [문제2] member테이블에서 회원이 가입한 년도(REG_DATE)이후 현재 시점까지 몇년이 되었는지
-- 	계산해서 반환해주는 함수를 작성하시오.

delimiter //
create function calcYear(pnum int)
returns int
begin
	declare yy1 int; -- 가입일 
    declare gap_year int; -- (현재년도 - 가입년도)
    
    select year(reg_date) -- 년도를 가져와서 
    into yy1 -- yy1에 넣어준다
    from member where num = pnum;
    set gap_year = (year(curdate()) - yy1);
    return gap_year;
end //
delimiter ;

select calcYear(1);
select name, reg_date from member where num =1;

-- trigger 
-- insert/update/delete 등 dms 문장이 수행될 때 자동으로 수행되는 일종의 프로시저이다
-- emp2에서 사원정보를 삭제하면 삭제된 사원정보다 retired_emp 테이블에 저장되도록
-- 트리거를 구현해보자

create table retired_emp
as select * from emp2 where 1=2;

select * from retired_emp;

drop trigger if exists emp_del_trg;
delimiter //
create trigger emp_del_trg
	after delete on emp2 
    for each row
begin
	-- 트리거에서 사용하는 임시 테이블 : old, new
    insert into retired_emp
    values(old.empno, old.ename, old.job, old.mgr, old.hiredate, old.sal, old.comm, old.deptno);
    
end //
delimiter ;

-- emp2의 레코드를 삭제하면 자동으로 trigger가 수행된다.

select * from emp2;
select * from retired_emp;

delete from emp2 where empno = 7499;

-- insert 문 : 새로들어온 데이터 => new 에 보관한다. "new.컬럼명"
-- delete 문 : 기존에 삭제된 데이터 => old 에 보관함 "old.컬럼명"
-- update 문 : 수정된 새로운 데이터 => new 에 보관 
-- 				수정되기 전의 데이터 => old에 보관 		  

create table emp_log
as select empno, ename, job, deptno from emp2
where 1=0;
select * from emp_log;

-- emp_log 테이블에 컬럼 추가하기
-- modtype : I, D, U char(1)
-- moddate : 데이터 수정일 date
-- moduser : 변경한 사용자 varchar(30)

alter table emp_log add modtype char(1);
alter table emp_log add moddate date;
alter table emp_log add moduser varchar(30);
desc emp_log;

-- emp2를 수정할 때 발생되는 트리거를 작성하되
-- 수정된 사원의 사번, 이름, 업무, 부서번호, 'U', 현재날짜, current_user()
-- emp_log에 insert하는 트리거를 작성하세요 

