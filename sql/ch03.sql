/**
 * 5.1. code to label 
 */

-- DROP TABLE IF EXISTS mst_users;
CREATE TABLE mst_users(
    user_id         varchar(255)
  , register_date   varchar(255)
  , register_device integer
);

INSERT INTO mst_users
VALUES
    ('U001', '2016-08-26', 1)
  , ('U002', '2016-08-26', 2)
  , ('U003', '2016-08-27', 3)
;

SELECT user_id
     , CASE
     	 WHEN register_device = 1 THEN 'desktop'
     	 WHEN register_device = 2 THEN 'smartphone'
     	 WHEN register_device = 3 THEN 'application'
     	 ELSE 'etc'
       END AS device_name
  from mst_users
;
     

/**
 * 5.2. extract domain
 **/

-- DROP TABLE IF EXISTS access_log ;
CREATE TABLE access_log (
    stamp    varchar(255)
  , referrer text
  , url      text
);

INSERT INTO access_log 
VALUES
    ('2016-08-26 12:02:00', 'http://www.other.com/path1/index.php?k1=v1&k2=v2#Ref1', 'http://www.example.com/video/detail?id=001')
  , ('2016-08-26 12:02:01', 'http://www.other.net/path1/index.php?k1=v1&k2=v2#Ref1', 'http://www.example.com/video#ref'          )
  , ('2016-08-26 12:02:01', 'https://www.other.com/'                               , 'http://www.example.com/book/detail?id=002' )
;

SELECT stamp
     , substring(referrer from 'https?://([^/]*)') AS referrer_host
  FROM access_log
;


/**
 * 5.3. extract path and query parameters in URL
 **/

SELECT stamp
     , url
     , substring(url from '//[^/]+([^?#]+)') AS path
     , substring(url from 'id=([^&]*)') AS id
  FROM access_log
;


/**
 * 5.4. slice URL
 **/

SELECT stamp
     , url
     , substring(url from '//[^/]+([^?#]+)') AS path
     , split_part(substring(url from '//[^/]+([^?#]+)'), '/', 2) AS path1
     , split_part(substring(url from '//[^/]+([^?#]+)'), '/', 3) AS path2
  FROM access_log
;

/**
 * 5.5. extract current date and time
 **/

SELECT CURRENT_DATE as dt
     , CURRENT_TIMESTAMP as ts_with_timezone
     , LOCALTIMESTAMP as ts_without_timezone
;


/**
 * 5.6. convert text into date, timestamp type
 **/

SELECT CAST('2025-01-01' AS date) AS dt
     , CAST('2025-01-01 12:00:00' AS timestamp) AS ts
     , date '2025-01-01' AS dtt
     , timestamp '2025-01-01 12:00:00' AS tss
;


/**
 * 5.7. extract year, month, day
 */

SELECT stamp
     , EXTRACT(YEAR FROM stamp) AS year
     , EXTRACT(MONTH FROM stamp) AS month
     , EXTRACT(DAY FROM stamp) AS day
     , EXTRACT(HOUR FROM stamp) AS hour
  FROM (
    SELECT CAST('2025-01-01 13:00' AS timestamp) AS stamp
  )
;


/**
 * 5.8. extract time unit
 */

SELECT stamp
     , SUBSTR(stamp, 1, 4)  as year
     , SUBSTR(stamp, 6, 2)  as month
     , SUBSTR(stamp, 9, 2)  as day
     , SUBSTR(stamp, 12, 2) as month
   FROM (
     SELECT CAST('2025-04-20 12:00:00'AS text) AS stamp
   ) AS t
 ;


/**
 * 5.9. conpensate
 */

--DROP TABLE IF EXISTS purchase_log_with_coupon;
CREATE TABLE purchase_log_with_coupon (
    purchase_id varchar(255)
  , amount      integer
  , coupon      integer
);

INSERT INTO purchase_log_with_coupon
VALUES
    ('10001', 3280, NULL)
  , ('10002', 4650,  500)
  , ('10003', 3870, NULL)

  

 SELECT purchase_id
      , amount
      , coupon
      , amount - coupon AS discount_amount
      , amount - COALESCE(coupon, 0) as discount_amount2
   FROM purchase_log_with_coupon
;

/**
 * 6.1. concat string
 */
--DROP TABLE IF EXISTS mst_user_location;
CREATE TABLE mst_user_location (
    user_id   varchar(255)
  , pref_name varchar(255)
  , city_name varchar(255)
);

