USE KeffiTechSalesDB
GO

SELECT
	TABLE_SCHEMA, 
	TABLE_NAME
FROM INFORMATION_SCHEMA.TABLES;

SELECT *
FROM dbo.KeffiSalesTech;

SELECT COUNT(*) AS Total_Row
FROM dbo.KeffiSalesTech;

SELECT TOP(10)*
FROM dbo.KeffiSalesTech;

SELECT
	COLUMN_NAME,
	DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'KeffiSalesTech';

--Checking Actual Value before changing anything
SELECT TOP (20)
	Sales_ID,
	Quantity,
	Unit_Price,
	Sales_Date
FROM dbo.KeffiSalesTech

--Investigating Why Quantity is nvarchar data type
SELECT
	Quantity
FROM dbo.KeffiSalesTech
WHERE Quantity LIKE '%[^0-9]%';

--Check Missing Value
SELECT
    SUM(CASE WHEN NULLIF(TRIM(Sales_ID), '') IS NULL THEN 1 ELSE 0 END) AS MissingSalesID,
    SUM(CASE WHEN NULLIF(TRIM(Customer_Name), '') IS NULL THEN 1 ELSE 0 END) AS MissingCustomerName,
    SUM(CASE WHEN NULLIF(TRIM(Gender), '') IS NULL THEN 1 ELSE 0 END) AS MissingGender,
    SUM(CASE WHEN NULLIF(TRIM(Country), '') IS NULL THEN 1 ELSE 0 END) AS MissingCountry,
    SUM(CASE WHEN NULLIF(TRIM(Category), '') IS NULL THEN 1 ELSE 0 END) AS MissingCategory,
    SUM(CASE WHEN NULLIF(TRIM(Product), '') IS NULL THEN 1 ELSE 0 END) AS MissingProduct,
    SUM(CASE WHEN Quantity IS NULL THEN 1 ELSE 0 END) AS MissingQuantity,
    SUM(CASE WHEN Unit_Price IS NULL THEN 1 ELSE 0 END) AS MissingUnitPrice,
    SUM(CASE WHEN NULLIF(TRIM(Payment_Method), '') IS NULL THEN 1 ELSE 0 END) AS MissingPaymentMethod
FROM dbo.KeffiSalesTech;


--Display Missing Record
SELECT *
FROM dbo.KeffiSalesTech
WHERE Gender IS NULL
	OR Category IS NULL
	OR Product IS NULL
	OR Quantity IS NULL;

--Investigating Missing Record

SELECT 
	COUNT (*) AS RecordwithMissingValue
FROM dbo.KeffiSalesTech
WHERE Gender IS NULL
	OR Category IS NULL
	OR Product IS NULL
	OR Quantity IS NULL;

SELECT
	Sales_ID,
	Sales_Date,
	Customer_Name,
	Gender,
	Country,
	Category,
	Product,
	Quantity,
	Unit_Price,
	Payment_Method
FROM dbo.KeffiSalesTech
WHERE Gender IS NULL
	OR Category IS NULL
	OR Product IS NULL
	OR Quantity IS NULL;

--Checking Duplicate
SELECT 
	Sales_ID,
	Count (*) AS NumberOfRecords
FROM dbo.KeffiSalesTech
GROUP BY Sales_ID
HAVING COUNT(*) > 1;

SELECT
	Sales_Date,
	Customer_Name,
	Gender,
	Country,
	Category,
	Product,
	Quantity,
	Unit_price,
	Payment_Method,
	COUNT(*) AS NumbersOfRecord
FROM dbo.KeffiSalesTech
GROUP BY
	Sales_Date,
	Customer_Name,
	Gender,
	Country,
	Category,
	Product,
	Quantity,
	Unit_price,
	Payment_Method
HAVING COUNT(*) > 1;

--Renaming Column
SELECT
	Customer_Name AS Customer,
	Unit_Price AS Price,
	Sales_Date AS Date,
	Category AS ProductCategory,
	Payment_method AS PaymentMethod
FROM dbo.KeffiSalesTech;

