/*
PROJECT: Retail Sales Forecasting and Volatility Analysis
AUTHOR: James Gifford
PURPOSE:
  - Generates the final dataset for Excel-based forecasting, volatility, and scenario modeling.
  - Calculates month-over-month (MoM) and year-over-year (YoY) percent changes 
    for Total Retail & Food Service, Clothing & Accessories, Department Stores, and Food Service categories.
  - Includes year/month fields for aggregation and pivoting.

NOTES:
  - Source: U.S. Census Bureau Monthly Retail Trade Survey (MRTS), accessed via FRED.
  - All sales figures are seasonally adjusted and expressed in millions of USD.
  - NULLIF guards prevent divide-by-zero errors in percentage calculations.
*/


SELECT 
  observation_date,
  EXTRACT(YEAR FROM observation_date) AS year,
  EXTRACT(MONTH FROM observation_date) AS month,

  -- TOTAL RETAIL & FOOD SERVICE
  total_retail_and_food_service_sales,
  ((total_retail_and_food_service_sales - LAG(total_retail_and_food_service_sales) OVER (ORDER BY observation_date))::NUMERIC
  / NULLIF(LAG(total_retail_and_food_service_sales) OVER (ORDER BY observation_date), 0)::NUMERIC) * 100 AS total_retail_mom_pct_change,
  ((total_retail_and_food_service_sales - LAG(total_retail_and_food_service_sales, 12) OVER (ORDER BY observation_date))::NUMERIC
  / NULLIF(LAG(total_retail_and_food_service_sales, 12) OVER (ORDER BY observation_date), 0)::NUMERIC) * 100 AS total_retail_yoy_pct_change,

  -- CLOTHING & ACCESSORIES
  clothing_and_accessories_sales,
  ((clothing_and_accessories_sales - LAG(clothing_and_accessories_sales) OVER (ORDER BY observation_date))::NUMERIC
  / NULLIF(LAG(clothing_and_accessories_sales) OVER (ORDER BY observation_date), 0)::NUMERIC) * 100 AS clothing_mom_pct_change,
  ((clothing_and_accessories_sales - LAG(clothing_and_accessories_sales, 12) OVER (ORDER BY observation_date))::NUMERIC
  / NULLIF(LAG(clothing_and_accessories_sales, 12) OVER (ORDER BY observation_date), 0)::NUMERIC) * 100 AS clothing_yoy_pct_change,

  -- DEPARTMENT STORES
  department_store_sales,
  ((department_store_sales - LAG(department_store_sales) OVER (ORDER BY observation_date))::NUMERIC
  / NULLIF(LAG(department_store_sales) OVER (ORDER BY observation_date), 0)::NUMERIC) * 100 AS dept_store_mom_pct_change,
  ((department_store_sales - LAG(department_store_sales, 12) OVER (ORDER BY observation_date))::NUMERIC
  / NULLIF(LAG(department_store_sales, 12) OVER (ORDER BY observation_date), 0)::NUMERIC) * 100 AS dept_store_yoy_pct_change,

  -- FOOD SERVICE
  food_service_sales,
  ((food_service_sales - LAG(food_service_sales) OVER (ORDER BY observation_date))::NUMERIC
  / NULLIF(LAG(food_service_sales) OVER (ORDER BY observation_date), 0)::NUMERIC) * 100 AS food_service_mom_pct_change,
  ((food_service_sales - LAG(food_service_sales, 12) OVER (ORDER BY observation_date))::NUMERIC
  / NULLIF(LAG(food_service_sales, 12) OVER (ORDER BY observation_date), 0)::NUMERIC) * 100 AS food_service_yoy_pct_change

FROM combined_retail_sales
ORDER BY observation_date ASC;

