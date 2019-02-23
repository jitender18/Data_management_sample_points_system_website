CREATE TABLE Employee(
    empid Number NOT NULL ,
    email VARCHAR2(100 Byte),
    password VARCHAR2(100 BYTE),
    emp_type VARCHAR2(20 Byte)
);


ALTER TABLE Employee
ADD CONSTRAINT Employee_pk PRIMARY KEY (empid);

ALTER TABLE Employee
ADD CONSTRAINT Employee_pk PRIMARY KEY (empid);

CREATE SEQUENCE seq_person
MINVALUE 7
START WITH 7
INCREMENT BY 1
CACHE 10;


Insert into Employee values (SEQ_PERSON.nextval, 'lionelmessi@fcb.com', 'GOAT10', 'Admin');
Insert into Employee values (SEQ_PERSON.nextval, 'cristianoronaldo@madrid.com', 'CR7', 'Admin');
Insert into Employee values (SEQ_PERSON.nextval, 'neymar@fcb.com', 'NJ11', 'Member');
Insert into Employee values (SEQ_PERSON.nextval, 'rafinha@fcb.com', 'raf12', 'Member');
Insert into Employee values (SEQ_PERSON.nextval, 'iniesta@fcb.com', 'Iniesta8', 'Member');
Insert into Employee values (SEQ_PERSON.nextval, 'coutinho@fcb.com', 'PhilC7', 'Member');
Insert into Employee values (SEQ_PERSON.nextval, 'suarez@fcb.com', 'Luis9', 'Member');

select * from employee;

select * from employee_details;

select * from credits;

select * from transanctions;

delete from employee where empid = 13;


drop sequence seq_person;
delete from employee;

CREATE TABLE Employee_details(
    empid number(10),
    emp_first_name VARCHAR2(100 BYTE),
    emp_last_name VARCHAR2(100 Byte),
    address VARCHAR2(200 Byte),
    phone_number NUMBER(10)
);

ALTER TABLE Employee_details
ADD CONSTRAINT Employee_details_pk PRIMARY KEY (empid);


ALTER TABLE Employee_details
ADD CONSTRAINT Employee_details_fk Foreign KEY (empid) references Employee(empid);

ALTER TABLE Credits
ADD CONSTRAINT Credits_fk Foreign KEY (empid) references Employee(empid);

ALTER TABLE Employee_details
ADD CONSTRAINT Employee_details_fk Foreign KEY (empid) references Employee(empid);



Insert into Employee_details values (10, 'Lionel', 'Messi', 'Argentina', '1010101010');
Insert into Employee_details values (7, 'Cristiano', 'Ronaldo', 'Portugal', '7777777777');
Insert into Employee_details values (11, 'Neymar', 'Junior', 'Brazil', '1111111111');
Insert into Employee_details values (12, 'Alacantra', 'Rafinha', 'Brazil', '1212121212');
Insert into Employee_details values (8, 'Andreas', 'Iniesta', 'Spain', '8888888888');
Insert into Employee_details values (14, 'Phillipe', 'Coutinho', 'Brazil', '1414141414');
Insert into Employee_details values (9, 'Luis', 'Suarez', 'Uruguay', 9999999999);

select * from employee_details;

CREATE TABLE Credits(
    empid number(10),
    monthly_credits Number(10),
    gift_credits Number(10),
    gift_cards_count Number(10)
);

alter table credits rename COLUMN gift_cards TO gift_credits; 

ALTER TABLE Credits
ADD CONSTRAINT Credits_pk PRIMARY KEY (empid);

Insert into Credits values (10, NULL, NULL, NULL);
Insert into Credits values (7, NULL, NULL, NULL);
Insert into Credits values (8, 1000, 0, 0);
Insert into Credits values (9, 1000, 0, 0);
Insert into Credits values (11, 1000, 0, 0);
Insert into Credits values (12, 1000, 0, 0);
Insert into Credits values (14, 1000, 0, 0);

update credits SET gift_credits = 20000 where empid = 9;
update credits SET gift_credits = 20000 where empid = 11;
update credits SET gift_credits = 15000 where empid = 14;

select * from credits;



CREATE OR REPLACE View currentReport AS
(SELECT credits.empid, emp_first_name, monthly_credits, gift_credits, gift_cards_count
FROM employee_details inner join credits
on employee_details.empid=credits.empid and credits.empid not in (7, 10));

/*
create or replace PROCEDURE updateOp(creditToUser IN string, DebitFromUser IN string, credit IN number) AS 
BEGIN 

update credits set gift_credits = gift_credits+credit where empid = (select empid from employee_details where emp_first_name = creditToUser);
update credits set monthly_credits = monthly_credits-credit where empid = (select empid from employee where email = DebitFromUser);

END;   


call updateop('Neymar','Suarez', 0);
*/


drop table transanctions;

CREATE TABLE transanctions(
    from_empid Number(10),
    credits Number(10),
    to_empid Number(10),
    month_date date
);


delete from transanctions;