INSERT INTO mst_user_location
VALUES
    ('U001', '서울특별시', '강서구')
  , ('U002', '경기도수원시', '장안구'  )
  , ('U003', '제주특별자치도', '서귀포시')
;

SELECT user_id
     , CONCAT(pref_name, ' ', city_name) AS city1
     , pref_name || ' ' || city_name AS city2
  FROM mst_user_location
;

/**
 * 6.2. compare columns
 */
--DROP TABLE IF EXISTS quarterly_sales;
CREATE TABLE quarterly_sales (
    year integer
  , q1   integer
  , q2   integer
  , q3   integer
  , q4   integer
);

INSERT INTO quarterly_sales
VALUES
    (2015, 82000, 83000, 78000, 83000)
  , (2016, 85000, 85000, 80000, 81000)
  , (2017, 92000, 81000, NULL , NULL )
;

SELECT year
     , q1
     , q2
     , CASE
	     WHEN q1 < q2 THEN '+'
	     WHEN q1 = q2 THEN ' '
         ELSE '-'
       END AS judge_q1_q2
     , q2 - q1 AS diff_q1_q2
     , SIGN(q2 - q1) AS sign_q2_q1
  FROM quarterly_sales
 ORDER BY year
;

/**
 * 6.3. greatest/least
 */
SELECT year
     , greatest(q1, q2, q3, q4) AS greatest_sales
     , least(q1, q2, q3, q4) AS least_sales
  FROM quarterly_sales
 ORDER BY year
;

/**
 * 6.4. average
 */
SELECT year
     , (COALESCE(q1, 0) + COALESCE(q2, 0) + COALESCE(q3, 0) + COALESCE(q4, 0)) / 
     (SIGN(COALESCE(q1, 0)) + SIGN(COALESCE(q2, 0)) + SIGN(COALESCE(q3, 0)) + SIGN(COALESCE(q4, 0)))
     AS average
  FROM quarterly_sales
 ORDER BY year
;

/**
 * 6.7. divide integers
 */
--DROP TABLE IF EXISTS advertising_stats;
CREATE TABLE advertising_stats (
    dt          varchar(255)
  , ad_id       varchar(255)
  , impressions integer
  , clicks      integer
);

INSERT INTO advertising_stats
VALUES
    ('2017-04-01', '001', 100000,  3000)
  , ('2017-04-01', '002', 120000,  1200)
  , ('2017-04-01', '003', 500000, 10000)
  , ('2017-04-02', '001',      0,     0)
  , ('2017-04-02', '002', 130000,  1400)
  , ('2017-04-02', '003', 620000, 15000)
;

SELECT dt
     , ad_id
     , CAST(clicks AS double precision) / CAST(impressions AS double precision) AS ctr
     , 100.0 * CAST(clicks AS double precision) / CAST(impressions AS double precision) as ctr_as_percentage 
  FROM advertising_stats
 WHERE dt = '2017-04-01'
 ORDER BY dt, ad_id
;

/**
 * 6.8. avoid dividing zero
 */
SELECT dt
     , ad_id
     , CASE
     	WHEN impressions > 0 THEN 100.0 * CAST(clicks AS double precision) / CAST(impressions AS double precision)
       END AS ctr_by_case
     , 100.0 * CAST(clicks AS double precision) / CAST(NULLIF(impressions, 0) AS double precision) AS ctr_by_nullif
  FROM advertising_stats
 ORDER BY dt, ad_id
;

/*
 * 6.9. calculate the distance in 1-dim
 */

--DROP TABLE IF EXISTS location_1d;
CREATE TABLE location_1d (
    x1 integer
  , x2 integer
);

INSERT INTO location_1d
VALUES
    ( 5 , 10)
  , (10 ,  5)
  , (-2 ,  4)
  , ( 3 ,  3)
  , ( 0 ,  1)
;

--DROP TABLE IF EXISTS location_2d;
CREATE TABLE location_2d (
    x1 integer
  , y1 integer
  , x2 integer
  , y2 integer
);

INSERT INTO location_2d
VALUES
    (0, 0, 2, 2)
  , (3, 5, 1, 2)
  , (5, 3, 2, 1)
;

SELECT ABS(x2 - x1) AS abs
     , SQRT(POWER(x2 - x1, 2)) AS sqrt
  FROM location_1d
;

/**
 * 6.10. calculate the distance in 2-dim
 */
