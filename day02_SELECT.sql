-- ctrl + T : 새로운 sql 탭이 열림
-- day02_SELECT.sql
-- ctrl + enter: 커서 있는 위치의 쿼리문 실행 (번개1 버튼)
-- ctrl + shift + enter : 전체 실행 (번개 버튼 )

show databases;
use schooldb;
show tables;
select * from dept;
select * from emp;
select * from salgrade;
select * from category;
select * from products;
select * from supply_comp;

select empno, ename, sal, comm, hiredate from emp; -- 원하는 컬럼만 볼 수 있음
select ename from emp;
select * from emp; -- 모든 컬럼

select ename, sal, comm, sal+comm from  emp; -- null값이 있는 컬럼과 연산하면 null값 나옴 
-- ifnull(컬럼, 값) : 연산 때 컬럼 값을 사용하는데, 만약 컬럼에 null값이 들어있다면 입력한 값을 사용하라 

-- 컬럼 별칭 부여 : 컬럼명 as "별칭": 별칭 주고 싶은 컬럼 바로 뒤에 작성. as, "" 생략 가능 
select ename, sal, comm, job, sal*12+ifnull(comm, 0) as "연봉" from emp;

-- concat(컬럼1, 컬럼2) : 컬럼1과 컬럼2를 결합하고자 할 때 사용한다.
select concat('My', 'S', 'QL');

select concat(ename, ' Is A ', job) from emp;

-- 문제] emp테이블에서 이름과 연봉을  "KING: 1 YEAR SALARY = 60000"
-- 형식으로 출력하라 

select concat(ename, ': 1 year salary = ', sal*12+ifnull(comm, 0)) as "사원의 연봉" from emp
order by sal*12+ifnull(comm, 0) desc;

-- DISTINCT : 중복된 행을 제거하고 하나로 보여준다. 
-- EMP에서 업무(JOB)를 모두 출력하세요 
select job from emp;

-- emp에서 담당하고 있는 업무의 종류를 출력하세요 -> distinct 사용
select distinct job from emp;

select * from member;
select distinct name, age from member;

-- emp에서 중복되지 않는 부서번호(DEPTNO)
select distinct deptno from emp;

-- member 테이블에서 이름, 나이, 직원을 보여주세요
select name, age, job from member order by name asc;

-- member 테이블에서 회원의 이름과 적립된 마일리지를 보여주되,
--       마일리지에 13을 곱한 결과를 "MILE_UP"이라는 별칭으로
     -- 	      함께 보여주세요.
select name, ifnull(mileage, 0)*13 as mile_up from member;

-- where 절을 이용해서 조건을 걸 수 있다.
-- emp에서 급여가 3000이상인 사원의 사번, 이름, 업무, 급여를 출력하세요 
select empno, ename, job, sal from emp
where sal >= 3000;

--  wghol
-- where group by, having, order by, limit 순서 

-- 문자열, 날짜는 ' '를 붙여서 사용한다
-- job이 manager인 사원의 이름, 업무, 입사일을 보여주세요
select ename, job, hiredate from emp where job = 'manager';

 -- EMP테이블에서 1982년 1월1일 이후에 입사한 사원의 
	-- 사원번호,성명,업무,급여,입사일자를 출력하세요.
select empno, ename, job, sal, hiredate from emp
where hiredate > '1982-01-01';

select * from emp;
-- emp에서 급여가 1300~1500사이인 사원의 이름, 업무, 급여, 부서번호 출력하세요 
select ename, job, sal, deptno from emp 
where sal BETWEEN 1300 and 1500;

    -- emp테이블에서 사원번호가 7902,7788,7566인 사원의 사원번호,
    -- 이름,업무,급여,입사일자를 출력하세요.
    select ename, job, sal, hiredate from emp
    where empno = 7902 or empno = 7788 or empno = 7566;
    
    select ename, job, sal, hiredate from emp
    where empno in(7902 , 7788, 7566);
    
    -- 10번 부서가 아닌 사원의 이름,업무,부서번호를 출력하세요
select ename, job, deptno from emp
where deptno <> 10 order by 1; -- order by는 숫자로 지정할 수 있다. 여기는 첫번째로 설정한 ename

