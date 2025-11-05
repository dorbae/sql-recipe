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
