#For each branch, what is the corresponding city?

SELECT distinct branch, city
FROM amazon;


#Which payment method occurs most frequently?

select payment, count(payment) as frequency
from amazon
group by payment
order by frequency desc;

#How much revenue is generated each month?

SELECT SUM(quantity * unit_price) AS revenue
FROM amazon;

#In which month did the cost of goods sold reach its peak?
SELECT monthname, SUM(cogs) AS total_cogs
FROM amazon
GROUP BY monthname
ORDER BY total_cogs DESC
LIMIT 1;

#Which product line generated the highest revenue?

select product_line, sum(quntity * unit_price) as revenue
from amazon 
group by product_line;

#Identify the branch that exceeded the average number of products sold.

SELECT branch, SUM(quantity)
FROM amazon
GROUP BY branch
HAVING SUM(quantity) > (SELECT AVG(quantity) FROM amazon);


#Which product line is most frequently associated with each gender?

select product_line, gender
from amazon 
group by product_line;

#Calculate the average rating for each product line.

select avg(rating)
from amazon
group by product_line;


#Count the sales occurrences for each time of day on every weekday.
SELECT DAYNAME(date) AS weekday,
       TIME(date) AS time_of_day,
       COUNT(*) AS sales_occurrences
FROM amazon
GROUP BY DAYNAME(date), TIME(date);


#Identify the customer type contributing the highest revenue

select customer_type, sum(quantity*unit_price) as revenue
from amazon
group by customer_type
order by revenue desc
limit 1;

#Determine the city with the highest VAT percentage.
SELECT city, AVG(VAT / total) * 100 AS average_vat_percentage
FROM amazon
GROUP BY city
ORDER BY average_vat_percentage DESC
LIMIT 1;


#What is the count of distinct customer types in the dataset?

select count(distinct customer_type)
from amazon;


#What is the count of distinct payment methods in the dataset?

select count(distinct payment)
from amazon;

#Which customer type occurs most frequently?

select customer_type, count(customer_type)
from amazon 
group by customer_type
order by count(customer_type) desc
limit 1;

#Identify the customer type with the highest purchase frequency.
SELECT customer_type, COUNT(*) AS purchase_frequency
FROM amazon
GROUP BY customer_type
ORDER BY purchase_frequency DESC
LIMIT 1;


#Determine the predominant gender among customers.

SELECT gender, COUNT(*) AS gender_count
FROM amazon
GROUP BY gender
ORDER BY gender_count DESC
LIMIT 1;

#Examine the distribution of genders within each branch.

SELECT branch, gender, COUNT(*) AS gender_count
FROM amazon
GROUP BY branch, gender
ORDER BY branch, gender;

#Identify the time of day when customers provide the most ratings

select time, count(rating)
from amazon
group by time
order by count(rating) desc
limit 1;

#Determine the time of day with the highest customer ratings for each branch.
SELECT branch, TIME(date) AS time_of_day, COUNT(*) AS rating_count
FROM amazon
GROUP BY branch, TIME(date)
ORDER BY branch, rating_count DESC;

#Identify the day of the week with the highest average ratings.

SELECT DAYNAME(date) AS day_of_week, AVG(rating) AS average_rating
FROM amazon
GROUP BY DAYNAME(date)
ORDER BY average_rating DESC
LIMIT 1;

#Determine the day of the week with the highest average ratings for each branch.

SELECT branch, DAYNAME(date) AS day_of_week, AVG(rating) AS average_rating
FROM amazon
GROUP BY branch, DAYNAME(date)
ORDER BY branch, average_rating DESC;
