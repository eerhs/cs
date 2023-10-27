# Part 2.1 SQL Queries (Total: 75 Points)
Write the following queries in SQL, using the university schema.

## Question 2.1.1 (2 Points) 
Find the titles of courses in the Comp. Sci. department that has 4 credits. 
``` sql
select title 
from course 
where dept name = ’Comp. Sci.’ and credits = 4;
```
## Question 2.1.2 (2 Points) 
Find the IDs of all students who were taught by an instructor named Einstein; make sure there are no duplicates in the result.
``` sql
select distinct takes.ID 
from instructor
natural join teaches join takes using (course_id, sec_id, semester, year)
where instructor.name = ’Einstein’;
```
## Question 2.1.3 (3 Points) 
For each department, find the lowest and highest salary of instructors in that department. Order the result in ascending order by the lowest salaries. 
``` sql
select dept_name, min(salary) as min_salary , max(salary) as max_salary
from instructor
group by dept_name
order by min_salary
```
## Question 2.1.4 (3 Points) 
Find the maximum enrollment, across all sections, in Fall 2019. 
``` sql
select max(enrollment) 
from (select count(ID) as enrollment 
from section natural join takes
where semester = ‘Fall’ and year = 2019
group by course_id, sec_id) as qi;
```
## Question 2.1.5 (3 Points) 
Find the names of those departments whose budget is higher than that of Philosophy. List them in alphabetical order. 
``` sql
select X.dept name
from department as X, department as H
where H.dept name = ’Philosophy’ and X.budget > H.budget
order by X.dept name
```
## Question 2.1.6 (3 Points) 
Find the ID and title of each course in Comp. Sci. that has had at least one section with afternoon hours (i.e., ends at or after 12 : 00). (You should eliminate duplicates if any.) 
``` sql
select distinct course.course_id , course.title
from course, section, time_slot
where course.course_id = section.course_id
and section.time_slot_id = time_slot.time_slot_id
and time_slot.end_time >= 12
and course.dept_name = ’Comp. Sci.’;
```
## Question 2.1.7 (3 Points) 
Find the enrollment of each section that was offered in Spring 2017. 
``` sql
select course_id, sec_id, count(ID) as enrollment
from section natural left outer join takes
where semester = ’Spring’ and year = 2017
group by course_id, sec_id;
```
## Question 2.1.8 (3 Points) 
Find the sections that had the maximum enrollment in Fall 2017 
``` sql
with sec_enrollment as (
    select course_ id, sec_id, count(ID) as enrollment
    from section natural join takes
    where semester = ’Fall’ and year = 2017
    group by course_id, sec_id)
select course_ id, sec_id
from sec_enrollment
where enrollment = (select max(enrollment) from sec_enrollment);
```
## Question 2.1.9 (3 Points) 
Find the total number of distinct students who have taken course sections taught by the instructor with ID 19368. 
``` sql
select count (distinct ID)
from takes
where (course_id, sec_id, semester, year) in (select course_id, sec_id, semester, year
                                              from teaches
                                              where ID = ’19368’);
```
## Question 2.1.10 (3 Points) 
Find the ID and name of each student who has not taken any course offered before 2017. 
``` sql
select distinct ID, name
from student
where ID not in (select ID
                 from takes
                 where year < 2017);
```
## Question 2.1.11 (5 Points) 
Find the name and salary of the instructors whose salary is greater than the average salary of all departments. Hint: Find the average salary by department 
``` sql
select * from instructor
where salary > all (select avg(salary) from instructor group by dept_name);
```
## Question 2.1.12 (5 Points) 
Find the name and salary of the instructors whose salary is greater than the average salary for their department.
``` sql
select id, R.dept_name, salary
from instructor R join (select dept_name , avg(salary) as avgSalary
                        from instructor
                        group by dept_name) AS S
                  on R.dept_name = S.dept_name
where salary > avgSalary;
```
## Question 2.1.13 (3 Points) 
For each course section offered in 2019, find the average total credits of all students enrolled in the section, if the section had at least 2 students. 
``` sql
select course_id, sec_id, semester, year, avg(tot_cred)
from student S natural join takes T
where year = 2019
group by course_id, sec_id, semester, year
having count(T.id) >= 2;
```
## Question 2.1.14 (5 Points) 
For each student who has retaken a course at least twice (i.e., the student has taken the course at least three times), show the course ID and the student’s ID. Please display your results in order of course ID and do not display duplicate rows. 
``` sql
select distinct course_id, ID
from takes
group by ID, course_id
having count (*) > 2
order by course_id;
```
## Question 2.1.15 (5 Points) 
Find the IDs of those students who have retaken at least three distinct courses at least once (i.e, the student has taken the course at least two times).
``` sql
select distinct ID
from (select course_id, ID
      from takes
      group by ID, course_id
      having count (*) > 1) as q1
group by ID
having count (course_id) > 2;
```
## Question 2.1.16 (5 Points) 
Find the names and IDs of those instructors who teach every course taught in his or her department (i.e., every course that appears in the course relation with the instructor’s department name). Order result by name 
``` sql
select id, name
from instructor as i
where not exists (
    (select course_id
     from course as c
     where c.dept_name = i.dept_name)
    except 
     select distinct course_id
     from instructor i1 natural join teaches t1
     where i1.id = i.id
    )
order by name;
```
## Question 2.1.17 (5 Points) 
Find the name and ID of each Computer student whose name begins with the letter ’D’ and who has not taken at least five Math courses.
``` sql
select id, name
from student
where dept_name = ‘Comp. Sci.’ and name like 'D%'
and id not in (select id
               from takes natural join course
               where dept_name = ’Math’
               group by id
               having count (course_id) >= 5);
```
## Question 2.1.18 (3 Points) 
Find all the students whose names are 5 characters long 
``` sql
select name
from student
where name like ’_____’;
```
## Question 2.1.19 (5 Points) 
Find the ID and name of each instructor who has never given an A grade in any course she or he has taught. (Instructors who have never taught a course trivially satisfy this condition.) 
``` sql
select id, name
from instructor
except
  select distinct instructor.id , instructor.name
  from instructor natural join teaches natural join takes
  where takes.grade like ’A’;
```
## Question 2.1.20 (6 Points) 
Consider the query:
``` sql
with dept total (dept_name, value) as
               (select dept_name, sum(salary)
                from instructor
                group by dept_name),
         dept total avg (value) as
                (select avg(value)
                from dept_total)
select dept_name
from dept_total, dept_total_avg
where dept_total.value >= dept_total_avg.value;
```
Rewrite this query without using the with construct.
``` sql
select distinct dept_name
from instructor as i
where (select sum(salary)
       from instructor
       where dept_name = i.dept_name) >= (select avg(s)
                                          from (select sum (salary) as s
                                                from instructor
                                                group by dept_name
                                               )
                                         )
```

