USE market_db;#3-3
UPDATE city_popul
    SET city_name = '서울'
    WHERE city_name ='Seoul';
SELECT * FROM city_popul WHERE city_name ='서울';
UPDATE city_popul
    SET city_name = '뉴욕',population=0
    WHERE city_name ='New York';
SELECT * FROM city_popul WHERE city_name = '뉴욕';
UPDATE city_popul
    set population =population /10000;
SELECT * FROM city_popul LIMIT 5;
DELETE FROM city_popul
    WHERE city_name LIKE 'New%'
    LIMIT 5;
CREATE TABLE big_table1 (SELECT * FROM world.city, sakila.country);
CREATE TABLE big_table2 (SELECT * FROM world.city, sakila.country);
CREATE TABLE big_table3 (SELECT * FROM world.city, sakila.country);
SELECT COUNT(*) FROM big_table1;
DELETE FROM big_table1;
DROP TABLE big_table2;
TRUNCATE TABLE big_table3;#테이블의 구조는 남는다
#4-1
CREATE TABLE hongong4 (
    tinyint_col TINYINT,
    samllint_col SMALLINT,
    int_col INT,
    bigint_col BIGINT);
INSERT INTO hongong4 VALUES(127, 32767, 2147483647, 9000000000000000000);
INSERT INTO hongong4 VALUES(128,32768,2147483648,90000000000000000000);
CREATE TABLE member3 -- 회원 테이블
( mem_id         CHAR(8) NOT NULL PRIMARY KEY, --회원 아이디(PK)
  mem_name       VARCHAR(10) NOT NULL, --이름 
  mem_number     TINYINT NOT NULL,  --인원수
  addr           CHAR(2) NOT NULL, --주소(경기, 서울, 경남, 식으로 2글자만 입력)
  phone1         CHAR(3), --연락처의 국번(02,031,055 등)
  phone2         CHAR(8), --연락처의 나머지 전화번호(하이픈 제외)
  height         TINYINT UNSIGNED, --평균 키
  debut_date     DATE --데뷔 일자
  );
CREATE DATABASE netflix_db;
USE netflix_db;
CREATE TABLE movie
(movie_id        INT,
 movie_title     VARCHAR(30),
 movie_director  VARCHAR(20),
 movie_star      VARCHAR(20),
 movie_script    LONGTEXT,
 movie_film      LONGBLOB
 );
 #변수의 사용
 USE market_db;
 SET @myVar1 = 5;
 SET @myVar2 = 4.25;
 
 SELECT @myVar1;
 SELECT @myVar1 + @myVar2;
 
 SET @txt = '가수 이름==> ';
 SET @height = 166;
 SELECT @txt , mem_name FROM member WHERE height > @height;
