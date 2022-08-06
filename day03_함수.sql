-- day03_함수.sql
-- [1] 반올림 abs(값)
select abs(-5), abs(+5);

-- member 테이블에서 이름, 나이와 함께 40세와의 나이 차이를 옆에 함께 보여주세요
select name, age, abs(40-age) "40살과의 나이차이" from member ;

-- [2] round(값), round(x, y) : 반올림 함수
-- round(숫자, 숫자2) : 숫자2는 소수점(숫자2)째 자리 이후부터 반올림 하겠다는 뜻
-- round(숫자) : default는 소수점 첫째자리에서 반올림한다.

select round(1.9999), round(1.88188,2); 
select round(4567.567), round(4567.567,0), round(4567.567,2), round(4567.567,-2);

-- [3] ceil(값), ceiling(n) : 올림함수
-- [4] floor(값) : 내림함수

select ceil(123.0001), ceiling(10.1), ceil(-10.1);
select floor(123.0001), floor(10.1), floor(-10.1);

-- [5] rand() : 0~1까지의 임의의 난수인 실수값을 반환한다
select rand();

-- 1~6 까지의 임의의 정수를 반생시켜보기
select floor(rand()*5+1);
-- 51부터 151까지의 임의의 정수 발생시켜보기 
select floor(rand()*100+51);

-- [6] power(x,y): x의 y제곱값을 반환
select power(2, 6), power(10, -3);

-- [7] sqrt(n) : n의 제곱근 값을 구함
select sqrt(64), sqrt(72);

-- [8] conv(숫자, 기존진수, 변환진수)
select conv(127, 10, 2), conv(5, 10,2);

-- [9] bin(), hex(), oct(): 2진수, 16진수, 8진수를 구한다.
select bin(3), bin(15), hex(31), oct(31);

-- row_number() over() 함수: 파티션에 대한 각 행의 해행번호를 반환
-- rank() over() 함수: 파티션에 대한 수누이 값을 반환 

select row_number() over (order by output_price desc) rnum, products.*
from products;

select rank() over(order by sal desc) rnk, emp.*
from emp limit 3;

-- ------------------------
-- # 2. 문자열 함수
-- length(X) : 문자열 길이를 반환
	select length('Hello MYSQL');
-- concat(x, y) : x, y를 결합하여 하나의 문자열로 반환
-- 				 매개변수 중 하나라도 null이 있다면 null을 반환한다. 

select ename, job, comm, concat(ename, job), concat(ename, comm), 
concat(ename, ifnull(comm, '')) from emp;

-- ifnull(v1, v2) : v1이 null이면 v2를, null아니면 v1을 반환 

-- lower()/upper() : 소문자로/대문자로 변경함 
select lower('abcDEFghIJ'), upper('abcDEFghIJ');

-- 사원테이블에서 부서가 20번인 사원의 사번,이름,이름자릿수,
-- 급여,급여의 자릿수를 출력하세요.
select empno, ename, length(ename), sal, length(sal) from emp; 

-- 사원테이블의 사원이름 중 6자리 이상을 차지하는 사원의이름과 
-- 이름자릿수를 보여주세요.
select ename, length(ename) from emp
where length(ename)>=6;
--  사원 테이블에서 SCOTT의 사번,이름,담당업무(소문자로),부서번호를
-- 출력하세요.
select empno, ename, lower(job) job, deptno from emp
where ename = 'scott';

-- locate(검색문자열 , 대상문자열, [index]) 
-- mySQL은 인덱스가 1부터 시작한다. 넣어준 인덱스 번호부터 검색문자열 찾기 시작함
select locate('abc', 'ababcDEFabc'), locate('abc', 'ababcDEFabc', 4);

-- left(대상문자열, len) : 대상문자열의 왼쪽에서부터 명시한 개수(len)만큼 문자를 추출하여 반환
-- rigtht(대상문자열, len) : 대상문자열의 오른쪽에서부터 명시한 개수(len)만큼 문자를 추출하여 반환
select left('mysql python html java', 5), right('mysql python html java', 7);

