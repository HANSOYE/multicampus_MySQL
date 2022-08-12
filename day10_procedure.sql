-- day10_procedure.sql

-- 프로시저에서 제어문 활용
/*
	if 조건 then
		실행문 
	elseif 조건 then 
		...
	else
		실행문
	end if;
*/

-- 사번을 인파라미터로 전달하면 해당 사원의 부서번호와 부서명을 출력하는 프로시저 
drop procedure dept_find;
delimiter //
create procedure dept_find(in empno_find int)
begin
	declare vname varchar(20); -- 사원명 
    declare vdno int; -- 부서번호 
    declare vdname varchar(30); --
    
    -- emp에서 사번으로 사원명, 부서번호 가져와서 변수들에 할당하기 
    select ename, deptno
    into vname, vdno 
    from emp where empno =empno_find;
    -- if문을 이용해서 dname에 값을 할당하세요 
    -- 10: 회계부서, 20: 연구부서, 30: 영업부서, 40: 운영 부서
    -- set vdname = '회계부서'
    if vdno = 10 then
		set vdname = '회계부서';
	elseif  vdno = 20 then
		set vdname = '연구부서';
	elseif vdno = 30 then
		set vdname = '영업부서';
	else 
		set vdname = '운영부서';
	end if;
    
    select empno_find, vname, vdno, vdname;
end //
delimiter ;

select * from emp;

call dept_find(7369);

-- [2] 반복문 : loop문
/*
	라벨 : loop
		실행문장;
        if 조건 then
			leave 라벨;
    end loop;
    
    loop~end loop는 if문이 없으면 무한루프 돈다. 

*/
-- loop문을 이용해서 emp2에 사번, 사원명, 급여, 업무를 insert하는 프로시저 작성해보자 
delimiter //
create procedure emp2_insert(in pname varchar(10))
begin 
	declare vcnt int;
    set vcnt = 8500;
    
    mylabel: loop
		-- insert문 수행하되 vcnt를 empno로 넣기
        -- 사원명은 pname으로, 급여는 (vcnt-2000)으로 넣기, 업무 : salesman
        -- vcnt값은 반복문 돌면서 10씩 증가시킨다. vcnt값이 8600이 되었을 때 루프 벗어난다.
        insert into emp2(empno, ename, sal, job)
        values(vcnt, pname, (vcnt-2000), 'salesman');
        set vcnt = vcnt +10;
        if vcnt >=8600 then
			leave mylabel;
		end if;
    end loop;
		select '루프문 수행 완료';
end //
delimiter ;

select * from emp2;
select * from emp2 order by 1 desc;
call emp2_insert('peter');

-- 루프문 : while 루프문
-- 조건이 true일 경우만 반복되는 루프문이다. 
/*
	while 조건 do 
		실행문;
        증감식; 
	end while;
*/

drop procedure while_test;
delimiter //
create procedure while_test()
begin
	-- 변수를 선언해서 1~100까지의 합을 구해 출력하는 프로시저를 작성하세요
    -- 단 while루프문을 이용해서 합을 구하세요
    declare i int;
	declare sum int;
	set i = 1;
	set sum = 0;
	while i <= 100 do
		set sum = sum+i;
		set i = i+1;
	end while;
	select sum as '1부터 100까지 합';

end //
delimiter ;

call while_test();

-- 프로시저에서 동적인 sql문 활용 
-- 테이블명을 인파라미터로 전달하면 해당 테이블의 데이터를 조회하는 프로시저를 작성해보자 

delimiter //
create procedure dynamic(in tname varchar(30))
begin 
	-- 변수 선언해서 select문 할당
    set @query = concat('select * from ', tname);
    -- [1] 동적인 sql문을 실행시킬 준비
	prepare myq from @query; -- myq를 준비시킴 
    -- [2] sql문을 실행 
    execute myq; -- myq를 실행 
    -- [3] 준비했던 동전인 sql문을 해제 
    deallocate prepare myq; -- myq를 해제
end //
delimiter ;

call dynamic('category');
call dynamic('emp');
call dynamic('dept');

-- select 문에 의한 결과가 다중 레코드일 때는 cursor를 이용해야 한다.
-- CURSOR : 질의 결과 얻어진 여러 행이 저장된 메모리상의 위치
-- 	  여러 행을 처리하기 위해서는 명시적 커서를 사용하여
-- 	  커서를정의하고 열고 커서를 이용하여 데이터를 읽고 닫을 수 있다.

-- emp에서 모든 사원명, 업무, 입사일을 가져와 출력하는 프로시저를 작성하세요 
-- empall()

delimiter //
create procedure empall()
begin
	declare vname varchar(20);
    declare vjob varchar(20);
    declare vdate date;
    
    select ename, job, hiredate
    into vname, vjob, vdate
	from emp order by 1;
    
    select vname, vjob, vdate as "모든 사원 정보";
end //
delimiter ;

call empall();
/* cursor를 이용하지 않아서 나타나느 오류
12:07:21	call empall()	Error Code: 1172. Result consisted of more than one row	0.000 sec
*/
-- 1개의 레코드를 초과하는 결과셋이 있을 경우는 커서를 선언해서 커서를 이동시켜가면서 데이터를 인출해야한다. 

drop procedure if exists empall;

delimiter //
create procedure empall()
begin
	declare vname varchar(20);
    declare vjob varchar(20);
    declare vdate date;
    
    declare endOfRow boolean default false; -- 레코드가 있는지 여부를 판단할 변수 선언
    -- [1] 커서 선언
    declare ecr cursor for
		select ename, job, hiredate from emp order by 1;
	-- 반복조건을 준비하는 키워드 : declare continue handler for
	declare continue handler for
		not found set endOfRow = true; -- 더 이상의 행이 발견되지 않을 경우 set 절을 수행한다
    -- [2] 커서를 오픈
    open ecr;
    -- [3] 반복문을 돌면서 커서로부터 데이터를 인출하기 (fetch) 
    -- 				( 이 때 반복문을 빠져나갈 조건을 걸어주자 )
    mloop:loop
		-- 커서에서 데이터 인출
        fetch ecr into vname, vjob, vdate;
		if endOfRow then
			leave mloop;
        end if;
        select vname, vjob, vdate;
    end loop;
    -- [4] 커서를 close 
    close ecr;
end //
delimiter ;

call empall();

-- [문제] 부서별 사원수와 급여 합계를 구하는 프로시저를 만들어보세요.
-- while문 사용하기 
delimiter $$
create procedure emp2all()
begin
	declare pjob varchar(15);
    declare cnt int;
    declare max int;
    declare av int;
    declare sm int;
    declare min int;
    
    declare endofrow boolean default false;
    
    declare ecr cursor for 
		select job,count(empno),max(sal),min(sal),sum(sal),round(avg(sal)) from emp2
        group by job;
        
	declare continue handler for
		not found set endofrow = true; 
        
    open ecr;
    -- if loop문
    -- mloop : loop
--         fetch ecr into pjob,cnt,max,min, sm, av;
-- 		if endofrow then
-- 			leave mloop;
-- 		end if;
--         select pjob,cnt,max,min, sm,av order by 1;
-- 	end loop;

-- while 루프문
	while endofrow = false do
		fetch ecr into pjob, cnt, max, min, sm, av;
        select pjob, cnt, max, min, sm, av order by 1;
    end while;
    
	close ecr;
end $$
delimiter ;
drop procedure if exists emp2all;
call emp2all();

