--Checking Missing  and Handling Product Category
UPDATE dbo.KeffiSalesTech 
SET Category =
    CASE 
        WHEN Product = 'Bookshelf' THEN 'Furniture'
        WHEN Product = 'Headphones' THEN 'Electronics'
        WHEN Product = 'Jacket' THEN 'Clothing'
        WHEN Product = 'Office Chair' THEN 'Furniture'
    END
WHERE Category IS NULL;

--Checking Missing and Handling Gender
UPDATE dbo.KeffiSalesTech
SET Gender = 'Unknown'
WHERE Gender IS NULL;


--Handling, Investigating and Replacing Missing values in Quantity.
--Checking
SELECT
	Customer_Name,
	Product,
	Quantity,
	Unit_Price
FROM dbo.KeffiSalesTech
WHERE Quantity IS NULL;


--Investigating to check for transaction record.
SELECT 
	Customer_Name,
	Product,
	Quantity,
	Unit_Price
FROM dbo.KeffiSalesTech
WHERE Customer_Name IN ('Michael James', 'David Okoro','John Williams', 'Ibrahim Yusuf');

--we notice that the bought other product in different quantity, so therefore we can replace null quantity rather leave as NULL.
--To Calculate Revenue
SELECT 
	Sales_ID,
	Customer_Name,
	Product,
	Quantity,
	Unit_Price,
	Quantity * Unit_Price AS Revenue
FROM dbo.KeffiSalesTech;

--Done With Data Cleaning. Moving to Answering Business Question.
--How much revenue did KEFFITECH generarte from all Sales
SELECT
	SUM(Quantity * Unit_Price) AS TotalRevenue
FROM dbo.KeffiSalesTech;

--Which product generate the most revenue
SELECT
	Product,
	SUM(Quantity * Unit_Price) AS TotalRevenue
FROM dbo.KeffiSalesTech
GROUP BY Product
ORDER BY TotalRevenue DESC;

--Which product category generate the most revenue
SELECT
	Category,
	SUM(Quantity * Unit_Price) AS TotalRevenue
FROM dbo.KeffiSalesTech
GROUP BY Category
ORDER BY TotalRevenue DESC;

--Which Country Generate Most Revenue
SELECT
	Country,
	SUM(Quantity * Unit_Price) AS TotalRevenue
FROM dbo.KeffiSalesTech
GROUP BY Country
ORDER BY TotalRevenue DESC;

--Overall Country Sales Performancee
SELECT
	COUNT(*) AS TotalTransaction,
	SUM(CAST(Quantity AS INT)) AS TotalUnitSold,
	SUM(CAST(Quantity AS INT) * Unit_Price) AS TotalRevenue,
	AVG(CAST(Quantity AS INT) * Unit_Price) AS AverageRevenue
FROM Dbo.KeffiSalesTech

--Total Transaction and Unit Sold
SELECT
	COUNT(*) AS TotalTransaction,
	SUM(CAST(Quantity AS INT)) AS TotalUnitSold
FROM Dbo.KeffiSalesTech

--Total and Average Revenue
SELECT 
	SUM(CAST(Quantity AS INT) * Unit_Price) AS TotalRevenue,
	AVG(CAST(Quantity AS INT) * Unit_Price) AS AverageRevenue
FROM dbo.KeffiSalesTech

--Monthly Sales Trend
SELECT
	YEAR(Sales_Date) AS SalesYear,
	MONTH(Sales_Date) AS SalesMonth,
	COUNT(*) AS TotalTransaction,
	SUM(CAST(Quantity AS INT)) AS TotalUnitSold,
	SUM(CAST(Quantity AS INT) * Unit_Price) AS TotalRevenue
FROM dbo.KeffiSalesTech
GROUP BY
	YEAR(Sales_Date),
	MONTH(Sales_Date)
ORDER BY 
	Salesyear,
	SalesMonth DESC;

--Best and Worst Performing Product
SELECT
	Product,
	SUM(CAST(Quantity AS INT)) AS UnitSold,
	SUM(CAST(Quantity AS INT) * Unit_Price) AS TotalRevenue
