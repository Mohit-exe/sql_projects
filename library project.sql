#library management project
#here we will create a database for managing a small library
create database library1;
use library1;


#table authors
create table authors(authorid int primary key,name varchar(100),country varchar(50));


#table books
create table books(bookid int primary key,title varchar(200),authorid int,genre varchar(50),publishyear year,foreign key(authorid) references authors(authorid));

#table members
create table members(memberid int primary key,name varchar(100),email varchar(100),joindate date);


#table loans
create table loans(loanid int primary key,bookid int,memberid int,loandate date,returndate date,foreign key(bookid) references books(bookid),foreign key(memberid) references members(memberid));



#inserting sample data
insert into authors values(1,"jkrowling","uk");
insert into authors values(2,"george rr martin","usa");
insert into authors values(3,"jrr tolkien","uk");
insert into authors values(4,"robin sharma","india");
insert into authors values(5,"ved vyas","india");
insert into authors values(6,"munshi premchand","india");

insert into books values(1,"harry potter",1,"fantasy",1997);
insert into books values(2,"game of thrones",2,"fantasy",1996);
insert into books values(3,"the lord of the rings",3,"fantasy",1937);
insert into books values(4,"extraordinary leadership",4,"motivational",2006);
insert into books values(5,"ramayan",5,"history",1000);
insert into books values(6,"godan",6,"story",1936);

insert into members values(1,"alice","alice@gmail.com","2022-01-15");
insert into members values(2,"bob","bob@gmail.com","2022-02-15");
insert into members values(3,"sam","sam@gmail.com","2022-02-10");
insert into members values(4,"ram","ram@gmail.com","2022-02-06");
insert into members values(5,"rahim","rahim@gmail.com","2022-01-10");
insert into members values(6,"ajay","ajay@gmail.com","2022-01-13");


insert into loans values(1,1,1,"2023-06-01","2023-06-15");
insert into loans values(2,2,2,"2023-06-05","2023-06-20");
insert into loans values(3,3,3,"2023-06-10","2023-06-30");
insert into loans values(4,4,4,"2023-06-15","2023-07-05");
insert into loans values(5,5,5,"2023-06-20","2023-07-10");
insert into loans values(6,6,6,"2023-06-26","2023-07-16");



#retrive all the data
select * from books;
select * from authors;
select * from members;
select * from loans;


#QUESTIONS


#1 find all books by a specific author
select books.title,authors.name,authors.authorid 
from authors
join books on books.authorid=authors.authorid
where authors.authorid='1';


#2 find all loans by a specific member
select loans.bookid,loans.memberid,books.title from loans
join books on books.bookid=loans.bookid
where loans.memberid='1';

#3list all books currently on loan
select books.title,loans.returndate from loans
join books on
books.bookid=loans.bookid
join members on
loans.memberid=members.memberid
where loans.returndate is null;


#4find the most borrowed book
select books.title,books.bookid,count(loans.bookid) as loancount from loans
join books on
loans.bookid=books.bookid
group by books.title,books.bookid # here we've to use all the columns in group by clause because mysql throws error if there 
                                  #are less columns in group by clause than the select statement
order by loancount;  

#5list members who have borrowed more than one book
select members.name,count(loans.memberid) as loancount from loans
join members on
loans.memberid=members.memberid
group by members.name
having loancount>1;

#6  retrieve books with author's details
select books.title,books.authorid,authors.name,authors.country from authors
join books on
authors.authorid=books.authorid;

#7 find members who have not borrowed a book
select members.memberid,members.name,loans.loanid from loans
join members on
loans.memberid=members.memberid
where loanid is null;


#8 list of overdue books
select books.bookid,books.title,loans.returndate from loans
join books on
loans.bookid=books.bookid
where loans.returndate is null;

#9 total number of books borrowed by each member
select members.memberid,members.name,count(loans.bookid) as total from loans
join members on
loans.memberid=members.memberid
group by members.name,members.memberid;

#10 list of books borrowed in the last month
#assume the date today is 2024-01-01
select books.bookid,books.title,loans.loandate from loans
join books on
loans.bookid=books.bookid
group by books.bookid,books.title,loans.loandate
having loans.loandate between '2023-12-01' and '2023-12-31';

#11 find the longest borrowed book
select books.bookid,books.title,datediff(loans.loandate,loans.returndate) as diff from loans
join books on
loans.bookid=books.bookid
group by books.bookid,books.title,diff
having diff=(select max(datediff(loans.loandate,loans.returndate)));

#12 average borrow duration for each book
select books.bookid,books.title,avg(datediff(loans.loandate,loans.returndate)) as borrowtime from loans
join books on
loans.bookid=books.bookid
group by books.bookid,books.title;

#13 find the most active members(by number of loans)
select members.memberid,members.name,count(loans.loanid) from loans
join members on
loans.memberid=members.memberid
group by members.name,members.memberid;

  

