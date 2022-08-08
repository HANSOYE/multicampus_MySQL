-- day06_서브쿼리.sql

-- 사원테이블에서 scott의 급여보다 많은 사원의 사원번호,이름,업무
-- 급여를 출력하세요.

use schooldb;

select sal from emp where ename = 'scott';

select empno, ename, job, sal from emp
where sal > 3000;

select empno, ename, job, sal from emp
where sal > (select sal from emp where ename = 'scott');

-- 문제1] 사원테이블에서 사원번호가 7521인 사원과 업무가 같고 급여가
-- 	 7934인 사원보다 많은 사원의 사번,이름,업무,입사일자,급여를
-- 	 출력하세요

select empno, ename, job, hiredate, sal from emp
where job = (select job from emp where empno = 7521) 
and sal > (select sal from emp where empno = 7934);

-- 단일 행을 반환하는 subquery
-- 문제2]사원테이블에서 급여의 평균보다 적은 사원의 사번,이름
-- 	업무,급여,부서번호를 출력하세요.
select empno, ename, job, sal, deptno from emp
where sal < (select avg(sal) from emp);

-- 문제3] 사원테이블에서 사원들의 부서별 최소급여가 20번 부서의 최소급여
-- 		보다 많은 부서번호를 출력하세요.
select deptno, min(sal) 
from emp
group by deptno
having min(sal) > (select min(sal) from emp where deptno = 20);

-- 업무별로 최대 급여를 받는 사원의  사원번호와 이름을 출력하세요.
-- 아래와 같이 쓰면 잘못된 결과가 나온다 : 스미스 =1300
select ename, empno, job, max(sal)
from emp
group by job
having max(sal);

select ename, job, sal
from emp
where (job, sal) in (select job, max(sal) from emp group by job);

-- 사원을 관리하는 사원의 정보를 보여주세요 
select empno, ename, job from emp e
where exists (select empno from emp where e.empno = mgr);

-- 다중열 서브쿼리
 -- 서브쿼리 결과값이 2개 이상의 컬럼을 반환하는 서브쿼리를 말함 
 
-- 부서별로 최소급여를 받는 사원의 부서번호, 사번,이름,급여를 출력하세요.
 -- 단 부서별로 정렬하세요.
select deptno, min(sal) from emp group by deptno;

select deptno, empno, ename, sal from emp
where (deptno, sal) in (select deptno, min(sal) from emp group by deptno)
ORDER BY DEPTNO;

-- from 절에서의 subquery (inline view)
-- EMP와 DEPT 테이블에서 업무가 MANAGER인 사원의 이름, 업무,부서명,
-- 	근무지를 출력하세요.
-- (1) join 문 이용해서 작성해보기
select ename, job, dname, loc
from emp e join dept d
using (deptno)
where job = 'manager';

-- (2) subquery를 이용해서 작성해보기
select ename, job from 
(select * from emp where job  ='manager') a join dept d
on a.deptno = d.deptno;


-- *SELECT문에서 서브쿼리 사용.
-- 	
-- 	84] 고객 테이블에 있는 고객 정보 중 마일리지가 
-- 	가장 높은 금액의 고객 정보를 보여주세요.
select * from member
where mileage = (select max(mileage) from member);

-- 	
-- 	85] 상품 테이블에 있는 전체 상품 정보 중 상품의 판매가격이 
-- 	    판매가격의 평균보다 큰  상품의 목록을 보여주세요. 
-- 	    단, 평균을 구할 때와 결과를 보여줄 때의 판매 가격이
-- 	    50만원을 넘어가는 상품은 제외시키세요.

select products_name, output_price from products
where output_price >
(select avg(output_price) from products where output_price <= 500000)
and output_price <=500000;

-- 	86] 상품 테이블에 있는 판매가격에서 평균가격 이상의 상품 목록을 구하되 평균을
-- 	    구할 때 판매가격이 최대인 상품을 제외하고 평균을 구하세요.
select avg(output_price) from products
where output_price >= (
select avg(output_price) from products
where output_price <> (select max(output_price) from products));

-- 87] 상품 카테고리 테이블에서 카테고리 이름에 컴퓨터라는 단어가 포함된 카테고리에
-- 	    속하는 상품 목록을 보여주세요.
select * from products
where category_fk
in (select category_code from category where category_name like '%컴퓨터%');

-- 88] 고객 테이블에 있는 고객정보 중 직업의 종류별로 가장 나이가 많은 사람의 정보를
-- 	    화면에 보여주세요.
select * from member
where (job, age) in (select job, max(age) from member
group by job);

-- ** UPDATE에서의 사용
-- 	89] 고객 테이블에 있는 고객 정보 중 마일리지가 가장 높은 금액을
-- 	     가지는 고객에게 보너스 마일리지 5000점을 더 주는 SQL을 작성하세요.	
update member set mileage = (mileage+5000)
where mileage = (select a.* from(select max(mileage) from member) a);
select * from member;


-- 	90] 고객 테이블에서 마일리지가 없는 고객의 등록일자를 고객 테이블의 
-- 	      등록일자 중 가장 뒤에 등록한 날짜에 속하는 값으로 수정하세요.
select name, reg_date, mileage from member where mileage = 0;
set @@autocommit = 0;
update member set reg_date = (select * from (select max(reg_date) from member) a)
where mileage = 0; 
rollback;

-- ** DELETE에서의 사용
-- 	91] 상품 테이블에 있는 상품 정보 중 공급가가 가장 큰 상품은 삭제 시키는 
-- 	      SQL문을 작성하세요.
select max(input_price) from products;	      
delete from products
where input_price = (select * from (select max(input_price) from products) a);

select products_name, input_price from products;
rollback;

-- 	92] 상품 테이블에서 상품 목록을 공급 업체별로 정리한 뒤,
-- 	     각 공급업체별로 최소 판매 가격을 가진 상품을 삭제하세요.

delete from products 
where (ep_code_fk, output_price)
in
(select * from (select ep_code_fk, min(output_price) 
from products
group by ep_code_fk) a);

-- emp2 테이블의 자료 중 부서명이 'sales'인 사원의 정보를 삭제하라
delete from emp2 where deptno = (select deptno from dept where dname = 'sales');

-- insert 에서 subquery 사용
-- category테이블을 카피해서 category2로 만들되 데이터 없이 구조만 복사하세요 
-- 그런 뒤에 category테이블의 데이터를 가져와서 category2에 insert하세요
create table category2 as select * from category
where 1=2;
select * from category2;

insert into category2
select * from category;
rollback;




















