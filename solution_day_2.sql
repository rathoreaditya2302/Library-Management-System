-- Task 7. Retrieve All Books in a Specific Category:

select *
from book
where category = "fiction" or category = "HIstory";

-- Task 8: Find Total Rental Income by Category:

select book.category,sum(book.rental_price)
from book 
join issued_status as isd
on book.isbn = isd.issued_book_isbn
group by 1;

-- Task 9:List Members Who Registered in the Last 180 Days:

insert into members values("C120","James Anderson","23 belgium","2025-02-23");
insert into members values("C121","Pat Cummins","5 Ausstralia","2025-02-23");
insert into members values("C122","Steve Smith","6 Ausstralia","2025-04-4");
insert into members values("C123","Bumrah","254 Delhi,India","1985-10-15");
insert into members values("C124","Rohit Sharma","264 Mumbai,India","1980-09-23");

insert into members values("C122","Bumrah","254 Delhi,India","1985-10-15");

SELECT * 
FROM members 
WHERE reg_date >= DATE_ADD(NOW(), INTERVAL -180 DAY)
LIMIT 1000;

-- Task 10: List Employees with Their Branch Manager's Name and their branch details:

select 
e1.*,
br.manager_id,
e2.emp_name as manager 
from employe as e1
join branch as br 
on br.branch_id = e1.branch_id
join employe as e2
on br.manager_id = e2.emp_id;

-- Task 11. Create a Table of Books with Rental Price Above a Certain Threshold 7USD:

create table books_7 
as select * from book
where rental_price >= 7;

select * from book_price_greater_than_7;

rename table books_7 to book_price_greater_than_7;

-- Task 12: Retrieve the List of Books Not Yet Returned

SELECT * FROM return_status;
SELECT * FROM issued_status;

select ist.issued_book_name from 
issued_status as ist
left join return_status as rs
on ist.issued_id = rs.issued_id
where rs.return_id is null;