select concat(left('kingjava', 3), '***');

-- replace(컬럼, x, y): 해당 컬럼 문자열 중에 x에 해당하는 단어를 y로 대체한다. 
select replace('mysql test', 'test', 'hello'); 

-- 사원테이블 JOB에서 'A'를 '$'로 바꾸어 출력하세요.
select replace(job, 'A', '$') from emp;

-- 고객 테이블의 직업에 해당하는 컬럼에서 직업 정보가 학생인 정보를 모두
-- 	 대학생으로 변경해 출력되게 하세요.
use schooldb;
select replace(job, '학생', '대학생') from member;	
    
--  고객 테이블 주소에서 서울시를 서울특별시로 수정하세요
select name, addr, replace(addr, '서울시', '서울특별시') "주소" from member;

-- update 테이블명 set 컬럼명 = 값, 컬럼명2 = 값2, ... where 조건 
-- update member set addr = '서울특별시' where name = '김길동';

update member set addr = replace(addr, '서울시', '서울특별시'); -- 실제 데이터 변경함
select name, addr from member;

-- 고객테이블에서 고객 이름과 나이를 하나의 컬럼으로 만들어 결과값을 화면에
-- 보여주세요.
select concat(name, " ", age) "이름 나이" from member;

--  상품 테이블에서 판매가를 화면에 보여줄 때 금액의 단위를 함께 
-- 	붙여서 출력하세요.
select PRODUCTS_NAME 상품이름, concat(output_price, '원') "가격" from products;


-- trim(지정자, 문자열): 문자열의 앞이나 뒤의 공백 또는 특정 문자를 제거한다. 
-- ** 지정자 (BOTH, LEADING, TRAILING) both가 디폴트

select trim('  !!!MySQL HTML Java Python!!  ') trim_str;

-- leading: 문자열로부터 !를 없애겠다
select trim(leading '!' from '!!mysql html java python!!');

-- trailing: 문자열 중 뒤쪽에 있는 !만 없애겠다 
select trim(trailing '!' from '!!mysql html java python!!');

-- LTrim/RTrim: 왼쪽/ 오른쪽 공백을 제거 
select '  HELLO  ', ltrim('  HELLO  ') lt, rtrim('         hello  ') rt; 

select length('  HELLO  '), length(ltrim('  HELLO  ')) lt, length(rtrim('  hello  ')) rt; 

-- lpad/rpad(컬럼, 길이, 특정문자): 컬럼값을 왼쪽/오른쪽부터 특정문자로 채운다. 
select ename, lpad(ename, 15, '*'), sal, lpad(sal, 10, '#') from emp;

select rpad(dname, 15, '@') from dept;

-- substring(char, start, len) : 주어진 문자열(char)의 시작 위치에서부터 길이만큼
select 'hello mysql', substring('hello mysql', 7, 2);

-- format(숫자, n) : 숫자 데이터를 세 자리마다 콤마(,)를 붙여서 표현하는 함수
select format(1000000,0);
select format(123456.12345,2);

-- 상품테이블에서 입고가격과 판매가격을 세 자리마다 쉼표를 붙여서
-- 	보여주세요

select input_price, format(input_price, 0) from products;
select output_price, format(output_price, 0) from products;

select products_name, format(input_price, 0), format(output_price, 0) from products;

-- reverse(char) : 문자열을 거꾸로 반환

select reverse(ename) from emp; 

-- insert(대상문자열, start, len, 삽입할 문자)
select insert('가나다라마', 2, 1, '#');

-- 사원 테이블에서 사원이름의 첫글자가 'K'보다 크고 'Y'보다 작은 사원의
-- 사번,이름,업무,급여를 출력하세요. 단 이름순으로 정렬하세요.

select empno, ename, job, sal from emp
where ename between 'k' and 'y'
order by ename;

select empno, ename, job, sal from emp 
where substring(ename, 1, 1) > 'k' and substring(ename, 1,1) <'y'
order by ename;