SELECT SQRT(POWER(x2 - x1, 2) + POWER(y2 - y1, 2)) AS distance
     -- utilze point data type in PostgreSQL
     , POINT(x1, y1) <-> POINT(x2, y2) AS distance_by_points
  FROM location_2d
;


/**
 * 6.11. handle date/time
 */
--DROP TABLE IF EXISTS mst_users_with_dates;
CREATE TABLE mst_users_with_dates (
    user_id        varchar(255)
  , register_stamp varchar(255)
  , birth_date     varchar(255)
);

INSERT INTO mst_users_with_dates
VALUES
    ('U001', '2016-02-28 10:00:00', '2000-02-29')
  , ('U002', '2016-02-29 10:00:00', '2000-02-29')
  , ('U003', '2016-03-01 10:00:00', '2000-02-29')
;

SELECT user_id
     , register_stamp::timestamp AS resister_ts
     , register_stamp::timestamp + '1 hour'::interval AS after_1h
     , register_stamp::timestamp - '30 minutes'::interval AS before_30m
     , register_stamp::date AS resister_dt
     , (register_stamp::date + '1 day'::interval)::date AS after_1h
     , (register_stamp::date - '1 month'::interval)::date AS before_30m
  FROM mst_users_with_dates
;


/**
 * 6.12. difference between two date values
 */
SELECT user_id
     , CURRENT_DATE AS today
     , register_stamp::date AS register_dt
     , CURRENT_DATE - register_stamp::date AS diff_days
  FROM mst_users_with_dates
;

SELECT user_id
     , CURRENT_DATE AS today
     , register_stamp::date AS register_date
     , birth_date::date AS birth_date
     , EXTRACT(YEAR FROM age(register_stamp::date, birth_date::date)) AS register_age
  FROM mst_users_with_dates
;


/**
 * 6.16. calculate the gap btw two date values which are string
 */
SELECT user_id
     , SUBSTRING(register_stamp, 1, 10) AS register_date
     , birth_date
     , FLOOR(
         (CAST(REPLACE(SUBSTRING(register_stamp, 1, 10), '-', '') AS integer) -
         CAST(REPLACE(birth_date, '-', '') AS integer)) / 10000
     ) AS register_age
     , FLOOR(
         (CAST(REPLACE(CAST(CURRENT_DATE AS text), '-', '') AS integer) -
         CAST(REPLACE(birth_date, '-', '') AS integer)) / 10000
     ) AS current_age
  FROM mst_users_with_dates 
;


/**
 * 6.17. handle IP by inet data type
 */
SELECT CAST('127.0.0.1' AS inet) < CAST('127.0.0.2' AS inet) AS lt
     , CAST('127.0.0.1' AS inet) > CAST('127.0.0.2' AS inet) AS gt
;

/**
 * 6.18. check whether IP is contained in IP range
 */
SELECT CAST('127.0.0.1' AS inet) << CAST('127.0.0.0/8' AS inet) AS is_conatained
;

/**
 * 6.19. extract decimal from inet data
 */
SELECT ip
     , CAST(split_part(ip, '.', 1) AS integer) AS ip_class_a
     , CAST(split_part(ip, '.', 2) AS integer) AS ip_class_b
     , CAST(split_part(ip, '.', 3) AS integer) AS ip_class_c
     , CAST(split_part(ip, '.', 4) AS integer) AS ip_class_d
  FROM
    (SELECT CAST('192.168.0.1' AS text) AS ip) AS t
    
    
/**
 * 6.20. extract hex, oct from ip data
 */
SELECT ip
     , CAST(split_part(ip, '.', 1) AS integer) * 2^24 AS ip_class_a
     , CAST(split_part(ip, '.', 2) AS integer) * 2^16 AS ip_class_b
     , CAST(split_part(ip, '.', 3) AS integer) * 2^8  AS ip_class_c
     , CAST(split_part(ip, '.', 4) AS integer) * 2^0  AS ip_class_d
  FROM
    (SELECT CAST('192.168.0.1' AS text) AS ip) AS t
;

/**
 * 3.20. pad 0 
 */
SELECT ip
     , LPAD(SPLIT_PART(ip, '.', 1), 3, '0') AS ip_class_a
     , LPAD(SPLIT_PART(ip, '.', 2), 3, '0') AS ip_class_b
     , LPAD(SPLIT_PART(ip, '.', 3), 3, '0') AS ip_class_c
     , LPAD(SPLIT_PART(ip, '.', 4), 3, '0') AS ip_class_d
  FROM
    (SELECT CAST('192.168.0.1' AS text) AS ip) AS t
;