Insert INTO transanctions VALUES(8, 1000, 9, to_date('2018-10-12', 'yyyy-mm-dd'));
Insert INTO transanctions VALUES(9, 1000, 14, to_date('2018-10-12', 'yyyy-mm-dd'));
Insert INTO transanctions VALUES(14, 500, 11, to_date('2018-10-12', 'yyyy-mm-dd'));
Insert INTO transanctions VALUES(11, 200, 12, to_date('2018-10-12', 'yyyy-mm-dd'));
Insert INTO transanctions VALUES(11, 400, 14, to_date('2018-10-12', 'yyyy-mm-dd'));
Insert INTO transanctions VALUES(8, 200, 11, to_date('2018-09-12', 'yyyy-mm-dd'));
Insert INTO transanctions VALUES(9, 200, 11, to_date('2018-09-12', 'yyyy-mm-dd'));
Insert INTO transanctions VALUES(11, 1000, 8, to_date('2018-09-12', 'yyyy-mm-dd'));
Insert INTO transanctions VALUES(12, 1000, 9, to_date('2018-09-12', 'yyyy-mm-dd'));
Insert INTO transanctions VALUES(9, 100, 14, to_date('2018-09-12', 'yyyy-mm-dd'));
Insert INTO transanctions VALUES(8, 900, 14, to_date('2018-11-12', 'yyyy-mm-dd'));
Insert INTO transanctions VALUES(9, 1000, 11, to_date('2018-11-12', 'yyyy-mm-dd'));
Insert INTO transanctions VALUES(11, 1000, 12, to_date('2018-11-12', 'yyyy-mm-dd'));
Insert INTO transanctions VALUES(12, 1000, 8, to_date(sysdate, 'dd-mon-rr'));
Insert INTO transanctions VALUES(14, 1000, 9, to_date(sysdate, 'dd-mon-rr'));

select * from transanctions;



CREATE OR REPLACE PROCEDURE updateOp(creditToUser IN string, DebitFromUser IN string, credit IN number) AS 
DF NUMBER;
CT NUMBER;
BEGIN 

select empid INTO DF from employee where email = DebitFromUser;
select empid INTO CT from employee_DETAILS where emp_first_name = creditToUser;

update credits set gift_credits = gift_credits+credit where empid = CT;

update credits set monthly_credits = monthly_credits-credit where empid = DF;

Insert INTO transanctions VALUES (DF, credit, CT, to_date(sysdate, 'dd-mon-rr'));

commit;

END; 
/

select sysdate from dual;

call updateop('Neymar', 'suarez@fcb.com', 100);


select from_empid, emp_first_name, total, yearly, monthly, rank() over (partition by monthly order by total desc) ranking from(
select from_empid, emp_first_name, sum(credits) total, EXTRACT(year FROM month_date) yearly, EXTRACT(month FROM month_date) monthly 
from transanctions, employee_details where transanctions.from_empid=employee_details.empid
group by EXTRACT(year FROM month_date), EXTRACT(month FROM month_date), from_empid, emp_first_name
order by total desc);


select to_empid, emp_first_name, total, yearly, monthly, rank() over (partition by monthly order by total desc) ranking from(
select to_empid, emp_first_name, sum(credits) total, EXTRACT(year FROM month_date) yearly, EXTRACT(month FROM month_date) monthly 
from transanctions, employee_details where transanctions.to_empid=employee_details.empid
group by EXTRACT(year FROM month_date), EXTRACT(month FROM month_date), to_empid, emp_first_name
order by yearly desc, monthly desc);




CREATE OR REPLACE View aggregatePtsGivenReport AS
(select from_empid, emp_first_name, total, yearly, monthly, rank() over (partition by monthly order by total desc) ranking from(
select from_empid, emp_first_name, sum(credits) total, EXTRACT(year FROM month_date) yearly, EXTRACT(month FROM month_date) monthly 
from transanctions, employee_details where transanctions.from_empid=employee_details.empid and transanctions.from_empid != transanctions.to_empid
group by EXTRACT(year FROM month_date), EXTRACT(month FROM month_date), from_empid, emp_first_name
order by total desc));



CREATE OR REPLACE View aggregatePtsReceiveReport AS
(select to_empid, emp_first_name, total, yearly, monthly, rank() over (partition by monthly order by total desc) ranking from(
select to_empid, emp_first_name, sum(credits) total,EXTRACT(year FROM month_date) yearly, EXTRACT(month FROM month_date) monthly 
from transanctions, employee_details where transanctions.to_empid=employee_details.empid and transanctions.from_empid != transanctions.to_empid
group by EXTRACT(year FROM month_date), EXTRACT(month FROM month_date), to_empid, emp_first_name
order by yearly desc, monthly desc));


---------------------------- User not giving points ----------------------------------

CREATE OR REPLACE PROCEDURE redeemOp(username IN string, credit IN number) AS 
DF NUMBER;

BEGIN 

select empid INTO DF from employee where email = username;

update credits set gift_credits = gift_credits-credit where empid = DF;

update credits set gift_cards_count = gift_cards_count+1 where empid = DF;

Insert INTO transanctions VALUES (DF, credit, DF, to_date(sysdate, 'dd-mon-rr'));

commit;

END; 
/


drop function InactiveUser;

select * from employee;

select * from employee_details;

select * from credits;

select * from transanctions;


-- select ids.empid, emp_first_name, emp_last_name from ((select distinct empid from employee where emp_type != 'Admin') minus (select distinct from_empid from transanctions where EXTRACT(month FROM month_date) = ? and EXTRACT(Year FROM month_date) = ?)) ids, employee_details where ids.empid = employee_details.empid;

select ids.empid, emp_first_name, emp_last_name from ((select distinct empid from employee where emp_type != 'Admin') minus (select from_empid from (select distinct from_empid, sum(credits) total from transanctions where EXTRACT(month FROM month_date) = 11 and EXTRACT(Year FROM month_date) = 2018 and from_empid != to_empid group by from_empid )where total = 1000)) ids, employee_details where ids.empid = employee_details.empid;


select ids.from_empid, emp_first_name, emp_last_name from (select from_empid, total from (select distinct from_empid, sum(1) total from transanctions where EXTRACT(month FROM month_date) = 11 and EXTRACT(Year FROM month_date) = 2018 and from_empid = to_empid group by from_empid )) ids, employee_details where ids.from_empid = employee_details.empid;