-- # 3. 날짜, 시간 함수
-- 현재 시스템의 날짜와 시간을 구하는 함수
-- curdate(): 현재 년-월-일을 반환
-- curtime(): 현재 시:분:초를 반환 
-- now(): 년-월-일 시:분:초 
-- sysdate() : 년-월-일 시:분:초 

select curdate(), curtime();
select now(), sysdate();

select date('2021-12-25 12:03:21');
select month('2021-12-25 12:03:21');
select year('2021-12-25 12:03:21');
select day('2021-12-25 12:03:21');
select hour('2021-12-25 12:03:21');
select minute('2021-12-25 12:03:21');
select second('2021-12-25 12:03:21');

select dayname(now()); -- 요일의 이름을 반환
select monthname(now()); -- 월의 이름을 반환

-- dayofweek() : 해당 주의 몇 번째 날인지 반환( 일요일:1, 토요일:7)
-- dayofmonth(): 해당 월의 몇 번째 날인지 (0~31)
-- dayofyear() : 1년 중 몇 번째 날인지(1~365)

select dayofyear(now()), dayofmonth(now()), dayofweek(now());

-- adddate() : 날짜를 기준으로 차이를 더한 날짜를 반환한다.
-- subdate() : 날짜를 기준으로 차이를 뺀 날짜를 반환한다.

select adddate('2022-01-01', interval 31 day);
select subdate('2022-01-01', interval 31 day);

-- datediff(날짜1, 날짜2) : 날짜2에서 날짜1까지 몇 일이 남았는지 반환한다. 
-- timediff(날짜1 or 시간1, 날짜2 or 시간2) : 시간이 얼마나 남았는지 반환

-- 오늘 부터 연말(12월31일까지) 며칠이 남았는지 계산해보세요 
select datediff('2022-12-31', now());
select timediff('17:50:00', curtime());

-- 고객 테이블이 두 달의 기간을 가진 유료 회원이라는 가정하에 등록일을 기준으로
-- 	   유료 회원인 고객의 정보를 보여주세요.
-- 고객명 등록일 만기일

select name, reg_date, adddate(reg_date, interval 2 month) '만기일'
from member;

-- last_day(날짜) : 주어진 월의 마지막 날을 반환
select last_day('2022-07-26'), last_day('2024-02-01');

-- Time_to_sec(시간) :시간을 초 단위로 계산해서 반환
select time_to_sec('5:53:10');
-- 1분: 60*56
-- 1시간: 60분 5*60*60
-- 총: 60*56 + 5*60*60 + 10 = 21190

-- 2022-06-27에서 현재까지 학습한 일수가 몇 주 몇 일인지 출력해보기 
select floor(datediff(curdate(), '2022-06-27')/7) "weeks",
datediff(curdate(), '2022-06-27')%7, 
mod(datediff(curdate(), '2022-06-27'),7) "days";

-- #4. 변환함수 
-- convert(값, 데이터형식) 
-- cast(값, 데이터형식)
-- 데이터형식: binary, char, date, datetime, time, signed, unsigned
-- 	        signed integer : 부호있는 정수(-21억~ 21억)
-- 			unsigned integer : 부호없는 정수(0~42억)
select avg(sal), convert(avg(sal), signed integer) from emp;

select cast('2022-07-26' as date), cast('2022/07/01' as date);
select cast('2022.07.26' as date), cast('2022,07,01' as date);

select now(), date_format(now(), '%y-%m-%d');
select now(), date_format(now(), '%Y-%M-%D');

-- 20120213 12/02/13 변환해서 출력하기
select date_format('20220213', '%y-%m-%d');

-- 현재 시간을 12:23:51 pm 요일
select concat(time_format(curtime(), '%h:%i:%s pm '), dayname(now()));

select subdate(now(), interval 1 day), curdate(), adddate(now(), interval 1 day),
adddate(now(), interval 2 day);

-- ----------------------
## 그룹 함수
-- 여러 행 또는 테이블 전체에 함수가 적용되어 하나의 결과를 가져오는 함수
-- count()
-- avg()
-- sum()
-- max()
-- min()
-- stddev()
-- varance()

