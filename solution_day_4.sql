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