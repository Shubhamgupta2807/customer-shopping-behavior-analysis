-- -- ROUGH QUERIES------------------

select * from customer;
use customer_data_behaviour;
select * from customer limit 50
select gender, size, review_rating from customer;
select count(*) from customer;
select count(*) from customer
where review_rating >= 5;
select count(*) from customer
where gender = "male" and  review_rating >= 5;
select count(*) from customer
where gender = "female" and  review_rating >= 5;
select max(age) from customer;
select min(age) from customer;
select count(*) from customer
where age <= 18;

--------------------------------------------------------------

-- Q1- Total revenue genrated by male and female customers?
select gender, sum(purchase_amount) as revenue
from customer
group by gender


-- Q2-  which customer used a discount but still spent more than the average purchase amount?
select customer_id, purchase_amount
from customer
where discount_applied = "Yes" and purchase_amount >=  (select avg(purchase_amount) from customer)


-- Q3- which are the top 5 products with the highest average review rating
select item_purchased, round(avg(review_rating),3) as "average_product_rating"
from customer
group by item_purchased
order by avg(review_rating) desc
limit 5;


-- Q4- campare the average purchase amounts between standard and express shipping.
select shipping_type,
round(avg(purchase_amount),3)
from customer
where shipping_type in ("standard", "express")
group by shipping_type


-- Q5- do subscribed customers spend more? campare average spend and total spend and average revenue between subscriber and non subscriber.
select subscription_status,
count(customer_id) as total_customers,
round(avg(purchase_amount),2) as avg_spend,
round(sum(purchase_amount),3) as total_revenue
from customer
group by subscription_status
order by total_revenue, avg_spend desc;


-- Q6- which 5 products have the highest percentages of purchase with discount applied?
select item_purchased,
round(100 * sum(case when discount_applied = "Yes" then 1 else 0 end)/count(*), 2) as discount_rate
from customer
group by item_purchased
order by discount_rate desc
limit 5;


-- Q7- segment customer into new, returning, and loyal absed on their total nuber of 
previous purchase, and show count of each segment.
with customer_type as( 
select customer_id, previous_purchases,
case
	when previous_purchases = 1 then "New"
	when previous_purchases between 2 and 10 then "returning"
	else "loyal"
	end as customer_segment
from customer)

select customer_segment, count(*) as "number_of_customers"
from customer_type
group by customer_segment

-- Q8- what are the top 3 most purchase product within each category?
with item_counts as (
select category,
item_purchased,
count(customer_id) as total_orders,
row_number() over(partition by category order by count(customer_id) desc) as item_rank
from customer
group by category, item_purchased
)

select item_rank, category, item_purchased, total_orders
from item_counts
where item_rank <= 3;


-- Q9-are customer who are repeat buyers (more than 5 previous purchase) also likely to suscriber?
select subscription_status,
count(customer_id) as repeat_buyers
from customer
where previous_purchases > 5
group by subscription_status


-- Q10- what is the revenue contribution of each group?
select age_group,
sum(purchase_amount) as total_revenue
from customer
group by age_group
order by total_revenue desc;