select count(empno) from emp;
select count(mgr) from emp;
select count(comm) from emp;
-- count() 함수는 null값은 세지 않는다

select count(*) from emp;
-- count(*): null값도 포함해서 센다

create table test(
	a int,
    b int,
    c int
);

select * from test;
insert into test values(null, null, null);

select count(a) from test;
select count(*) from test;

select count(mgr) from emp; -- 13

-- distinct : 중복되지 않는 값 반환
select count(distinct mgr) from emp; -- 6

-- emp테이블에서 모든 SALESMAN에 대하여 급여의 평균,
-- 		 최고액,최저액,합계를 구하여 출력하세요.
select avg(sal), max(sal), min(sal), sum(sal) from emp
where job = 'salesman';
      
-- EMP테이블에 등록되어 있는 인원수, 보너스에 NULL이 아닌 인원수,
-- 		보너스의 평균,등록되어 있는 부서의 수를 구하여 출력하세요.
select count(empno), count(comm), avg(comm), count(deptno) from emp;

-- group by 절과 그룹함수 사용

select job, count(*)
from member
group by job;

select * from products;
-- 상품 테이블에서 카테고리별(category_fk)로 총 몇 개의 상품이 있는지 보여주세요.
-- 또한 최대 판매가와 최소 판매가를 함께 보여주세요.
select category_fk, count(*), max(output_price), min(OUTPUT_PRICE)
from products
group by CATEGORY_FK;

-- 상품 테이블에서 각 공급업체 코드(ep_code_fk)별로 공급한 상품의 평균입고가를 보여주세요.
select ep_code_fk, avg(input_price) from products
group by ep_code_fk;

-- 고객 테이블에서 직업의 종류, 각 직업에 속한 최대 마일리지 정보를 보여주세요.
select job, max(MILEAGE) from member
group by job;

-- 사원 테이블에서 입사한 년도별로 사원 수를 보여주세요.
select date_format(hiredate, '%Y') " year", count(ename) from emp
group by date_format(hiredate, '%Y');

SELECT YEAR(HIREDATE), COUNT(*) FROM EMP GROUP BY YEAR(HIREDATE);


-- 사원 테이블에서 해당년도 각 월별로 입사한 사원수를 보여주세요.
select date_format(hiredate, '%M') "month", count(ename) from emp
group by date_format(hiredate, '%M');

SELECT YEAR(HIREDATE), MONTH(HIREDATE), COUNT(*) FROM EMP GROUP BY MONTH(HIREDATE);


-- 사원 테이블에서 업무별 최대 연봉, 최소 연봉을 출력하세요
select job, max(sal), min(sal) from emp
group by job;

-- WGHOL 
-- having 절
-- group by 와 함께 사용
-- group by 결과에 조건을 주어 제하할 때 사용한다.

-- 고객 테이블에서 직업의 종류와 각 직업에 속한 사람의 수가 
-- 3명 이상인 직업군의 정보를 보여주시오
select job, count(*)
from member
group by job
having count(*) >=3;

-- 고객 테이블에서 직업의 종류와 각 직업에 속한 최대 마일리지 정보를 보여주세요.
-- 	      단, 직업군의 최대 마일리지가 0인 경우는 제외시킵시다.
select job, max(MILEAGE)
from member
group by job
having max(mileage) <>0;

-- 상품 테이블에서 각 카테고리별로 상품을 묶은 경우, 해당 카테고리의 상품이 2개인 
-- 	      상품군의 정보를 보여주세요.
select *, count(*)
from products
group by CATEGORY_FK
having count(*) = 2; 

select * from products;

-- 상품 테이블에서 각 공급업체 코드별로 상품 판매가의 평균값 중 단위가 100단위로 떨어
-- 	      지는 항목의 정보를 보여주세요.
select *, round(avg(OUTPUT_PRICE))
from products
group by EP_CODE_FK
having (round(avg(OUTPUT_PRICE))%100)=0
order by 2 desc;








