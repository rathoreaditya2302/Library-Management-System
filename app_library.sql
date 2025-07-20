-- LIBRARY MANAGEMENT SYSTEM PROJECT 

-- *** 1. " Database Setup "

-- Creating database 

create database library_project;

use library_project; 

-- Creating table " Branch "
drop table if exists branch;
create table branch(
branch_id  varchar(20) not null,                     
manager_id varchar(20) not null,
branch_address varchar(55) not null,
contact_no varchar(20)
);

-- Altering " Branch " table 
alter table branch 
change column branch_id  branch_id varchar(20) primary key not null;

-- Creating table " Employe " 
drop table if exists employe;
create table employe(
emp_id varchar(20) primary key ,
emp_name varchar(50),
position varchar(50),
salary double,
branch_id varchar(20),
foreign key(branch_id) references branch(branch_id)
);

-- Create table " Books "
drop table if exists book;
create table book(
isbn varchar(25) primary key ,
book_title varchar(55),
category varchar(25),
rental_price float,
status varchar(15),
author varchar(25),
publisher varchar(30)
);

-- Create table " Members "
drop table if exists members;
create table members(
 member_id varchar(20) primary key ,
 member_name varchar(35) ,
 member_address varchar(75),
 reg_date date
 );
 
 -- Create table " Issued_Status "
 create table issued_status(
 issued_id varchar(10) primary key,
 issued_member_id varchar(20) ,
 issued_book_name varchar(55) ,
 issued_date date ,
 issued_book_isbn varchar(25) ,
 issued_emp_id varchar(20),
 foreign key(issued_book_isbn) references book(isbn),
 foreign key(issued_emp_id) references employe(emp_id),
 foreign key(issued_member_id) references members(member_id)
);

-- Create table " Return_Status "
create table return_status(
 return_id varchar(10) primary key,	
 issued_id varchar(10),
 return_book_name varchar(55),
 return_date date,
 return_book_isbn varchar(25),
 foreign key(issued_id) references issued_status(issued_id),
 foreign key(return_book_isbn) references book(isbn)
);


-- Project tasks;

-- *** 2. " CRUD Operations "

-- Create: Inserted sample records into the books table.
-- Read: Retrieved and displayed data from various tables.
-- Update: Updated records in the employees table.       
-- Delete: Removed records from the members table as needed.

-- Task 1. Create a New Book Record -- "978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee',  'J.B. Lippincott & Co.')"

-- Task 2: Update an Existing Member's Address

-- Task 3: Delete a Record from the Issued Status Table -- Objective: Delete the record with issued_id = 'IS121' and 'IS122' from the issued_status table.

-- Task 4: Retrieve All Books Issued by a Specific Employee -- Objective: Select all books issued by the employee with emp_id = 'E101'.

-- Task 5: List Members Who Have Issued More Than One Book -- Objective: Use GROUP BY to find members who have issued more than one book.

-- Task 6: Create Summary Tables: Used CTAS to generate new tables based on query results - each book and total        book_issued_cnt**

-- Task 7. Retrieve All Books in a Specific Category:

-- Task 8: Find Total Rental Income by Category:

-- Task 9:List Members Who Registered in the Last 180 Days:

-- Task 10: List Employees with Their Branch Manager's Name and their branch details:

-- Task 11. Create a Table of Books with Rental Price Above a Certain Threshold 7USD:

-- Task 12: Retrieve the List of Books Not Yet Returned

-- *** 3. " Advanced SQL Operations "

/*
Task 13: Identify Members with Overdue Books
Write a query to identify members who have overdue books (assume a 30-day return period). Display the member's_id, member's name,book_title, issue date, and days overdue.
*/

/* 
Task 14: Update Book Status on Return
-- Write a query to update the status of books in the books table to "Yes" when they are returned (based on entries in the return_status table).
*/

 
/* 
Task 15: Branch Performance Report
Create a query that generates a performance report for each branch, showing the number of books issued, the number of books returned,
and the total revenue generated from book rentals. 
*/

/* Task 16: CTAS: Create a Table of Active Members
Use the CREATE TABLE AS (CTAS) statement to create a new table active_members containing members who have issued at least one book in the last 2 months. */


/* 
Task 17: Find Employees with the Most Book Issues Processed
Write a query to find the top 3 employees who have processed the most book issues. Display the employee name, number of books processed, and their branch.
*/


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