FROM dbo.KeffiSalesTech
GROUP BY Product
ORDER BY TotalRevenue DESC;

--Revenue Contribution by product category
WITH CategoryRevenue AS (
	SELECT 
		Category,
		SUM(CAST(Quantity AS INT) * Unit_Price) AS TotalRevenue
FROM dbo.KeffiSalesTech
GROUP BY Category)
SELECT 
	Category,
	TotalRevenue,
	CAST(
		TotalRevenue * 100.0/
		(SELECT SUM(TotalRevenue) FROM CategoryRevenue)
		AS DECIMAL(10,2)
		) AS RevenuePercentage
FROM CategoryRevenue
ORDER BY TotalRevenue DESC;

--Top 5 Customers by spending
SELECT TOP 5
	Customer_Name,
	SUM(CAST(Quantity AS INT) * Unit_Price) AS TotalSpending
FROM dbo.KeffiSalesTech
GROUP BY Customer_Name
ORDER BY TotalSpending DESC;

--Customer purchasing Frequency
SELECT
	Customer_Name,
	COUNT(*) AS NumberOfTransaction,
	SUM(CAST(Quantity AS INT)) AS TotalUnitPurchased,
	SUM(CAST(Quantity AS INT) * Unit_Price) AS TotalSpending
FROM Dbo.KeffiSalesTech
GROUP BY Customer_Name
ORDER BY NumberOfTransaction DESC;

--Confirming the issue.
SELECT
    Customer_Name,
    Gender,
    COUNT(*) AS NumberOfTransactions
FROM dbo.KeffiSalesTech
WHERE Customer_Name IN ('Samuel Obi','Hauwa Sule', 'Peter Osei')
GROUP BY Customer_Name, Gender
ORDER BY Customer_Name, Gender;

SELECT DISTINCT	
	Gender
FROM dbo.KeffiSalesTech;

SELECT 
	Customer_Name,
	COUNT(*) AS NumbersOfTransactions
FROM dbo.KeffiSalesTech
GROUP BY Customer_Name
HAVING COUNT (*) >1
ORDER BY NumbersOfTransactions DESC;

--Sales Performance by Country
SELECT
    Country,
    COUNT(*) AS TotalTransactions,
    SUM(CAST(Quantity AS INT)) AS UnitsSold,
    SUM(CAST(Quantity AS INT) * Unit_Price) AS TotalRevenue
FROM dbo.KeffiSalesTech
GROUP BY Country
ORDER BY TotalRevenue DESC;

--Gender Based Purchasing Pattern
SELECT
    Gender,
    COUNT(*) AS TotalTransactions,
    SUM(CAST(Quantity AS INT)) AS UnitsPurchased,
    SUM(CAST(Quantity AS INT) * Unit_Price) AS TotalRevenue,
    AVG(CAST(Quantity AS INT) * Unit_Price) AS AverageTransactionValue
FROM dbo.KeffiSalesTech
GROUP BY Gender
ORDER BY TotalRevenue DESC;

--Preferred Payment Method
SELECT
	Payment_Method,
	COUNT(*) AS NumberOfTransaction,
	SUM(CAST(Quantity AS INT) * Unit_Price) AS TotalRevenue
FROM dbo.KeffiSalesTech
GROUP BY Payment_method
ORDER BY NumberOfTransaction DESC;

--Highest value transaction
SELECT TOP 10
    Sales_ID,
    Customer_Name,
    Product,
    Quantity,
    Unit_Price,
    CAST(Quantity AS INT) * Unit_Price AS Revenue,
    Sales_Date
FROM dbo.KeffiSalesTech
ORDER BY Revenue DESC;

--Product Performing Above average
SELECT
    Product,
    SUM(CAST(Quantity AS INT) * Unit_Price) AS TotalRevenue
FROM dbo.KeffiSalesTech
GROUP BY Product
HAVING SUM(CAST(Quantity AS INT) * Unit_Price) >
       (
           SELECT AVG(ProductRevenue)
           FROM (
               SELECT
                   SUM(CAST(Quantity AS INT) * Unit_Price) AS ProductRevenue
               FROM dbo.KeffiSalesTech
               GROUP BY Product
           ) AS ProductSales
       )