-- [문제]
	-- emp테이블에서 업무가 SALESMAN 이거나 PRESIDENT인
	-- 사원의 사원번호,이름,업무,급여를 출력하세요.
    select empno, ename, job, sal, comm from emp
    where job = 'salesman' or job = 'president';
	
	-- 커미션(COMM)이 300이거나 500이거나 1400인 사원정보를 출력하세요
select empno, ename, job, sal, comm from emp
    where comm= '300' or comm= '500' or comm= '1400';

	-- 커미션이 300,500,1400이 아닌 사원의 정보를 출력하세요
select empno, ename, job, sal, comm from emp
    where comm not in (300, 500, 1400);
    
    select empno, ename, job, sal, comm from emp
    where comm!= '300' and comm!= '500' and comm!= '1400';

-- Like 연산자
-- where 컬럼명 like '조건'
-- where 컬럼명 like '%조건'
-- where 컬럼명 like '조건%'
-- where 컬럼명 like '%조건%'

-- 이름이 s로 시작하는 사원정보 
select ename, job from emp
where ename like 's%';

select ename, job from emp
where ename like '%s';

select ename, job from emp
where ename like '%s%';

-- 이름 두 번째에 O자가 들어가는 사원정보 보여주세요 
select ename, job from emp
where ename like '_O%';

-- EMP테이블에서 입사일자가 82년도에 입사한 사원의 사번,이름,업무
-- 	   입사일자를 출력하세요.	 
select empno, ename, job, hiredate from emp
where hiredate like '1982%';

select empno, ename, job, hiredate from emp
where date_format(hiredate, '%Y') like '1982'; -- '%Y' : 날짜를 년도만 추출

-- 고객(member) 테이블 가운데 성이 김씨인 사람의 정보를 보여주세요.
select * from member;
select name, age from member
where name like '김%';

-- 고객 테이블 가운데 '강남구'가 포함된 정보를 보여주세요.
select name, age, addr from member
where addr like '%강남구%';

select date_format(hiredate, '%Y'), date_format(hiredate, '%y') from emp; -- '%Y' 는 네자리 '%y'는 두자리 

-- emp에서 comm이 널인 사원의 사번, 이름 , 커미션을 가져와 출력하세요
-- null값을 비교할 때는 = 로 비교하면 데이터를 가져오지 못한다.
-- null값의 비교는 is null 연산자를 사용한다.
select empno, ename, comm from emp
where comm = null;  -- 데이터 출력 안 됨

select empno, ename, comm from emp
where comm is null; -- 데이터 출력 됨

select empno, ename, comm from emp
where comm is not null; 

-- and : 양쪽 조건이 true이면 true를 반환
-- or : 하나라도 true 이면 true를 반환
-- not : false 이면 true

-- EMP테이블에서 급여가 1100이상이고 JOB이 MANAGER인 사원의
-- 	사번,이름,업무,급여를 출력하세요.
select empno, ename, job, sal from emp
where sal >=1100 or job = 'manager';

-- EMP테이블에서 급여가 1100이상이거나 JOB이 MANAGER인 사원의
-- 	사번,이름,업무,급여를 출력하세요.
 
	
-- EMP테이블에서 JOB이 MANAGER,CLERK,ANALYST가 아닌
-- 	  사원의 사번,이름,업무,급여를 출력하세요.
select empno, ename, job, sal from emp
where job not in('MANAGER','clerk','ANALYST');


-- [문제]
-- 	- EMP테이블에서 급여가 1000이상 1500이하가 아닌 사원의 모든 정보를 출력하세요
select * from emp
where sal not between 1000 and 1500;

select * from emp
where sal <1000 or sal> 1500;

--         - EMP테이블에서 이름에 'S'자가 들어가지 않은 사람의 이름을 모두
-- 	  출력하세요.
select ename from emp
where ename not like '%s%';

-- 	- 사원테이블에서 업무가 PRESIDENT이고 급여가 1500이상이거나
-- 	   업무가 SALESMAN인 사원의 사번,이름,업무,급여를 출력하세요.
select empno, ename, job, sal from emp
where (job = 'president' and sal >= 1500) or job =  'salesman'; -- or 보다 and 연산자가 우선 처리 된다


-- 	- 고객(Member) 테이블에서 이름이 홍길동이면서 직업이 학생인 정보를 
-- 	    모두 보여주세요.
select * from member
where name = '홍길동' and job = '학생' order by name asc;

