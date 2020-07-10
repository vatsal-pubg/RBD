--S21778
--VATSAL PATEL

BEGIN
  FOR c IN ( SELECT table_name FROM user_tables)
  LOOP
    EXECUTE IMMEDIATE 'DROP TABLE ' || c.table_name || ' CASCADE CONSTRAINTS' ;
  END LOOP;
END;
/

BEGIN
  FOR c IN ( SELECT sequence_name FROM user_sequences WHERE sequence_name NOT LIKE '%$%')
  LOOP
    EXECUTE IMMEDIATE 'DROP SEQUENCE ' || c.sequence_name;
  END LOOP;
END;

/

CREATE TABLE Booking (
    idbooking integer  NOT NULL,
    datefrom date  NOT NULL,
    dateto date  NOT NULL,
    Guest_idguest integer  NOT NULL,
    Room_roomid integer  NOT NULL,
    CONSTRAINT Booking_pk PRIMARY KEY (idbooking)
) ;

--  Category
CREATE TABLE Category (
    idcategory integer  NOT NULL,
    name varchar2(20)  NOT NULL,
    price number(8,2)  NOT NULL,
    CONSTRAINT Category_pk PRIMARY KEY (idcategory)
) ;

-- Guest
CREATE TABLE Guest (
    idguest integer  NOT NULL,
    firstname varchar2(20)  NOT NULL,
    lastname varchar2(30)  NOT NULL,
    CONSTRAINT Guest_pk PRIMARY KEY (idguest)
) ;

--  Room
CREATE TABLE Room (
    roomid integer  NOT NULL,
    number_of_beds integer  NOT NULL,
    Category_idcategory integer  NOT NULL,
    CONSTRAINT Room_pk PRIMARY KEY (roomid)
) ;

-- foreign keys
-- Reference: Booking_Guest (table: Booking)
ALTER TABLE Booking ADD CONSTRAINT Booking_Guest
    FOREIGN KEY (Guest_idguest)
    REFERENCES Guest (idguest);

-- Reference: Booking_Room (table: Booking)
ALTER TABLE Booking ADD CONSTRAINT Booking_Room
    FOREIGN KEY (Room_roomid)
    REFERENCES Room (roomid);

-- Reference: Room_Category (table: Room)
ALTER TABLE Room ADD CONSTRAINT Room_Category
    FOREIGN KEY (Category_idcategory)
    REFERENCES Category (idcategory);




INSERT INTO Guest (idguest,firstname,lastname) VALUES (1, 'sachin', 'tendulkar');
INSERT INTO Guest (idguest,firstname,lastname) VALUES (2, 'virat', 'kholi');
INSERT INTO Guest (idguest,firstname,lastname) VALUES (3, 'hardik', 'pandiya');
INSERT INTO Guest (idguest,firstname,lastname) VALUES (4, 'rohit', 'sharma');
INSERT INTO Guest (idguest,firstname,lastname) VALUES (5, 'prahsant', 'sharma');
INSERT INTO Guest (idguest,firstname,lastname) VALUES (6, 'Hulk', 'Hogan');

INSERT INTO Category (idcategory,name,price) VALUES (1, 'Regular', 100);
INSERT INTO Category (idcategory,name,price) VALUES (2, 'Duplex', 180);
INSERT INTO Category (idcategory,name,price) VALUES (3, 'Luxury', 500);
INSERT INTO Category (idcategory,name,price) VALUES (4, 'Platinum', 300);
INSERT INTO Category (idcategory,name,price) VALUES (5, 'UltraLux', 500);

INSERT INTO Room (roomid, Category_idcategory, number_of_beds) VALUES (101, 1, 2);
INSERT INTO Room (roomid, Category_idcategory, number_of_beds) VALUES (102, 1, 2);
INSERT INTO Room (roomid, Category_idcategory, number_of_beds) VALUES (103, 1, 3);
INSERT INTO Room (roomid, Category_idcategory, number_of_beds) VALUES (201, 2, 2);
INSERT INTO Room (roomid, Category_idcategory, number_of_beds) VALUES (202, 3, 2);


INSERT INTO Booking (idbooking, datefrom, dateto, Guest_idguest, Room_roomid) VALUES (1, to_date('2019-07-01', 'YYYY-MM-DD'), to_date('2019-07-05', 'YYYY-MM-DD'), 1, 101);
INSERT INTO Booking (idbooking, datefrom, dateto, Guest_idguest, Room_roomid) VALUES (2, to_date('2019-01-03', 'YYYY-MM-DD'), to_date('2019-01-15', 'YYYY-MM-DD'), 1, 102);
INSERT INTO Booking (idbooking, datefrom, dateto, Guest_idguest, Room_roomid) VALUES (3, to_date('2019-07-15', 'YYYY-MM-DD'), to_date('2019-08-02', 'YYYY-MM-DD'), 2, 101);
INSERT INTO Booking (idbooking, datefrom, dateto, Guest_idguest, Room_roomid) VALUES (4, to_date('2019-12-12', 'YYYY-MM-DD'), to_date('2019-12-14', 'YYYY-MM-DD'), 3, 103);
INSERT INTO Booking (idbooking, datefrom, dateto, Guest_idguest, Room_roomid) VALUES (5, to_date('2019-05-01', 'YYYY-MM-DD'), to_date('2019-05-05', 'YYYY-MM-DD'), 3, 101);
INSERT INTO Booking (idbooking, datefrom, dateto, Guest_idguest, Room_roomid) VALUES (6, to_date('2019-04-01', 'YYYY-MM-DD'), to_date('2019-05-01', 'YYYY-MM-DD'), 4, 102);
INSERT INTO Booking (idbooking, datefrom, dateto, Guest_idguest, Room_roomid) VALUES (7, to_date('2019-11-15', 'YYYY-MM-DD'), to_date('2019-11-20', 'YYYY-MM-DD'), 4, 103);
INSERT INTO Booking (idbooking, datefrom, dateto, Guest_idguest, Room_roomid) VALUES (8, to_date('2019-10-01', 'YYYY-MM-DD'), to_date('2019-10-07', 'YYYY-MM-DD'), 5, 202);
INSERT INTO Booking (idbooking, datefrom, dateto, Guest_idguest, Room_roomid) VALUES (9, to_date('2019-10-10', 'YYYY-MM-DD'), to_date('2019-10-13', 'YYYY-MM-DD'), 5, 201);