ORDER BY TotalRevenue DESC;

--Confirming to Check missing values
SELECT 
	COUNT (*) AS RecordwithMissingValue
FROM dbo.KeffiSalesTech
WHERE Gender IS NULL
	OR Category IS NULL
	OR Product IS NULL
	OR Quantity IS NULL;

SELECT *
FROM dbo.KeffiSalesTech
WHERE Gender IS NULL
	OR Category IS NULL
	OR Product IS NULL
	OR Quantity IS NULL;
SELECT
    Product,
    LEN(Product) AS ProductLength,
    DATALENGTH(Product) AS ProductBytes,
    Category,
    LEN(Category) AS CategoryLength,
    DATALENGTH(Category) AS CategoryBytes
FROM dbo.KeffiSalesTech
WHERE NULLIF(TRIM(Product), '') IS NULL
   OR NULLIF(TRIM(Category), '') IS NULL;

SELECT
    Sales_ID,
    Customer_Name,
    Category,
    Product,
    Quantity,
    Unit_Price
FROM dbo.KeffiSalesTech
WHERE Product IS NULL
  AND Category IS NULL;

--Checking the Unit Price to know if i can infer 
SELECT
    Sales_ID,
    Product,
    Category,
    Unit_Price
FROM dbo.KeffiSalesTech
WHERE Unit_Price IN (70000, 12000, 28000, 150000)
ORDER BY Unit_Price, Product;

--Using Unit Price to Determine the product and category
UPDATE dbo.KeffiSalesTech
SET
    Product = CASE
        WHEN Sales_ID = 'S10655' THEN 'T-Shirt'
        WHEN Sales_ID = 'S11030' THEN 'Jeans'
        WHEN Sales_ID = 'S10244' THEN 'Jacket'
        WHEN Sales_ID = 'S11049' THEN 'Desk'
    END,
    Category = CASE
        WHEN Sales_ID IN ('S10655', 'S11030', 'S10244') THEN 'Clothing'
        WHEN Sales_ID = 'S11049' THEN 'Furniture'
    END
WHERE Sales_ID IN ('S10655', 'S11030', 'S10244', 'S11049');

--Displaying to confirm
SELECT
    Sales_ID,
    Customer_Name,
    Product,
    Category,
    Quantity,
    Unit_Price
FROM dbo.KeffiSalesTech
WHERE Sales_ID IN ('S10655', 'S11030', 'S10244', 'S11049');

--Confirming Null value Again
SELECT
    SUM(CASE WHEN NULLIF(TRIM(Sales_ID), '') IS NULL THEN 1 ELSE 0 END) AS MissingSalesID,
    SUM(CASE WHEN NULLIF(TRIM(Customer_Name), '') IS NULL THEN 1 ELSE 0 END) AS MissingCustomerName,
    SUM(CASE WHEN NULLIF(TRIM(Gender), '') IS NULL THEN 1 ELSE 0 END) AS MissingGender,
    SUM(CASE WHEN NULLIF(TRIM(Country), '') IS NULL THEN 1 ELSE 0 END) AS MissingCountry,
    SUM(CASE WHEN NULLIF(TRIM(Category), '') IS NULL THEN 1 ELSE 0 END) AS MissingCategory,
    SUM(CASE WHEN NULLIF(TRIM(Product), '') IS NULL THEN 1 ELSE 0 END) AS MissingProduct,
    SUM(CASE WHEN Quantity IS NULL THEN 1 ELSE 0 END) AS MissingQuantity,
    SUM(CASE WHEN Unit_Price IS NULL THEN 1 ELSE 0 END) AS MissingUnitPrice,
    SUM(CASE WHEN NULLIF(TRIM(Payment_Method), '') IS NULL THEN 1 ELSE 0 END) AS MissingPaymentMethod
FROM dbo.KeffiSalesTech;

--Customer generating above average
SELECT
    Customer_Name,
    SUM(CAST(Quantity AS INT) * Unit_Price) AS TotalRevenue
