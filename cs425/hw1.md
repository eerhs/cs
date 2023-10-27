# Part 1.1 Relational Algebra (Total: 54 Points) 
Give an expression in the relational algebra to express each of the following queries:

## Question 1.1.1 (6 Points) 
a. For each relation, what is/are the appropriate primary key(s)?

Customers = CustomerID
Orders = OrderID
OrderDetails = no primary key
Products = ProductID

b. Given your choice of primary keys, identify appropriate foreign keys.

Customers = no foreign key
Orders = CustomerID
OrderDetails = OrderID, ProductID
Products = no foreign key

## Question 1.1.2 (3 Points) 
List the names of all customers.

Πname(Customers)

## Question 1.1.3 (3 Points) 
List the categories of all products. 

ΠCategory(Products)

## Question 1.1.4 (3 Points) 
List the names and the prices of all the products. 

ΠName, Price(Products)

## Question 1.1.5 (3 Points) 
Find the name of the products with a price less than or equal to $35. 

σ (Price <= 35)(Products)

## Question 1.1.6 (3 Points) 
Find all the products with a price between $10 and $100.

σ (Price >= 10 AND Price <= 100)(Products)

## Question 1.1.7 (3 Points) 
List the names of customers who made an order in March 2022. 

Π (name) ((Customers ⨝ (σ OrderDate = 'March 2022' (Orders))))

## Question 1.1.8 (3 Points) 
List names of customers who have made more than 2 orders. 

Π (name) (Customers ⨝ ((σ count > 2) γ (CustomerID; count ←  COUNT(*) Orders)))

## Question 1.1.9 (3 Points) 
Find all information about customers who made an order with a total amount greater than $300.

Π (CustomerID, name, address, city) (Customers ⨝ (σ (TotalAmount > 300) Orders))

## Question 1.1.10 (3 Points) 
List the names of all customers who spent more than every customer on product ‘Product A ’:

Π (name) (Customers ⨝ (σ(ProductID = 1) (OrderDetails ⨝ Orders)) ⨝ γ(CustomerID; total_amount ← SUM(TotalAmount)) (σ(ProductID = 1) (OrderDetails ⨝ Orders)))

## Question 1.1.11 (3 Points) 
Find the categories names of all products with price greater than $100. 

Π (Category) (σ(Price > 100) Products)

## Question 1.1.12 (3 Points) 
Find all products located in every category of Electronics. 

Π (ProductID, Name) (Products ⨝ σ(Category = 'Electronics') Products)

## Question 1.1.13 (3 Points) 
Find the product with the highest total sales amount.

Π  (Name) (Products ⨝ (σ (ProductID = MaxProductID) (γ ProductID; MaxProductID ←  MAX(Quantity) (OrderDetails ⨝ Products))))

## Question 1.1.14 (3 Points) 
For each product, list the highest, lowest, and average order total amount. 

Π  (ProductID, Name, MaxTotalAmount, MinTotalAmount, AvgTotalAmount)  ((Products ⨝ (OrderDetails ⨝ Orders)) ⨝ γ ProductID; MaxTotalAmount ← MAX(TotalAmount), MinTotalAmount ← MIN(TotalAmount), AvgTotalAmount ← AVG(TotalAmount)  (π ProductID, Name, TotalAmount  (Products ⨝ (OrderDetails ⨝ Orders))))


## Question 1.1.15 (3 Points) 
Modify the database so that the customer with the name Smith now lives in Atlanta 

UPDATE Customers
SET city = 'Atlanta'
WHERE name = 'Tom, Smith';

## Question 1.1.16 (3 Points) 
Give all orders in this database a 10 percent increase in total amount, unless the total amount would be greater than $100,000. In such cases, give only a 5 percent increase. 

UPDATE Orders
SET TotalAmount = CASE
WHEN TotalAmount * 1.10 > 100000 THEN TotalAmount * 1.05
ELSE TotalAmount * 1.10
END;


## Question 1.1.17 (3 Points) 
In February 2022, a new customer named "Manny Sammy" made an order. He lives in "Washington DC". Add the new customer and their order to the database.

INSERT INTO Customers (CustomerID, name, address, city)
VALUES ('e1004', 'Manny Sammy', 'street address', 'Washington DC');

INSERT INTO Orders (OrderID, CustomerID, OrderDate, TotalAmount)
VALUES (4, 'e1004', 'February 2022', 0);


