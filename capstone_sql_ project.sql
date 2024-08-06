#SQL - Capstone Project

#Data Wrangling

#Build a database
create database amazon;
use amazon;


# 2.Feature Engineering:

# 2.1 Add a new column named timeofday to give insight of sales in the Morning, Afternoon and Evening. 
#This will help answer the question on which part of the day most sales are made.

alter table amazon
add column timeofday varchar(10);

update amazon
set timeofday = case
when hour(time) >= 5 and hour(time) <= 12 then 'Morning' 
when hour(time) >= 12 and hour(time) <= 17 then 'Afternoon' 
else 'Evening'
end;

set sql_safe_updates = 0;

# 2.2 Add a new column named dayname that contains the extracted days of the week on which the given transaction took place (Mon, Tue, Wed, Thur, Fri). 
#This will help answer the question on which week of the day each branch is busiest.

alter table amazon 
add column dayname varchar(20);

update amazon 
set dayname = dayname(date) ;

# 2.3 Add a new column named monthname that contains the extracted months of the year on which the given transaction took place (Jan, Feb, Mar).
# Help determine which month of the year has the most sales and profit.

alter table amazon
add column monthname varchar(20);

update amazon
set monthname = monthname(date);

#EDA

#1.What is the count of distinct cities in the dataset

select count(distinct city)
from amazon;


#2.For each branch, what is the corresponding city?

SELECT distinct branch, city
FROM amazon;

#3.What is the count of distinct product lines in the dataset? 

SELECT DISTINCT gender
FROM amazon;


#4.Which payment method occurs most frequently?

select payment, count(payment) as frequency
from amazon
group by payment
order by frequency desc;

#5.Which product line has the highest sales?

select `product line`, count(`product line`) as frequency
from amazon 
group by `product line`
order by frequency desc
limit 1;

#6.How much revenue is generated each month?

SELECT monthname, SUM(total) AS revenue
FROM amazon
group by monthname ;

#7.In which month did the cost of goods sold reach its peak?
SELECT monthname, SUM(cogs) AS total_cogs
FROM amazon
GROUP BY monthname
ORDER BY total_cogs DESC
LIMIT 1;

#8.Which product line generated the highest revenue?

select `product line`, sum(total) as revenue
from amazon 
group by `product line`
order by revenue
limit 1;

#9. In which city was the highest revenue recorded?

select city, sum(total) as reveneu
from amazon 
group by city
order by reveneu desc
limit 1;

#10.Which product line incurred the highest Value Added Tax?

SELECT `product line`, SUM(`Tax 5%`) AS TotalVAT
FROM amazon
GROUP BY `product line`
ORDER BY TotalVAT DESC
LIMIT 1;

#11.For each product line, add a column indicating "Good" if its sales are above average, otherwise "Bad."

SELECT 
    `product line`,
    CASE 
        WHEN SUM(quantity) > (SELECT AVG(quantity) FROM amazon) THEN 'Good' 
        ELSE 'Bad' 
    END AS sales_status
FROM 
    amazon
GROUP BY 
    `product line`;


#12.Identify the branch that exceeded the average number of products sold.

SELECT Branch
FROM amazon
GROUP BY Branch
HAVING COUNT(*) > (SELECT AVG(TotalProductsSold) FROM (SELECT COUNT(*) AS TotalProductsSold FROM amazon GROUP BY Branch) AS Subquery);



#13.Which product line is most frequently associated with each gender?

SELECT `product line`, gender
FROM (
    SELECT `product line`, gender, COUNT(*) AS frequency,
           ROW_NUMBER() OVER(PARTITION BY gender ORDER BY COUNT(*) DESC) AS rank1
    FROM amazon
    GROUP BY `product line`, gender
) AS ranked
WHERE rank1 = 1;


#14.Calculate the average rating for each product line.

select avg(rating)
from amazon
group by `product line`;


#15.Count the sales occurrences for each time of day on every weekday.

SELECT DAYNAME(date) AS weekday,
       TIME(date) AS time_of_day,
       COUNT(*) AS sales_occurrences
FROM amazon
GROUP BY DAYNAME(date), TIME(date);


#16.Identify the customer type contributing the highest revenue

select `customer type`, sum(total) as revenue
from amazon
group by `customer type`
order by revenue desc
limit 1;

#17.Determine the city with the highest VAT percentage.

SELECT 
    city,
    SUM(`Tax 5%`) AS total_vat,
    SUM(total) AS total_sales,
    SUM(`Tax 5%`) / SUM(total) * 100 AS vat_percentage
FROM 
    amazon
GROUP BY 
    city
ORDER BY 
    vat_percentage DESC
LIMIT 1;


#18.Identify the customer type with the highest VAT payments.

select `customer type`, sum(`Tax 5%`) as total
from amazon 
group by `customer type`
order by total desc
limit 1;

#19.What is the count of distinct customer types in the dataset?

select count(distinct `customer type`)
from amazon;


#20.What is the count of distinct payment methods in the dataset?

select count(distinct payment)
from amazon;

#21.which customer type occurs most frequently?

select `customer type`, count(`customer type`)
from amazon 
group by `customer type`
order by count(`customer type`) desc
limit 1;

#22.Identify the customer type with the highest purchase frequency.
SELECT `customer type`, COUNT(*) AS purchase_frequency
FROM amazon
GROUP BY `customer type`
ORDER BY purchase_frequency DESC
LIMIT 1;


#23.Determine the predominant gender among customers.

SELECT gender, COUNT(*) AS gender_count
FROM amazon
GROUP BY gender
ORDER BY gender_count DESC
LIMIT 1;

#24.Examine the distribution of genders within each branch.

SELECT branch, gender, COUNT(*) AS gender_count
FROM amazon
GROUP BY branch, gender
ORDER BY branch, gender;

#25.Identify the time of day when customers provide the most ratings

select time, count(rating)
from amazon
group by time
order by count(rating) desc
limit 1;

#26.Determine the time of day with the highest customer ratings for each branch.
SELECT branch, TIME(date) AS time_of_day, COUNT(*) AS rating_count
FROM amazon
GROUP BY branch, TIME(date)
ORDER BY branch, rating_count DESC;

#27.Identify the day of the week with the highest average ratings.

SELECT DAYNAME(date) AS day_of_week, AVG(rating) AS average_rating
FROM amazon
GROUP BY DAYNAME(date)
ORDER BY average_rating DESC
LIMIT 1;

#28.Determine the day of the week with the highest average ratings for each branch.

SELECT branch, DAYNAME(date) AS day_of_week, AVG(rating) AS average_rating
FROM amazon
GROUP BY branch, DAYNAME(date)
ORDER BY branch, average_rating DESC;




