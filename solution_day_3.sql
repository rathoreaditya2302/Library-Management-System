-- Advanced SQL Operations

/*
Task 13: Identify Members with Overdue Books
Write a query to identify members who have overdue books (assume a 30-day return period). Display the member's_id, member's name,book_title, issue date, and days overdue.
*/

SELECT * FROM members;
SELECT * FROM return_status;


select 
m.member_id,
m.member_name,
b.book_title,
ist.issued_date,
r.return_date,
current_date()- ist.issued_date as over_dues
from members as m
join
issued_status as ist
on m.member_id = ist.issued_member_id
join
book as b
on b.isbn = ist.issued_book_isbn 
left join 
return_status as r
on r.issued_id = ist.issued_id
where r.return_date is NULL 
and current_date()- ist.issued_date >30 ;


/* 
Task 14: Update Book Status on Return
-- Write a query to update the status of books in the books table to "Yes" when they are returned (based on entries in the return_status table).
*/

select * from issued_status
where issued_book_isbn = "978-0-451-52994-2" ;

SELECT * FROM book
where isbn = "978-0-451-52994-2";

update book 
set status = "no"
where isbn = "978-0-451-52994-2";

insert into return_status(return_id, issued_id, return_date, return_book_isbn)
values("RS119","IS130",current_date,"978-0-451-52994-2");

update book 
set status = "yes"
where isbn = "978-0-451-52994-2";

-- Store Procedure


DELIMITER $$

CREATE PROCEDURE add_return_records(
    IN p_return_id varchar(35),
    IN p_issued_id varchar(55)
)
BEGIN
    DECLARE v_isbn VARCHAR(50);
    DECLARE v_book_name VARCHAR(80);

    -- INSERTING INTO RETURN TABLE BASED ON USER INPUT
    INSERT INTO return_status (return_id, issued_id, return_date)
    VALUES (p_return_id, p_issued_id, CURDATE());

    -- RETRIEVING BOOK DETAILS FROM issued_status
    SELECT issued_book_isbn, issued_book_name
    INTO v_isbn, v_book_name
    FROM issued_status
    WHERE issued_id = p_issued_id;

    -- UPDATING THE STATUS OF THE BOOK IN THE BOOK TABLE
    UPDATE book 
    SET status = 'yes'
    WHERE isbn = v_isbn;

    -- DISPLAY MESSAGE (Alternative to RAISE NOTICE)
    SELECT CONCAT('THANK YOU FOR RETURNING THE BOOK: ', v_book_name) AS Message;
END $$

DELIMITER ;

SELECT *
FROM issued_status
where issued_book_isbn = "978-0-307-58837-1" ;

CALL add_return_records("RS120","IS135");

/* 
Task 15: Branch Performance Report
Create a query that generates a performance report for each branch, showing the number of books issued, the number of books returned,
and the total revenue generated from book rentals. 
*/

create table branch_report 
as SELECT 
	br.branch_id,
    br.manager_id, 
    count(ist.issued_id) as number_book_issued,
    count(rs.return_id) as number_book_returned,
    sum(bk.rental_price) as total_revenue
FROM issued_status as ist
join 
employe as em
on  ist.issued_emp_id = em.emp_id
join 
branch as br
on em.branch_id = br.branch_id
left join 
return_status as rs 
on ist.issued_id = rs.issued_id
join 
book as bk 
on ist.issued_book_isbn = bk.isbn
group by 1,2;

SELECT  *FROM branch_report;

/* Task 16: CTAS: Create a Table of Active Members
Use the CREATE TABLE AS (CTAS) statement to create a new table active_members containing members who have issued at least one book in the last 2 months. */



select * from book;
select * from members;
select * from employe;
select * from issued_status;

CREATE TABLE active_members AS
SELECT * 
FROM members 
WHERE member_id IN (
    SELECT distinct issued_member_id 
    FROM issued_status 
    WHERE issued_date >= CURRENT_DATE - INTERVAL 2 MONTH
);


SELECT * FROM active_members; 

SELECT * 
FROM members 
WHERE member_id IN (
    SELECT issued_member_id 
    FROM issued_status 
    WHERE issued_date >= CURRENT_DATE - INTERVAL 2 MONTH
);

/* 
Task 17: Find Employees with the Most Book Issues Processed
Write a query to find the top 3 employees who have processed the most book issues. Display the employee name, number of books processed, and their branch.
*/

select * from issued_status;
select * from employe;
select * from book;
select * from branch;

select 
	emp.emp_name,
    count(ist.issued_book_isbn) as no_of_book_issued,
    br.*
from issued_status as ist
join employe as emp
on ist.issued_emp_id = emp.emp_id
join branch as br
on emp.branch_id = br.branch_id
group by 1,3;

/*
Task 18: Stored Procedure Objective: 

Create a stored procedure to manage the status of books in a library system.
 
Description: Write a stored procedure that updates the status of a book in the library based on its issuance. 

The procedure should function as follows: 
The stored procedure should take the book_id as an input parameter. 
The procedure should first check if the book is available (status = 'yes'). 
If the book is available, it should be issued, and the status in the books table should be updated to 'no'. 
If the book is not available (status = 'no'), the procedure should return an error message indicating that the book is currently not available.
*/

select * from issued_status;
select * from book;

DELIMITER $$

CREATE PROCEDURE issue_book(
    p_issued_id varchar(10) , p_issued_member_id varchar(30) , p_issued_book_isbn varchar(30) , p_issued_emp_id varchar(10)
)
BEGIN
    DECLARE v_status VARCHAR(30);

    select status
    into v_status
    from book
    where isbn =  p_issued_book_isbn;
    
	if v_status = 'yes' then 
		INSERT into issued_status(issued_id, issued_member_id, issued_date, issued_book_isbn, issued_emp_id)
		values
		(p_issued_id, p_issued_member_id, current_date, p_issued_book_isbn, p_issued_emp_id);
		
        UPDATE book 
		SET status = 'no'
		WHERE isbn = p_issued_book_isbn;
        
        SELECT CONCAT('Book record added successfully for book isbn: % ',p_issued_book_isbn ) AS Message;
            
	else
        SELECT CONCAT('Sorry to inform you the book you are requested is unavailable isbn: % ',p_issued_book_isbn ) AS Message;
    End If;    
END $$

DELIMITER ;


Call issue_book('IS143', 'C109', '978-0-141-44171-6', 'E105');
Call issue_book('IS144', 'C109', '978-0-141-44171-6', 'E105');  