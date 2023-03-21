-- SQL Commands & Queries to create the relevant tables and get the requested data.

-- Stock Table
CREATE TABLE IF NOT EXISTS stock
(
    company_id integer NOT NULL DEFAULT 'nextval('stock_company_id_seq'::regclass)',
    company_name character varying(50) COLLATE pg_catalog."default" NOT NULL,
    currency character varying(3) COLLATE pg_catalog."default" NOT NULL,
    country character varying(50) COLLATE pg_catalog."default" NOT NULL,
    CONSTRAINT stock_pkey PRIMARY KEY (company_id)
)

-- Table: public.trading

-- DROP TABLE IF EXISTS public.trading;

CREATE TABLE IF NOT EXISTS public.trading
(
    trading_id integer NOT NULL DEFAULT 'nextval('trading_trading_id_seq'::regclass)',
    company_id integer NOT NULL,
    open_rate double precision NOT NULL,
    close_rate double precision NOT NULL,
    high double precision NOT NULL,
    low double precision NOT NULL,
    adj_close double precision NOT NULL,
    volume double precision NOT NULL,
    year_val integer NOT NULL,
    month_val integer NOT NULL,
    week_val integer NOT NULL,
    CONSTRAINT trading_pkey PRIMARY KEY (trading_id),
    CONSTRAINT trading_company_id_fkey FOREIGN KEY (company_id)
        REFERENCES public.stock (company_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
)

-- Table: public.calculations

-- DROP TABLE IF EXISTS public.calculations;

CREATE TABLE calculations
(
    company_id integer NOT NULL,
    twenty_days float NOT NULL,
    fifty_days float NOT NULL,
    twohundred_days float NOT NULL,
    CONSTRAINT calc_company_id_fkey FOREIGN KEY (company_id)
	REFERENCES public.stock (company_id) MATCH SIMPLE
)

----------------------------------------------------------------------------------------------

-- Queries to find our weekly, monthly, quarterly, yearly averages of High, Low, Volume

----------------------------------------------------------------------------------------------
-- Yearly Average Calculations
SELECT avg(high), year_val
	FROM public.trading
	group by year_val
----------------------------------------------------------
-- Result
-- High Average          Year
--73.71009195852538	    2017
--131.23095248015883	2019
--278.0180160198413	    2021
--195.4651384229249	    2020
--310.66911585294116	2022
--102.11406372509963	2018
----------------------------------------------------------
-- Monthly Average calculations
SELECT avg(high) as "Avg High", avg(low) as "Avg Low", avg(volume) as "Avg Volume",
year_val, month_val
FROM public.trading
group by month_val, year_val

------------------------------------------------------------------------------
--  Result
-- High Average          Low Average         Volume Average     Year   Month
--157.54500095454546	147.59863563636364	73304340.9090909	2020	3
--85.40950040000001	    84.16350020000002	23310165	        2017	12
--133.10750045000003	130.85050059999998	25416215	        2019	6
--92.76578884210524	    90.05157957894737	38192805.2631579	2018	2
--241.96736636842107	237.45157668421052	25840115.789473683	2021	2
--101.33285680952382	99.8576188095238	28694533.333333332	2018	6
--148.55350254999996	147.15550084999995	19618590	        2019	11
--104.97809552380951	102.85095204761903	34010133.333333336	2019	1
------------------------------------------------------------------------------

-- Weekly Average calculations for year 2019 and month March
SELECT avg(high) as "Avg High", avg(low) as "Avg Low", avg(volume) as "Avg Volume",
week_val
FROM public.trading
where year_val = '2019' and month_val = '3'
group by week_val

------------------------------------------------------------------------------
--  Result
-- High Average          Low Average         Volume Average     week
-- 116.31428528571429	114.20285671428573	24037714.285714287	11
-- 115.70071414285714	114.0264287857143	30059414.285714287	12

------------------------------------------------------------------------------

-- Quarterly Average calculations for year 2019 and Q2 March
SELECT avg(high) as "Avg High", avg(low) as "Avg Low", avg(volume) as "Avg Volume"
, '2019 - Q1' as Quarter
FROM public.trading
where year_val = '2019' and month_val in (1,2,3)

------------------------------------------------------------------------------
--  Result
-- High Average          Low Average         Volume Average      Quarter
-- 109.82163934426225	107.98032786885244	29055811.475409836	"2019 - Q1"