SET @count = 3;
SELECT mem_name, height FROM member ORDER BY height LIMIT @count;#LIMIT에는 직접 변수사용 불가
PREPARE mysql FROM 'SELECT mem_name, height FROM member ORDER BY height LIMIT ?';#prepare는 실행하지 않고 sql문만 준비해 놓고 execute에서 실행함
EXECUTE mysql USING @count; #using뒤에 @count를 ?에 대입
#명시적인 데이터 형 변환
SELECT AVG(price) AS '평균 가격' FROM buy;
SELECT CAST(AVG(price) AS SIGNED) '평균 가격' FROM buy;#CAST나 CONVERT함수를 이용해 정수로 표현
SELECT CONVERT(AVG(price), SIGNED) '평균 가격' FROM buy; 
SELECT CAST('2022$12$12' AS DATE);
SELECT num, CONCAT(CAST(price AS CHAR), 'X', CAST(amount AS CHAR), '=')
'가격X수량', price*amount '구매액'
FROM buy;
SELECT * FROM buy;
#암시적인 데이터 형 변환
SELECT '100' + '200';
SELECT CONCAT('100','200');
#4-2 조인에 대해 알아보자
USE market_db;
SELECT * 
FROM buy
INNER JOIN member # 내부조인합니다
ON buy.mem_id = member.mem_id;
SELECT buy.mem_id, mem_name, prod_name, addr, CONCAT(phone1, phone2) '연락처'
FROM buy
INNER JOIN member
ON buy.mem_id = member.mem_id;
SELECT B.mem_id,M.mem_name, B.prod_name, M.addr, CONCAT(M.phone1, M.phone2) '연락처'
FROM buy B
INNER JOIN member M
ON B.mem_id = M.mem_id
ORDER BY M.mem_id;#구매한 이력이 있는 회원정보만 나옴(내부join)
SELECT DISTINCT M.mem_id, M.mem_name,M.addr
FROM buy B
INNER JOIN member M
ON B.mem_id = M.mem_id
ORDER BY M.mem_id;#DISTINCT를 이용해 중복 제거
# 외부조인
SELECT M.mem_id, M.mem_name, B.prod_name, M.addr
FROM member M
LEFT OUTER JOIN buy B #왼쪽에 있는 회원테이블을 기준으로 외부 조인합니다
ON M.mem_id = B.mem_id
ORDER BY M.mem_id;
SELECT M.mem_id, M.mem_name, B.prod_name, M.addr
FROM buy B
RIGHT OUTER JOIN member M #오른쪽에 있는 회원테이블을 기준으로 외부 조인합니다
ON M.mem_id = B.mem_id
ORDER BY M.mem_id;
#한번도 구매한적 없는 회원목록 추출
SELECT DISTINCT M.mem_id, M.mem_name, B.prod_name, M.addr
FROM member M
LEFT OUTER JOIN buy B #왼쪽에 있는 회원테이블을 기준으로 외부 조인합니다
ON M.mem_id = B.mem_id
WHERE B.prod_name IS NULL
ORDER BY M.mem_id;
# 상호조인(cartesian product) 카티션 곱 단순 곱? 대용량데이터를 만들때 사용 큰의미x
SELECT * FROM buy
CROSS JOIN member;
CREATE TABLE cross_table
SELECT *
FROM sakila.actor -- 200건
CROSS JOIN world.country; -- 239건
SELECT * FROM cross_table LIMIT 5; #==>200x239건의 데이터생성 하는 듯
# 자체조인 == 자기 자신과 조인
CREATE TABLE emp_table (emp CHAR(4), manager CHAR(4), phone VARCHAR(8));
INSERT INTO emp_table VALUES('대표',NULL,'0000');
INSERT INTO emp_table VALUES('영업이사','대표','1111');
INSERT INTO emp_table VALUES('관리이사','대표','2222');
INSERT INTO emp_table VALUES('정보이사','대표','3333');
INSERT INTO emp_table VALUES('영업과장','영업이사','1111-1');
INSERT INTO emp_table VALUES('경리부장','관리이사','2222-1');
INSERT INTO emp_table VALUES('인사부장','관리이사','2222-2');
INSERT INTO emp_table VALUES('개발팀장','정보이사','3333-1');
INSERT INTO emp_table VALUES('개발주임','정보이사','3333-1-1');

SELECT A.emp "직원" , B.emp "직속상관", B.phone "직속상관연락처"
FROM emp_table A
INNER JOIN emp_table B #자체조인 A,B로 구분
ON A.manager = B.emp
WHERE A.emp ='경리부장';
#4-3 SQL프로그래밍
#스토어드_프로시저
DROP PROCEDURE IF EXISTS ifProc1;#먼저 ifProc1이 존재하면 지우자
#if문
DELIMITER $$
CREATE PROCEDURE ifProc1()
BEGIN
IF 100 = 100 THEN
SELECT '100은 100과 같습니다';#SELECT는 print와 비슷한 기능
END IF;
END $$
DELIMITER ;
CALL ifProc1();
DROP PROCEDURE IF EXISTS ifProc2:
DELIMITER $$
CREATE PROCEDURE ifProc2()
BEGIN
DECLARE mynum INT; #DECLARE로 mynum변수 선언
SET myNum = 200; #SET으로 mynum에 200대입
IF myNum = 100 THEN
   SELECT '100입니다.';
ELSE 
   SELECT '100이 아닙니다.';
END IF;
END $$
DELIMITER ;
CALL ifProc2();
USE market_db;
DROP PROCEDURE IF EXISTS ifProc3;
DELIMITER $$
CREATE PROCEDURE ifProc3()
BEGIN
   DECLARE debutDate DATE; -- 데뷔일자
   DECLARE curDate DATE; -- 오늘
   DECLARE days INT; -- 활동한 일수
   SELECT debut_date INTO debutDate
       FROM market_db.member
       WHERE mem_id = 'APN';
	SET curDATE = CURRENT_DATE(); -- 현재 날짜
    SET days = DATEDIFF(curDATE, debutDate); -- 날짜의 차이, 일 단위
    
    IF (days/365) >= 5 THEN -- 5년이 지났다면
        SELECT CONCAT('데뷔한 지 ', days, '일이나 지났습니다. 핑순이들 축하합니다!');
	ELSE
        SELECT '데뷔한 지 ' + days + '일밖에 안되었네요. 핑순이들 화이팅~';
	END IF;
