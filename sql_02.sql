#day2
USE python;
# 자동으로 증가하는(AUTO_INCREMENT) column 만들기 ==> PRIMERY KEY 고유값으로 지정해서
#column 이름은 id 데이터 타입은 int
#primary key를 붙이지 않으면 에러가 납니다
CREATE OR REPLACE TABLE test (id INT AUTO_INCREMENT PRIMARY KEY);# id에 auto increment속성 부여
DESCRIBE test;
INSERT INTO test VALUES (); #필드가 id 밖에 없으므로 id에 값 자동으로 부여 ()에 원래 값넣어야하지만 자동으로 증가하면서 넣기로 했음(중복 값은 X)
SELECT * FROM test; # select (필드이름 ==>id,name,등등) from (테이블);
INSERT INTO test VALUES (101); #특정값 넣기
#테이블 안의 특정 index 지우기
DELETE FROM test WHERE id = 101;#WHERE절 안쓸경우 test테이블 전체값 삭제되니 주의!
SELECT * FROM test;
#test table 전체값 지우기 (safe모드 끄고 mysql 재시작해야함)
USE python;
DELETE FROM test;
DESC test;
INSERT INTO test VALUES ();# 전체값 지웠지만 (그전에 101만들었었던 속성은 남아있어서 102부터 시작함)
SELECT * FROM test;
SHOW table status WHERE name = 'test'; # Auto_increment가 103이 되어있음을 확인
ALTER TABLE test AUTO_INCREMENT = 1;#auto_increment를 1로 수정(id 값이 102가 들어있어서 수정이 안됨)
SET @count =0; # @count=0설정
UPDATE test SET id=@count:=@count+1;#id값을 다시 1부터 시작하도록 변경
SELECT * FROM test;

#테이블에 데이터 추가
#테이블 생성
CREATE TABLE table1(
column1 varchar(100),
column2 varchar(100),
column3 varchar(100)
);
DESC table1;
INSERT INTO table1 (column1, column2,column3) VALUES ('a','aa','aaa');#각각의 컬럼에 각각의 값 부여
SELECT * FROM table1;
#일부 컬럼에만 값 부여
INSERT INTO table1 (column1, column2) VALUES ('b','bb');#원하는 컬럼에 각각의 값 부여
SELECT * FROM table1;# column3에 null값 들어가짐
INSERT INTO table1 VALUES ('a','aa','aaa');#전체 컬럼에 넣을 경우 컬럼지정 안해줘도 됨
SELECT * FROM table1;
#테이블에 데이터 수정
UPDATE table1 SET column1 = 'z';#column뒤에 where이용해서 특정 행의 값 변경
SELECT * FROM table1;
UPDATE table1 SET column1 = 'x' where column2 = 'aa';#column뒤에 where이용해서 특정 행의 값 변경
SELECT * FROM table1; # column2에 값 'aa'인 index만 x로 변경됨
UPDATE table1 #사용 예시
   SET column1 = 'y'
     , column2 ='yy'
 where column3 = 'aaa';
SELECT * FROM table1;
#테이블에 데이터 삭제
DELETE FROM table1 WHERE column1 ='y';#특정 index 삭제
SELECT * FROM table1; 
DELETE FROM table1;#테이블 전체 삭제
SELECT * FROM table1;

#테스트용 테이블 생성
# 기존테이블 삭제(테이블 존재시)
DROP TABLE IF EXISTS day_visitor_realtime;
# 테이블 생성
CREATE TABLE IF NOT EXISTS day_visitor_realtime(
ipaddress varchar(16),
iptime_first datetime,
before_url varchar(250),
device_info varchar(40),
os_info varchar(40),
session_id varchar(80)
);
#데이터 타입의 길이에 맞게 데이터를 삽입
INSERT INTO day_visitor_realtime(
ipaddress, iptime_first, before_url, device_info
)
VALUES ('192.168.0.1', '2023-02-23 11:34:28', 'localhost', 'PC')
,('192.168.0.1', '2023-02-23 11:34:28', 'localhost', 'iphone');
SELECT * FROM day_visitor_realtime;
DESC day_visitor_realtime;
#varchar(16)에 17자리의 값을 넣어서 에러 발생
INSERT INTO day_visitor_realtime(
ipaddress, iptime_first, before_url, device_info
)
VALUES ('12345678901234567', '2023-02-23 11:34:28', 'localhost', 'PC');
#다양하게 넣어보자
INSERT INTO `python`.`day_visitor_realtime` (`session_id`) VALUES ('12345.1');
INSERT INTO `python`.`day_visitor_realtime` (`session_id`) VALUES('12345.567890');
INSERT INTO `python`.`day_visitor_realtime` (`session_id`) VALUES('12345.5678');
SELECT * FROM day_visitor_realtime;
#NOT NULL == 해당 컬럼의 값에 NULL이 오지 못하도록 강제
DROP TABLE IF EXISTS day_visitor_realtime;
CREATE TABLE IF NOT EXISTS day_visitor_realtime(
ipaddress varchar(16) NOT NULL,
iptime_first datetime,
before_url varchar(250),
device_info varchar(40),
os_info varchar(40),
session_id varchar(80)
);
#PRIMARY KEY(컬럼명1,컬럼명2,컬럼명3,...) == 기본키 는 하나의 테이블에 있는 데이터들을 고유하게 식별 
#하나의 테이블에 하나만 생성가능, NULL값 가질 수 X
DROP TABLE IF EXISTS day_visitor_realtime;
CREATE TABLE day_visitor_realtime (
  id INT, # 타입 뒤에 primary key 붙여서 설정 가능 id INT primary key()
  ipaddress varchar(16),
  iptime_first datetime,
  before_url varchar(250),
  device_info varchar(40),
  os_info varchar(40),
  session_id varchar(80),
  primary KEY(id)
);
#FOREIGN KEY 외래키 = 참조하는 테이블(다른 테이블)의 컬럼에 존재하는 값만 사용하는 제약조건
# 참조할 테이블
CREATE TABLE orders (
  order_id INT,
  customer_id INT,
  order_date DATETIME,
  PRIMARY KEY(order_id)
);
INSERT INTO orders values(1,1,now()); #now()=현재시간
INSERT INTO orders values(2,1,now());
INSERT INTO orders values(3,1,now());
CREATE TABLE order_detail (
  order_id INT,
  product_id INT,
  product_name VARCHAR(200),
  order_date DATETIME,
  #CONSTRAIN 외래키명칭 FOREIGN KEY (외래키) REFERENCES 참조테이블명(참조컬럼) 형태로 작성
  CONSTRAINT FK_ORDERS_ORDERID FOREIGN KEY (order_id) REFERENCES orders(order_id),#orders테이블의 있는 값만 받겠다는 뜻
  PRIMARY KEY(order_id, product_id)
);
INSERT INTO order_detail(order_id,product_id,product_name)
VALUES (1,100,'iphone')
      ,(1,101,'ipad');
SELECT * from order_detail;
#orders테이블에 order_id에 없는 값 삽입시 오류발생
INSERT INTO order_detail(order_id,product_id,product_name)
VALUES (4,100,'iphone')
      ,(4,101,'ipad');
      
      
      