# Part 2.2 SQL Updates (Total: 15 Points)
## Question 2.2.1 (15 Points)
### Write the SQL statements using the university schema to perform the following operations
Create a new course “CS-001”, titled “Weekly Seminar”, with 0 credits
``` sql
insert into course
values (’001’, ’Weekly Seminar’, ’Comp. Sci.’, 0)
```
Create a section of this course in Fall 2017, with sec_id of 1, and with the location of this section not yet specified.
``` sql
insert into section
values (’001’, 1, ’Fall’, 2017 , null , null , null)
```
Enroll every student in the Comp. Sci. department in the above section
``` sql
insert into takes
    select ID , ’001’, 1, ’Fall’, 2017 , null
    from student
    where dept_name = ’Comp. Sci.’
```
Delete enrollments in the above section where the student’s ID is 12345
``` sql
delete from takes
    where course_id = ’001’ and sec_id = 1 and semester = ’Fall’ and year = 2017 and ID = 12345
```
Delete all takes tuples corresponding to any section of any course with the word “advanced” as a part of the title; ignore case when matching the word with the title.
``` sql
delete from takes 
where course_id in (select course_id
                    from course
                    where lower(title) like '%advanced%')
```

# Part 2.3 SQL DDL (Total: 10 Points)
## Question 2.3.1 (10 Points)
Write the SQL DDL corresponding to the schema in the Homework Assignment I. Make any reasonable assumptions about data types, and be sure to declare primary and foreign keys.
``` sql
CREATE TABLE Customers (
    CustomerID CHAR(5) PRIMARY KEY,
    name VARCHAR(50),
    address VARCHAR(100),
    city VARCHAR(20)
);

CREATE TABLE Orders (
    OrderID CHAR(100) PRIMARY KEY,
    CustomerID CHAR(5),
    OrderDate VARCHAR(20),
    TotalAmount NUMERIC (10, 2),
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);

CREATE TABLE OrderDetails (
    OrderID CHAR(100),
    ProductID CHAR(100),
    Quantity NUMERIC(10000),
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);

CREATE TABLE Products (
    ProductID CHAR(100) PRIMARY KEY,
    Name VARCHAR(50),
    Category VARCHAR(50),
    Price NUMERIC(6, 2)
);
```
