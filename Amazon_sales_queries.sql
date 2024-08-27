use `garden category data from amazon`;

SELECT * FROM sample_longlist_data;

SET SQL_SAFE_UPDATES = 0;

ALTER TABLE sample_longlist_data
ADD COLUMN ProductCount INT;

UPDATE sample_longlist_data
SET ProductCount = CASE 
    WHEN sellerproductcount LIKE '%of over%' THEN
        CASE 
            WHEN REPLACE(SUBSTRING(
                sellerproductcount, 
                LOCATE('over ', sellerproductcount) + 5, 
                LOCATE(' results', sellerproductcount) - (LOCATE('over ', sellerproductcount) + 5)
            ), ',', '') = '' THEN NULL
            ELSE CAST(REPLACE(SUBSTRING(
                sellerproductcount, 
                LOCATE('over ', sellerproductcount) + 5, 
                LOCATE(' results', sellerproductcount) - (LOCATE('over ', sellerproductcount) + 5)
            ), ',', '') AS UNSIGNED)
        END
    ELSE
        CASE 
            WHEN REPLACE(SUBSTRING(
                sellerproductcount, 
                LOCATE('of ', sellerproductcount) + 3, 
                LOCATE(' results', sellerproductcount) - (LOCATE('of ', sellerproductcount) + 3)
            ), ',', '') = '' THEN NULL
            ELSE CAST(REPLACE(SUBSTRING(
                sellerproductcount, 
                LOCATE('of ', sellerproductcount) + 3, 
                LOCATE(' results', sellerproductcount) - (LOCATE('of ', sellerproductcount) + 3)
            ), ',', '') AS UNSIGNED)
        END
END;

ALTER TABLE sample_longlist_data
ADD COLUMN PositiveRatingPercentage INT;

UPDATE sample_longlist_data
SET PositiveRatingPercentage = CASE 
    WHEN LOCATE('%', sellerratings) > 1 THEN
        CAST(SUBSTRING(
            sellerratings,
            1,
            LOCATE('%', sellerratings) - 1
        ) AS UNSIGNED)
    ELSE
        NULL
END;

ALTER TABLE sample_longlist_data
ADD COLUMN EmailAddress VARCHAR(255);

SELECT 
    sellerdetails,
    regexp_matches(sellerdetails, '([a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,})', 'g') AS extracted_emails
FROM 
    sample_longlist_data;
    
select sellerlink from (SELECT 
	sellerlink,
    sellerdetails,
    REGEXP_SUBSTR(
        sellerdetails,
        '([a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,})'
    ) AS extracted_email
FROM 
    sample_longlist_data) as A where extracted_email is null;
    
SELECT 
    REGEXP_SUBSTR(
        sellerdetails,
        '([a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,})'
    ) AS extracted_email
FROM 
    sample_longlist_data;


UPDATE sample_longlist_data
SET EmailAddress = REGEXP_SUBSTR(
    sellerdetails,
    '([a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,})'
);


select * from sample_longlist_data;