FROM dbo.KeffiSalesTech
GROUP BY Customer_Name
HAVING SUM(CAST(Quantity AS INT) * Unit_Price) >
       (
           SELECT AVG(CustomerRevenue)
           FROM (
               SELECT
                   SUM(CAST(Quantity AS INT) * Unit_Price) AS CustomerRevenue
               FROM dbo.KeffiSalesTech
               GROUP BY Customer_Name
           ) AS CustomerSales
       )
ORDER BY TotalRevenue DESC;

--Monthly revenue growth
WITH MonthlyRevenue AS (
    SELECT
        YEAR(Sales_Date) AS SalesYear,
        MONTH(Sales_Date) AS SalesMonth,
        SUM(CAST(Quantity AS INT) * Unit_Price) AS TotalRevenue
    FROM dbo.KeffiSalesTech
    GROUP BY
        YEAR(Sales_Date),
        MONTH(Sales_Date)
),
RevenueWithPrevious AS (
    SELECT
        SalesYear,
        SalesMonth,
        TotalRevenue,
        LAG(TotalRevenue) OVER (
            ORDER BY SalesYear, SalesMonth
        ) AS PreviousMonthRevenue
    FROM MonthlyRevenue
)
SELECT
    SalesYear,
    SalesMonth,
    TotalRevenue,
    PreviousMonthRevenue,
    ROUND(
        (TotalRevenue - PreviousMonthRevenue) * 100.0 /
        NULLIF(PreviousMonthRevenue, 0),
        2
    ) AS RevenueGrowthPercentage
FROM RevenueWithPrevious
ORDER BY SalesYear, SalesMonth;

--Rank Product According to Reveue
SELECT
    Product,
    SUM(CAST(Quantity AS INT) * Unit_Price) AS TotalRevenue,
    RANK() OVER (
        ORDER BY SUM(CAST(Quantity AS INT) * Unit_Price) DESC
    ) AS RevenueRank
FROM dbo.KeffiSalesTech
GROUP BY Product
ORDER BY RevenueRank;

--Rank customers according to spending
SELECT
    Customer_Name,
    SUM(CAST(Quantity AS INT) * Unit_Price) AS TotalSpending,
    RANK() OVER (
        ORDER BY SUM(CAST(Quantity AS INT) * Unit_Price) DESC
    ) AS SpendingRank
FROM dbo.KeffiSalesTech
GROUP BY Customer_Name
ORDER BY SpendingRank;

--Detect null and blank values
SELECT
    SUM(CASE WHEN NULLIF(TRIM(Sales_ID), '') IS NULL THEN 1 ELSE 0 END) AS MissingSalesID,
    SUM(CASE WHEN NULLIF(TRIM(Customer_Name), '') IS NULL THEN 1 ELSE 0 END) AS MissingCustomerName,
    SUM(CASE WHEN NULLIF(TRIM(Gender), '') IS NULL THEN 1 ELSE 0 END) AS MissingGender,
    SUM(CASE WHEN NULLIF(TRIM(Country), '') IS NULL THEN 1 ELSE 0 END) AS MissingCountry,
    SUM(CASE WHEN NULLIF(TRIM(Category), '') IS NULL THEN 1 ELSE 0 END) AS MissingCategory,
    SUM(CASE WHEN NULLIF(TRIM(Product), '') IS NULL THEN 1 ELSE 0 END) AS MissingProduct,
    SUM(CASE WHEN Quantity IS NULL THEN 1 ELSE 0 END) AS MissingQuantity,
    SUM(CASE WHEN Unit_Price IS NULL THEN 1 ELSE 0 END) AS MissingUnitPrice,
    SUM(CASE WHEN NULLIF(TRIM(Payment_Method), '') IS NULL THEN 1 ELSE 0 END) AS MissingPaymentMethod
FROM dbo.KeffiSalesTech;

--Investigate Possible duplicate
SELECT
    Sales_ID,
    COUNT(*) AS NumberOfRecords
FROM dbo.KeffiSalesTech
GROUP BY Sales_ID
HAVING COUNT(*) > 1;
