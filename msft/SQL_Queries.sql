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

-- Queries to find our weekly, monthly, quarterly, yearly averages of
