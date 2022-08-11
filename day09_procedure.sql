-- day09_procedure.sql

use schooldb;
delimiter $$
create procedure show_msg()
begin
	declare my_msg varchar(50); -- 변수 선언
    set my_msg = 'Hello Stored Procedure';
    select my_msg;
end $$
delimiter ;

drop procedure show_msg;

-- 프로시저 호출
call show_msg();

-- 현재 시간에서 1시간 후와 3시간 전의 시각을 구하는 문장을 프로시저로 작성해봅시다.
drop procedure show_time;
delimiter //
create procedure show_time()
begin
	-- 변수 2개 선언 datetime 
    declare vdate1 datetime;
    declare vdate3 datetime;
    -- 실행문 작성 : now(), date_add(), date_sub()
    select date_add(now(), interval 1 hour),
    date_sub(now(), interval 3 hour) into vdate1, vdate3;
    select vdate1 as "1 시간 후", vdate3 as "3시간 전";
end //
delimiter ;

call show_time();

-- in 파라미터 사용 예제 (입력 매개변수)
-- 사번을 in 파라미터로 전달하면 해당 사원의 이름, 직업, 급여를 가져와 
-- 출력하는 프로시저를 작성해보자. 
drop procedure if exists emp_info;

delimiter //
create procedure emp_info(in pno int)
begin
	declare vname varchar(10);
    declare vjob varchar(10);
    declare vsal decimal(7,2);
    
    select ename, job, sal
    into vname, vjob, vsal
    from emp
    where empno = pno;
    
    select pno, vname, vjob, vsal;
end //
delimiter ;
use schooldb;
call emp_info(7788);
call emp_info(7369);

-- 부서번호를 인파라미터로 넘기면 해당 부서의 부서명과 근무지를 가져오는
-- 프로시저를 작성하세요
drop procedure emp_info2;
delimiter //
create procedure dept_info (in pno int)
begin 
   declare vdname varchar(10);
   declare vloc varchar(10);
   
   select dname, loc
   into vdname, vloc
   from dept
   where deptno = pno;
   
   select pno, vdname, vloc;
end  //
delimiter ;

call dept_info(30);

-- out 파라미터 사용 예제(출력 매개변수)

drop procedure emp_find;
delimiter //
create procedure emp_find(in pno int, out oname varchar(30))
begin
	select ename into oname
    from emp
    where empno = pno;

end //
delimiter ;

-- out 파라미터 프로시저를 실행하려면 호출하기 전에 아웃파라미터 위치에
-- "@변수명" 형태로 전달해줘야 함. 
call emp_find(7788, @empname);
select @empname as "7788 번 사원명";

select * from emp;

-- [실습] DEPT 테이블에서 부서번호를 IN 파라미터로 전달하면
-- 	해당 부서의 부서명, 부서위치를 가져와 출력하고
-- 	해당 부서의 평균임금, 최대임금, 최저임금을
-- 	OUT파라미터로 전달하는 프로시저를 작성하시오.

drop procedure if exists dept_stat;

delimiter //
create procedure dept_stat(in pno int, out avgsal decimal(7, 2), 
out maxsal decimal(7,2), out minsal decimal(7,2))
begin
	select avg(sal), max(sal), min(sal)
    into avgsal, maxsal, minsal
    from emp
    where deptno = pno;
end //
delimiter ;

call dept_stat(10, @avg, @mx, @mn);

select @avg, @mx, @mn;

-- inout 파라미터 사용 예제 
delimiter //
create procedure dept_stat2(inout pno int, out avgsal decimal(7, 2), 
out maxsal decimal(7,2), out minsal decimal(7,2))
begin
	select avg(sal), max(sal), min(sal)
    into avgsal, maxsal, minsal
    from emp
    where deptno = pno;
end //
delimiter ;

set @pno = 10;
call dept_stat2(@pno, @avg, @mx, @mn);

select @pno, @avg, @mx, @mn;

-- [문제1] EMP테이블과 관련  사원 등록 (사번,이름,급여, 업무)를 IN 파라미터로 받아 
-- 		데이터를 등록하는 프로시저를 작성하시오.

drop procedure emp_insert;
delimiter //
create procedure emp_insert(in pno int, in iname varchar(15), 
in isal int, in ijob varchar(10))
begin
	insert into emp(empno, ename, sal, job)
    values (pno, iname, isal, ijob);
end //
delimiter ;

call emp_insert(8888, 'peter', 4900, 'manager');

select * from emp order by 1 desc;

-- 	[문제2] EMP테이블과 관련 사번과 급여 인상률을 IN 파라미터로 전달하면 
-- 		해당 사원의 급여를 인상률 만큼 인상해주는 프로시저를 작성하시오.
-- update문 활용
drop procedure if exists emp2_update;
delimiter $$
CREATE PROCEDURE emp2_update(IN uempno int, IN usal int)
BEGIN
    update emp2 set sal=sal+(sal*(usal/100))
    where uempno=empno;
END $$
delimiter ;

select * from emp2;

use schooldb;
call emp2_update(7369, 20);

select * from emp2;


-- [문제3] 사번을 인 파라미터로 받아 해당 사원의 정보를 삭제하는 프로시저를 작성하시오.
delimiter //
create procedure emp2_delete(in empno_del int)
begin
	delete from emp2
    where empno = empno_del;
    select concat(empno_del, '번 사원정보를 삭제했습니다');
end //
delimiter ;

select * from emp2;

call emp2_delete(7369);