END $$
DELIMITER ;
CALL ifProc3();
#WHEN 문
DROP PROCEDURE IF EXISTS caseProc;
DELIMITER $$
CREATE PROCEDURE caseProc()
BEGIN
    DECLARE point INT;
    DECLARE credit CHAR(1);
    SET point = 88;
    
    CASE
      WHEN point >= 90 THEN
          SET credit = 'A';
	  WHEN point >= 80 THEN
          SET credit = 'B';
	  WHEN point >= 70 THEN
          SET credit = 'C';
	  WHEN point >= 60 THEN
          SET credit = 'D';
	  ELSE
          SET credit = 'F';
	END CASE;
    SELECT CONCAT('취득점수==>',point), CONCAT('학점==>', credit);
END $$
DELIMITER ;
CALL caseProc();
SELECT B.mem_id, M.mem_name,
	   SUM(price*amount) "총구매액"
    FROM buy B
         INNER JOIN member M
         ON B.mem_id = M.mem_id
    GROUP BY mem_id
    ORDER BY SUM(price*amount) DESC;
SELECT M.mem_id, M.mem_name,
        SUM(price*amount) "총구매액",
        CASE
            WHEN (SUM(price*amount) >= 1500) THEN '최우수고객'
            WHEN (SUM(price*amount) >= 1000) THEN '우수고객'
            WHEN (SUM(price*amount) >= 1) THEN '우수고객'
            ELSE '유령고객'
		END "회원등급"
	FROM buy B
        RIGHT OUTER JOIN member M
        ON B.mem_id = M.mem_id
	GROUP BY M.mem_id
    ORDER BY SUM(price*amount) DESC;
#while문 1부터 100까지 더하기
DROP PROCEDURE IF EXISTS whileProc;
DELIMITER $$
CREATE PROCEDURE whileProc()
BEGIN
    DECLARE i INT; -- 1에서 100까지 증가할 변수
    DECLARE hap INT; -- 더한 값을 누적할 변수
    SET i = 1;
    SET hap = 0;
    
    WHILE ( i <= 100) DO
        SET hap = hap + i;
        SET i = i + '1';
   END WHILE;
   SELECT '1부터 100까지의 합 ==>', hap;
END $$
DELIMITER ;
CALL whileProc();
# 4의 배수 제외, 1000이 넘는 순간 출력
DROP PROCEDURE IF EXISTS whileProc2;
DELIMITER $$
CREATE PROCEDURE whileProc2()
BEGIN
    DECLARE i INT; -- 1에서 100까지 증가할 변수
    DECLARE hap INT; -- 더한 값을 누적할 변수
    SET i = 1;
    SET hap = 0;
    
    myWhile:

    WHILE ( i <= 100) DO
        IF (i%4 = 0) THEN
            SET i = i + 1;
            ITERATE myWhile; -- 지정한 label 문으로 가서 계속 실행
		END IF;
        SET hap = hap + i;
        IF (hap > 1000) THEN
            LEAVE myWhile; -- 지정한 label 문을 떠남. 즉 while 종료
		END IF;
        SET i = i + 1;
   END WHILE;
   SELECT '1부터 100까지의 합(4의 배수 제외), 1000 넘으면 정료==>', hap;
END $$
DELIMITER ;
CALL whileProc2();
#동적 SQL (PREPARE와 EXECUTE)
DROP TABLE IF EXISTS gate_table;
CREATE TABLE gate_table (id INT AUTO_INCREMENT PRIMARY KEY, entry_time
DATETIME);

SET @curDate = CURRENT_TIMESTAMP(); -- 현재 날짜와 시간

PREPARE myQuery FROM 'INSERT INTO gate_table VALUES(NULL, ?)';
EXECUTE myQuery USING @curDate;
DEALLOCATE PREPARE myQuery; -- 실행후 deallocate prepare로 문장을 해제

SELECT * FROM gate_table;