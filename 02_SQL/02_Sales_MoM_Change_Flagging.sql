/*
PROJECT: Retail Sales Month-over-Month Change Flagging
AUTHOR: James Gifford
DESCRIPTION:
These queries identify months with significant month-over-month changes (greater than ±5%) in sales across 
different retail categories using seasonally adjusted sales data. 

CONTEXT:
 - Large percentage changes reflect key market events, including the early COVID-19 impact (Mar-Apr 2020 shutdown)
  and subsequent economic reopening (May-Jun 2020).
 - Identifying these spikes/drops supports operational decision-making such as inventory planning and marketing.
 - Each query targets a specific sales category for granular insights.

 - Note: All sales figures in this analysis are expressed in millions of dollars.

 - These results confirmed the presence of extreme volatility in 2020,
 - supporting the decision to construct COVID-smoothed series before forecasting.
*/

----------

-- TOTAL RETAIL AND FOOD SERVICES SALES
WITH sales_pct_change AS (
    SELECT
        observation_date,
        total_retail_and_food_service_sales,
        100.0 * (total_retail_and_food_service_sales - 
                  LAG(total_retail_and_food_service_sales) OVER (ORDER BY observation_date))
          / NULLIF(LAG(total_retail_and_food_service_sales) OVER (ORDER BY observation_date), 0) AS pct_change
    FROM
        combined_retail_sales
)
SELECT
    observation_date,
    total_retail_and_food_service_sales,
    pct_change
FROM
    sales_pct_change
WHERE
    ABS(pct_change) > 5;

/* 
RESULTS: Outlier months with MoM percent changes > |5%| in Total Retail and Food Service Sales:

| observation_date | total_retail_and_food_service_sales | pct_change            |
|------------------|-------------------------------------|-----------------------|
| 2001-10-01       | 288,632                             |  7.44                 |
| 2020-03-01       | 468,324                             | -9.12                 |
| 2020-04-01       | 401,028                             | -14.37                |
| 2020-05-01       | 478,449                             | 19.31                 |
| 2020-06-01       | 518,038                             |  8.27                 |
| 2021-03-01       | 603,581                             | 10.77                 |
*/

----------

-- CLOTHING AND ACCESSORIES SALES
WITH clothing_sales_pct_change AS (
    SELECT
        observation_date,
        clothing_and_accessories_sales,
        100.0 * (clothing_and_accessories_sales - 
                  LAG(clothing_and_accessories_sales) OVER (ORDER BY observation_date))
          / NULLIF(LAG(clothing_and_accessories_sales) OVER (ORDER BY observation_date), 0) AS pct_change
    FROM
        combined_retail_sales
)
SELECT
    observation_date,
    clothing_and_accessories_sales,
    pct_change
FROM
    clothing_sales_pct_change
WHERE
    ABS(pct_change) > 5;

/*
RESULTS: Outlier months with MoM percent changes > |5%| in Clothing and Accessories Sales

| observation_date | clothing_and_accessories_sales | pct_change           |
|------------------|-------------------------------|----------------------|
| 1997-04-01       | 10,715                        |  -5.84               |
| 2001-09-01       | 12,992                        |  -6.62               |
| 2008-09-01       | 17,119                        |  -5.53               |
| 2009-03-01       | 16,043                        |  -5.61               |
| 2020-03-01       | 11,074                        | -49.75               |
| 2020-04-01       |  2,733                        | -75.32               |
| 2020-05-01       |  8,051                        | 194.58               |
| 2020-06-01       | 16,725                        | 107.74               |
| 2020-09-01       | 20,047                        |  13.31               |
| 2021-03-01       | 23,506                        |  22.72               |
*/

----------

-- DEPARTMENT STORE SALES
WITH department_sales_pct_change AS (
    SELECT
        observation_date,
        department_store_sales,
        100.0 * (department_store_sales - 
                  LAG(department_store_sales) OVER (ORDER BY observation_date))
          / NULLIF(LAG(department_store_sales) OVER (ORDER BY observation_date), 0) AS pct_change
    FROM combined_retail_sales
)
SELECT observation_date, department_store_sales, pct_change
FROM department_sales_pct_change
WHERE ABS(pct_change) > 5;

/*
RESULTS: Outlier months with MoM percent changes > |5%| in Department Store Sales

| observation_date | department_store_sales | pct_change           |
|------------------|-----------------------|----------------------|
| 2000-01-01       | 34,913                |  -5.75               |
| 2020-03-01       | 81,129                |  26.42               |
| 2020-04-01       | 70,473                | -13.13               |
*/

----------

-- FOOD SERVICE SALES
WITH food_service_pct_change AS (
    SELECT
        observation_date,
        food_service_sales,
        100.0 * (food_service_sales - 
                  LAG(food_service_sales) OVER (ORDER BY observation_date))
          / NULLIF(LAG(food_service_sales) OVER (ORDER BY observation_date), 0) AS pct_change
    FROM combined_retail_sales
)
SELECT observation_date, food_service_sales, pct_change
FROM food_service_pct_change
WHERE ABS(pct_change) > 5;

/*
RESULTS: Outlier months with MoM percent changes > |5%| in Food Service Sales

| observation_date | food_service_sales | pct_change           |
|------------------|-------------------|----------------------|
| 2006-01-01       |  9,243            |   5.30               |
| 2009-01-01       |  8,743            |   6.48               |
| 2009-03-01       |  7,982            |  -8.51               |
| 2020-03-01       |  5,915            | -18.02               |
| 2020-04-01       |  3,297            | -44.26               |
| 2020-05-01       |  4,065            |  23.29               |
| 2020-06-01       |  5,731            |  40.98               |
| 2020-07-01       |  6,529            |  13.92               |
| 2020-10-01       |  6,870            |   6.50               |
| 2021-01-01       |  7,143            |  13.11               |
| 2021-03-01       |  8,059            |  17.32               |
| 2021-10-01       |  8,195            |   6.08               |
| 2021-11-01       |  7,309            | -10.81               |
| 2022-03-01       |  8,118            |   8.72               |
| 2022-05-01       |  7,881            |  -5.23               |
| 2022-11-01       |  7,044            |  -7.79               |
| 2023-01-01       |  7,876            |  14.31               |
| 2024-01-01       |  7,714            |   8.10               |
*/