--where
--SHOW THE PRICE OF ROOM NUMBER 101
SELECT R.Category_idcategory,C.price,R.ROOMID
FROM ROOM R,CATEGORY C
WHERE R.ROOMID=101;

SELECT G.FIRSTNAME,G.LASTNAME,B.DATEFROM
FROM GUEST G join BOOKING B
on G.IDGUEST=B.Guest_idguest
WHERE DATEFROM= to_date('2019-10-01', 'YYYY-MM-DD');

--function
--CALCULATE HOW MANY PEOLE CAN STAY AT HOTEL AT SAME TIME
SELECT Sum(number_of_beds)
FROM ROOM;

--list room RENT by rohit 
SELECT B.IDBOOKING,G.FIRSTNAME
FROM BOOKING B,Guest G
WHERE G.IDGUEST=B.Guest_idguest AND G.firstname='ROHIT';



--CALCULATE HIEGHT NUMBER OF BED ROOM
SELECT MAX(number_of_beds),ROOMID
FROM ROOM
GROUP BY ROOMID;

select * from guest;

---SUB QUREY
--FIND A ROOME WHICH IS NEVER BOOKED
SELECT ROOMID
FROM ROOM 
WHERE ROOMID NOT IN (SELECT ROOM_ROOMID
              FROM BOOKING);


----CORELATED QUREY TO FIND MAX PRICE OF ROOMS.
SELECT *
FROM Category c
WHERE c.Price=(SELECT Max(c2.price)
                 FROM Category c2
                 WHERE c2.idCategory=c.idCategory );
                 
                 

SET SERVEROUTPUT ON;

---------------------------------------------------------------------INSERT----------------------------------------------------
--AFTER
CREATE OR REPLACE TRIGGER T1
AFTER INSERT ON GUEST 
DECLARE X INTEGER;
BEGIN
SELECT COUNT(IDGUEST) INTO X 
FROM GUEST;
dbms_output.put_line('TOTAL NUMBER OF GUEST ARE RESGISTER IN HOTEL ARE'  ||x||   '');
END;
/

INSERT INTO Guest (idguest,firstname,lastname) VALUES (7, 'prahsant', 'patel');

--BEFORE 
CREATE OR REPLACE TRIGGER T2
BEFORE INSERT ON GUEST FOR EACH ROW
BEGIN
SELECT NVL(MAX(idGUEST) +1,1)
INTO :NEW.IDGUEST
FROM GUEST;
END;
/
INSERT INTO Guest (firstname,lastname) VALUES ('sachin', 'tendulkarHHH');

--SELECT*FROM GUEST;

--------------------------------------------------UPDATE--------------------------------------------------------------

CREATE OR REPLACE TRIGGER T3
AFTER UPDATE OF firstname ON GUEST FOR EACH ROW
BEGIN
dbms_output.put_line('guest fisrt name has changed from'    ||:old.firstname||     'to'      ||:new.firstname);
END;
/

--INSERT INTO Guest (idguest,firstname,lastname) VALUES (1, 'sachin', 'tendulkar');
--INSERT INTO Room (roomid, Category_idcategory, number_of_beds) VALUES (101, 1, 2);
UPDATE  Guest SET firstname='VVATSAK'
WHERE IDGUEST=1;


-- CREATE OR REPLACE TRIGGER T7
-- AFTER UPDATE OF LASTNAME ON GUEST FOR EACH ROW
-- BEGIN
-- dbms_output.put_line('guest fisrt name has changed from'    ||:old.LASTNAME||     'to'      ||:new.LASTNAME);
-- END;
-- /


--CREATE OR REPLACE TRIGGER T4
--After UPDATE OF FIRSTNAME ON GUEST FOR EACH ROW
--DECLARE X VARCHAR2(15);
--BEGIN
--SELECT FIRSTNAME INTO X FROM GUEST
--WHERE FIRSTNAME=:OLD.FIRSTNAME  AND X=:OLD.FIRSTNAME;
--IF :OLD.FIRSTNAME=:NEW.FIRSTNAME THEN
--dbms_output.put_line('OPPS THIS NAME IS ALREDY TAKEN');
--END IF;
--END;
--/
--
--UPDATE Guest SET firstname='VVATSAK', lastname='PATEL' WHERE IDGUEST=9;


---------------------------------------------DELETE-----------------------------------------------------------------------

CREATE OR REPLACE TRIGGER T5
BEFORE DELETE
ON Category
FOR EACH ROW
BEGIN
    dbms_output.put_line('Employee ' || :old.Name || ' will be deleted.');
END;
/
Delete From Category where IdCategory=5;

CREATE OR REPLACE TRIGGER T6
BEFORE DELETE ON Guest FOR EACH ROW
DECLARE 
X INTEGER;
BEGIN
    SELECT COUNT(1) INTO X FROM  Guest; 
    dbms_output.put_line(X || ' Guest reamaining.');
END;
/
DELETE FROM Guest WHERE idGuest=6;

