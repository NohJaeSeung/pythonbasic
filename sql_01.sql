#User 테이블.
DESC mysql.User;
DESCRIBE mysql.User;
SHOW full columns from mysql.User;
#Host, User를 필드에 두고 mysql.User 불러오기
SELECT Host,User FROM mysql.User;
#CREATE User '아이디'@'접근가능한주소' IDENTIFIED BY '비밀번호';
CREATE User 'test'@'localHost' IDENTIFIED BY '1234';
# % == 어디에서든 접근 가능
CREATE User 'anywhere'@'%' IDENTIFIED BY '1234';
SELECT User,Host FROM mysql.User;
#특정 범위에서 접근 가능
CREATE User 'test2'@'192.168.0.%' IDENTIFIED BY '1234';
SELECT User,Host FROM mysql.User;

# 데이터베이스 조건문걸기
#or REPLACE = 또는 대체
CREATE or REPLACE User 'test'@'lacalHost' IDENTIFIED BY '1234';
SELECT User,Host FROM mysql.User;
#not exists = 존재하지 않으면
CREATE User	if not exists 'test'@'localHost' IDENTIFIED BY '1234';
SELECT User,Host FROM mysql.User;
#데이터베이스 사용자 이름 주소 변경
rename User	'test2'@'192.168.0.%' TO 'test3'@'%';
SELECT User,Host FROM mysql.User;
#데이터베이스 사용자 비밀번호 변경
SET Password for 'test3'@'%' = Password('12345');
SELECT User,Host FROM mysql.User;
#데이터베이스 사용자 삭제
DROP User 'test3'@'%';
SELECT User,Host FROM mysql.User;
#데이터베이스 사용자 조건에 따라 삭제하기
DROP User IF EXISTS 'anywhere'@'%';
SELECT User,Host FROM mysql.User;

#데이터베이스 목록 조회
SHOW databases;
#데이터베이스 test라는 이름으로 생성
CREATE database test;

#데이터베이스 권한 부여하기
#기존 권한 확인
SHOW GRANTS FOR 'test'@'localhost';
# (ALL PRIVILEGES) 모든 권한을 test에 (ON) 부여 .*==> 모든이라는 뜻
GRANT ALL PRIVILEGES ON test.* TO 'test'@'localhost';
#권한 적용
flush privileges;
#데이터베이스 권한 제거
REVOKE ALL on test.* FROM 'test'@'localhost';
#권한 적용
flush privileges;
SHOW GRANTS FOR 'test'@'localhost';

#데이터베이스 특수한 이름 명명하기(esc 밑에있는 Grave(`)라는 키로 감싸서 사용)
CREATE Database `test.test`;
DROP database `test.test`;
SHOW databases;
#데이터베이스 명칭 변경하기
# 데이터베이스 이름은 직접 변경 불가능 ==> 기존 데이터베이스를 덤프로 만들고, 변경할 이름으로 새로 데이터베이스를 생성 -> 덤프 파일을 새 데이터베이스에 백업
# cmd에서 mysqldump -u root

#테이블 만들기
CREATE database python;
#python이란 데이터베이스 내에서 쓰겠다
USE python;
#테이블 만들기 table1이란 명칭의 테이블 만듬 column이 하나도 없으면 테이블 만들어지지 않음
CREATE TABLE table1 (column1 VARCHAR(100));
#현재 사용증인 데이터베이스 확인
SELECT DATABASE();
#테이블 목록 조회
SHOW TABLES;
rename table table1 to table2;
#테이블 삭제하기
DROP TABLE table2;
SHOW TABLES;
#테이블 생성하기
CREATE TABLE test_table (
test_column1 INT,
test_column2 INT,
test_column3 INT
);
DESC test_table;
#테이블에 column 추가하기 test_table에 test_columns4라는 column을 추가
ALTER TABLE test_table
ADD test_column4 INT;

DESC test_table;
#테이블에 여러개의 column 추가
ALTER TABLE test_table
ADD(
test_column5 INT,
test_column6 INT,
test_column7 INT
);
DESC test_table;
#테이블에 column 삭제하기
ALTER TABLE test_table
DROP test_column1;
DESC test_table;
#테이블에 column 순서 변경하기 , test_column7을 맨 앞으로 이동합니다. 데이터 타입도 같이 적어야함(타입변경가능)
ALTER TABLE test_table
MODIFY test_column7 INT
FIRST;
DESC test_table;
#맨 앞이 아닌 특정 열 뒤로 이동하고 싶다면 AFTER명령어를 함께 사용
ALTER TABLE test_table
MODIFY test_column7 INT
AFTER test_column6;
DESC test_table;
#테이블 column 이름 변경하기(change사용) , test_column2를 test_column0으로 column이름을 변경
ALTER TABLE test_table
CHANGE test_column2 test_column0 INT;
DESC test_table;
#테이블 column 데이터 타입 변경하기
ALTER TABLE test_table
CHANGE test_column0 test_column0 VARCHAR(10);
DESC test_table;
#ㅌ이블 column 이름과 데이터 타입 동시에 변경하기
ALTER TABLE test_table
CHANGE test_column0 test_column2 int;
DESC test_table;