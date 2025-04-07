select*
from ecommerce_sales_analysis;

desc ecommerce_sales_analysis;

# REMOVING UNWANTED COLUMNS.
ALTER TABLE ecommerce_sales_analysis
DROP COLUMN `Sales Channel`,
DROP COLUMN `style`,
DROP COLUMN `SKU`,
DROP COLUMN `ASIN`,
DROP COLUMN `currency`;

# CHANGING COLUMNS NAMES ACCORDINGLY.
ALTER TABLE ecommerce_sales_analysis
CHANGE `Order ID` order_id TEXT,
CHANGE `ship-service-level` ship_service_level TEXT,
CHANGE `Courier Status` courier_status TEXT,
CHANGE `ship-city` ship_city TEXT,
CHANGE `ship-state` ship_state text;

ALTER TABLE ecommerce_sales_analysis
ADD COLUMN `Date_converted` DATE ;

# MODIFYING DATE COLUMN.
UPDATE ecommerce_sales_analysis
SET Date_converted = str_to_date(`date`,'%m-%d-%Y');

ALTER TABLE ecommerce_sales_analysis DROP COLUMN `Date`;
ALTER TABLE ecommerce_sales_analysis CHANGE Date_converted `Date` DATE ;

# TOTAL SALES AND REVENUE 
SELECT sum(amount) as total_revenue
from ecommerce_sales_analysis;

SELECT SUM(amount) AS total_revenue,
	   COUNT(distinct order_id) as total_orders
FROM ecommerce_sales_analysis;

# AVERAGE ORDER VALUE 
SELECT AVG(amount) as avg_order_value
FROM ecommerce_sales_analysis;

# MONTHLY SALES TRENDS
SELECT DATE_FORMAT(Date,'%Y-%m') AS month, SUM(amount) as total_sales
FROM ecommerce_sales_analysis
group by month
order by month;


#BEST SELLING PRODUCTS
SELECT category,sum(amount) as total_revenue
from ecommerce_sales_analysis
group by Category
order by total_revenue desc
limit 5;

# TOP 5 HIGHEST SPENDING CITIES
SELECT ship_city as customer_city, 
	   Sum(amount) as total_spent,
       count(distinct order_id) as total_orders
from ecommerce_sales_analysis
GROUP BY customer_city
ORDER BY total_spent desc 
limit 5;

#REGIONAL SALES ANALYSIS(TOP 10 STATES BY SALES)
SELECT ship_state as state,
       sum(amount) as total_sales
FROM ecommerce_sales_analysis
GROUP BY state
ORDER BY total_sales desc
limit 10;
		
# ORDER STATUS BREAKDOWN. 
SELECT `status`,count(order_id) as total_orders 
FROM ecommerce_sales_analysis
GROUP BY `status`
ORDER BY total_orders DESC;

#MOST SELLING SIZE
select size,count(*) as total_orders
from ecommerce_sales_analysis
group by size
order by total_orders desc
limit 5; 