-- 	- 상품(products) 테이블에서 제조사(COMPANY)가 삼성 또는 대우 이면서 
-- 	   판매가가 100만원 미만의 상품 목록을 보여주세요.
select * from products
where (company = '삼성' or company = '대우' )and output_price <1000000;

-- 연산자 우선순위
-- 비교 연산자 > not > and > or

-- order by 절
-- asc : 오름차순( 디폴트)
-- desc : 내림차순 
-- null 값 오름차순에서는 제일 뒤에, 내림차순에서는 제일 먼저 온다. 

-- emp에서 사번, 이름, 업무, 입사일을 가져와 출력하되 입사일자 순으로 가져오세요 
select empno, ename, job, hiredate from emp order by hiredate; 

select empno, ename, sal, sal*12 annsal from emp order by sal*12 desc;


select empno, ename, sal, sal*12 annsal from emp order by annsal asc;

select empno, ename, sal, sal*12 annsal from emp order by  4;

-- 사원 테이블에서 부서번호로 정렬한 후 부서번호가 같을 경우
-- 	급여가 많은 순으로 정렬하여 사번,이름,업무,부서번호,급여를
-- 	출력하세요.
select empno, ename, job, deptno, sal from emp
order by deptno, sal desc;
    
-- 사원 테이블에서 첫번째 정렬은 부서번호로, 두번째 정렬은
-- 	업무로, 세번째 정렬은 급여가 많은 순으로 정렬하여
-- 	사번,이름,입사일자,부서번호,업무,급여를 출력하세요.
select empno, ename, job, deptno, sal from emp
order by deptno, job, sal desc;

-- 1] 상품 테이블에서 판매 가격이 저렴한 순서대로 상품을 정렬해서 
--     보여주세요.
select * from products
order by output_price;

-- 2] 고객 테이블의 정보를 이름의 가나다 순으로 정렬해서 보여주세요.
--       단, 이름이 같을 경우에는 나이가 많은 순서대로 보여주세요.
select * from member
order by name, age desc;

-- 3] 상품 테이블에서 배송비의 내림차순으로 정렬하되, 
--     같은 배송비가 있는 경우에는 마일리지의 내림차순으로 정렬하여 보여주세요.
select * from products
order by trans_cost, mileage desc;

select products_name, input_price, output_price
from products
order by 2 desc limit 3; -- limit 숫자 : 탑 숫자 만큼의 데이터만 보여줌 

select products_name, input_price, output_price
from products
order by 2 desc limit 3 offset 3; -- offset (숫자): 인덱스 (숫자)의 데이터부터 출력

select products_name, input_price, output_price
from products
order by 2 desc;

-- 1] 사원테이블에서 급여가 3000이상인 사원의 정보를 모두 출력하세요.
select * from emp
where sal>=3000;

-- 2] 사원테이블에서 사번이 7788인 사원의 이름과 부서번호를 출력하세요
select ename, deptno from emp
where empno = 7788;

-- 3] 사원테이블이서 입사일이 1981 2월20일 ~ 1981 5월1일 사이에
--     입사한 사원의 이름,업무 입사일을 출력하되, 입사일 순으로 출력하세요.
select ename, job, hiredate from emp
where hiredate between '1981-02-20' and '1981-05-01'
order by hiredate;

-- 4] 사원테이블에서 부서번호가 10,20인 사원의 이름,부서번호,업무를 출력하되
-- 	    이름 순으로 정렬하시오.
select ename, deptno, job from emp
where deptno in( 10, 20)
order by ename;

-- 	5] 사원테이블에서 1982년에 입사한 사원의 모든 정보를 출력하세요.
select * from emp
where date_format(hiredate, '%Y') like '1982';
-- 	6] 사원테이블에서 보너스가 급여보다 10%가 많은 사원의 이름,급여,보너스
-- 	    를 출력하세요.
select ename, sal, comm from emp
where sal*1.1 < comm;

-- 7] 사원테이블에서 업무가 CLERK이거나 ANALYST이고
-- 	     급여가 1000,3000,5000이 아닌 모든 사원의 정보를 
-- 	     출력하세요.
select * from emp
where job in ('clerk', 'analyst') and sal not in (1000, 3000, 5000);

-- 	8] 사원테이블에서 이름에 L이 두자가 있고 부서가 30이거나
-- 	    또는 관리자가 7782번인 사원의 정보를 출력하세요.
select * from emp
where ename like '%ll%' and (deptno =30 or mgr = 7782);