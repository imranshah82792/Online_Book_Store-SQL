-- CREATE DATABASE
CREATE DATABASE OnlineBookStore;

-- USE DATABASE
USE OnlineBookStore;

-- CREATE TABLES
DROP TABLE IF EXISTS Books;
CREATE TABLE Books(
Book_Id SERIAL PRIMARY KEY,
Title VARCHAR(100),
Author VARCHAR(100),
Genre VARCHAR(50),
Published_Year INT,
Price NUMERIC(10,2),
Stock int
);


DROP TABLE IF EXISTS Customers;
CREATE TABLE Customers(
Customer_Id SERIAL PRIMARY KEY,
Name VARCHAR(100),
Email VARCHAR(100),
Phone VARCHAR(15),
City VARCHAR(50),
country VARCHAR(100)
);


DROP TABLE IF EXISTS Orders;
CREATE TABLE Orders(
Order_Id SERIAL PRIMARY KEY,
Customer_Id INT REFERENCES Customers(Customer_Id),
Book_Id INT REFERENCES Books(Book_Id),
Order_Date DATE ,
Quantity INT ,
Total_Amount NUMERIC(10,2)
);


SELECT * FROM Books;
SELECT * FROM Customers;
SELECT * FROM Orders;


LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Books.csv'
INTO TABLE Books
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"' 
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;


LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Customers.csv'
INTO TABLE Customers
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"' 
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;


LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Orders.csv'
INTO TABLE Orders
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"' 
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(Order_ID, Customer_ID, Book_ID, @Order_Date, Quantity, Total_Amount)
SET Order_Date = STR_TO_DATE(@Order_Date, '%d-%m-%Y');


-- 1) Retrieve all books in the 'Fiction' genre:
SELECT * FROM Books
where Genre = 'Fiction';


-- 2) Find all books Published after 1950
SELECT * FROM Books
where Published_Year > 1950 ;


-- 3) List all customers from the Canada:
SELECT * FROM Customers 
WHERE country='Canada';


-- 4) Show orders placed in November 2023:
SELECT * FROM Orders 
WHERE order_date BETWEEN '2023-11-01' AND '2023-11-30';

-- 5) Retrieve the total stock of books available:
SELECT SUM(stock) AS Total_Stock
From Books;


-- 6) Find the details of the most expensive book:
SELECT * FROM Books 
ORDER BY Price DESC 
LIMIT 1;


-- 7) Show all customers who ordered more than 1 quantity of a book:
SELECT * FROM Orders 
WHERE quantity>1;



-- 8) Retrieve all orders where the total amount exceeds $20:
SELECT * FROM Orders 
WHERE total_amount>20;



-- 9) List all genres available in the Books table:
SELECT DISTINCT genre FROM Books;


-- 10) Find the book with the lowest stock:
SELECT * FROM Books 
ORDER BY stock 
LIMIT 1;


-- 11) Calculate the total revenue generated from all orders:
SELECT SUM(total_amount) As Revenue 
FROM Orders;

-- Advance Questions : 

-- 12) Retrieve the total number of books sold for each Genre
SELECT b.Genre , SUM(o.Quantity) AS Total_BookSold
FROM Books AS b
JOIN Orders AS O
ON b.Book_Id = o.Book_Id
GROUP BY b.Genre;


-- 13) Find the avg price of books in the 'Fantasy' Genre
SELECT AVG(Price) AS AVG_PRICE
FROM Books
WHERE Genre = 'Fantasy';


-- 14) List customers who have placed atleaast 2 orders
SELECT o.Customer_Id , c.Name ,COUNT(o.Order_Id) AS OrderID
FROM Orders AS o
JOIN Customers AS c
ON c.Customer_Id = o.Customer_Id
GROUP BY o.Customer_Id , c.Name
HAVING COUNT(o.Order_Id) >= 2;


-- 15) Find the most frequently orderd book
SELECT o.Book_Id , b.Title , COUNT(o.Order_Id) AS ORD_COUNT
FROM Orders AS o
JOIN Books AS b
ON o.Book_Id = b.Book_Id
GROUP BY o.Book_Id , b.Title
ORDER BY ORD_COUNT DESC , o.Book_Id DESC;


-- 16) Show the Top 3 Most expensive books of 'Fantasy' Genre
SELECT * FROM Books 
WHERE Genre = 'Fantasy'
ORDER BY Price DESC LIMIT 3;


-- 17) Retrieve the total quantity of books sold by each author
SELECT b.author, SUM(o.quantity) AS Total_Books_Sold
FROM orders o
JOIN books b ON o.book_id=b.book_id
GROUP BY b.Author;


-- 18) List the cities where customers who spent over $30 are located:
SELECT DISTINCT c.city, total_amount
FROM orders o
JOIN customers c ON o.customer_id=c.customer_id
WHERE o.total_amount > 30;


-- 19) Find the customer who spent the most on orders:
SELECT c.customer_id, c.name, SUM(o.total_amount) AS Total_Spent
FROM orders o
JOIN customers c ON o.customer_id=c.customer_id
GROUP BY c.customer_id, c.name
ORDER BY Total_spent Desc LIMIT 1;


-- 20) Calculate the stock remaining after fulfilling all orders:
SELECT b.book_id, b.title, b.stock, COALESCE(SUM(o.quantity),0) AS Order_quantity,  
	b.stock- COALESCE(SUM(o.quantity),0) AS Remaining_Quantity
FROM books b
LEFT JOIN orders o ON b.book_id=o.book_id
GROUP BY b.book_id ORDER BY b.book_id;


