create schema if not exists dwh;


-- ************************************** calendar_dim
drop table if exists dwh.calendar_dim;
CREATE TABLE dwh.calendar_dim (
    date_key INTEGER PRIMARY KEY,
    full_date DATE NOT NULL,
    year INTEGER NOT NULL,
    quarter INTEGER NOT NULL,
    quarter_name VARCHAR(2) NOT NULL,
    month INTEGER NOT NULL,
    month_name VARCHAR(20) NOT NULL,
    day_of_month INTEGER NOT NULL,
    day_of_year INTEGER NOT NULL,
    week_of_year INTEGER NOT NULL,
    day_of_week INTEGER NOT NULL,
    day_of_week_name VARCHAR(20) NOT NULL,
    is_weekend BOOLEAN NOT NULL,
    is_month_start BOOLEAN NOT NULL,
    is_month_end BOOLEAN NOT NULL
);

INSERT INTO dwh.calendar_dim
WITH date_series AS (
    SELECT CAST(generate_series('2014-01-01'::date, '2021-12-31'::date, '1 day') AS DATE) AS full_date
)
SELECT
    CAST(TO_CHAR(full_date, 'YYYYMMDD') AS INTEGER) AS date_key,
    full_date,
    EXTRACT(YEAR FROM full_date) AS year,
    EXTRACT(QUARTER FROM full_date) AS quarter,
    'Q' || EXTRACT(QUARTER FROM full_date) AS quarter_name,
    EXTRACT(MONTH FROM full_date) AS month,
    TO_CHAR(full_date, 'Month') AS month_name,
    EXTRACT(DAY FROM full_date) AS day_of_month,
    EXTRACT(DOY FROM full_date) AS day_of_year,
    EXTRACT(WEEK FROM full_date) AS week_of_year,
    EXTRACT(ISODOW FROM full_date) AS day_of_week, -- 1 = Понедельник, 7 = Воскресенье
    TO_CHAR(full_date, 'Day') AS day_of_week_name,
    EXTRACT(ISODOW FROM full_date) IN (6, 7) AS is_weekend,
    (EXTRACT(DAY FROM full_date) = 1) AS is_month_start,
    (full_date = (date_trunc('MONTH', full_date) + INTERVAL '1 MONTH - 1 day')::date) AS is_month_end
FROM
    date_series;

INSERT INTO dwh.calendar_dim VALUES
(-1, '1900-01-01', 0, 0, 'Q0', 0, 'Unknown', 0, 0, 0, 0, 'Unknown', FALSE, FALSE, FALSE);


-- ************************************** customer_dim
drop table if exists dwh.customer_dim;
CREATE TABLE dwh.customer_dim
(
 customer_key  serial NOT NULL,
 customer_id   varchar(10) NOT NULL,
 customer_name varchar(25) NOT NULL,
 CONSTRAINT PK_customer_dim PRIMARY KEY ( customer_key )
);

truncate table dwh.customer_dim;

insert into dwh.customer_dim
select row_number() over(), customer_id, customer_name
from (select distinct customer_id, customer_name from stg."order") a;


-- ************************************** geo_dim
drop table if exists dwh.geo_dim;
CREATE TABLE dwh.geo_dim
(
 geo_key     serial NOT NULL,
 country     varchar(20) NOT NULL,
 region      varchar(15) NOT NULL,
 "state"     varchar(25) NOT NULL,
 city        varchar(20) NOT NULL,
 postal_code varchar(20) NULL,
 CONSTRAINT PK_geo_dim PRIMARY KEY ( geo_key )
);

truncate table dwh.geo_dim;

insert into dwh.geo_dim
select
	row_number() over() as geo_key,
	country,
	region,
	state,
	city,
	postal_code
from (select distinct country, region, city, state, postal_code from stg."order" ) a;

update dwh.geo_dim
set postal_code = '05401'
where city = 'Burlington'  and postal_code is null;

update stg."order"
set postal_code = '05401'
where city = 'Burlington'  and postal_code is null;

-- ************************************** product_dim
drop table if exists dwh.product_dim;
CREATE TABLE dwh.product_dim
(
 product_key  serial      NOT NULL,
 product_id   varchar(20) NOT NULL,
 product_name varchar(150) NOT NULL,
 category     varchar(20) NOT NULL,
 subcategory  varchar(15) NOT NULL,
 segment      varchar(15) NOT NULL,
 CONSTRAINT PK_product_dim PRIMARY KEY ( product_key )
);

truncate table dwh.product_dim;

insert into dwh.product_dim
select
	row_number() over() as product_key,
	product_id,
	product_name,
	category,
	subcategory,
	segment
from (select distinct product_id, product_name, category, subcategory, segment from stg."order") a;

-- ************************************** shipping_dim
drop table if exists dwh.shipping_dim;
CREATE TABLE dwh.shipping_dim
(
 ship_key   serial NOT NULL,
 ship_mode varchar(20) NOT NULL,
 CONSTRAINT PK_shipping_dim PRIMARY KEY ( ship_key )
);

truncate table dwh.shipping_dim;

insert into dwh.shipping_dim
select
	row_number() over() as ship_key,
	ship_mode
from (select distinct ship_mode from stg."order" ) a;

-- ************************************** orders_dim
drop table if exists dwh.orders_dim;
CREATE TABLE dwh.orders_dim
(
 order_key   serial NOT NULL,
 order_id    varchar(20) NOT NULL,
 returned    boolean NOT NULL,
 CONSTRAINT PK_orders_dim PRIMARY KEY ( order_key )
);

truncate table dwh.orders_dim;

insert into dwh.orders_dim
select
	row_number() over() as order_key,
	order_id,
    returned
from (
    select 
        distinct o.order_id,
        case 
            when r.returned is null then false 
            else true
        end as returned
    from stg."order" o
    left join stg."return" r on r.order_id = o.order_id
) a;

-- ************************************** managers_dim
drop table if exists dwh.managers_dim;
CREATE TABLE dwh.managers_dim
(
 manager_key serial NOT NULL,
 person      varchar(20) NOT NULL,
 region    varchar(20) NOT NULL,
 CONSTRAINT PK_managers_dim PRIMARY KEY ( manager_key )
);

truncate table dwh.managers_dim;

insert into dwh.managers_dim
select
	row_number() over() as manager_key,
	person,
    region
from (select distinct person, region from stg."people") a;

-- ************************************** sales_fct
drop table if exists dwh.sales_fct;
CREATE TABLE dwh.sales_fct
(
 sales_key	 serial NOT NULL,
 order_key   int NOT NULL,
 sales       numeric(9, 4) NOT NULL,
 quantity    int NOT NULL,
 profit      numeric(21, 16) NOT NULL,
 discount    numeric(4, 2) NOT NULL,
 product_key int NOT NULL,
 geo_key     int NOT NULL,
 customer_key int NOT NULL,
 ship_key     int NOT NULL,
 ship_date_key   int NOT NULL,
 order_date_key  int NOT NULL,
 manager_key    int NOT NULL,
 CONSTRAINT PK_fct_sales PRIMARY KEY ( sales_key ),
 CONSTRAINT orders_dim FOREIGN KEY ( order_key ) REFERENCES dwh.orders_dim ( order_key ),
 CONSTRAINT FK_product_dim FOREIGN KEY ( product_key ) REFERENCES dwh.product_dim ( product_key ),
 CONSTRAINT FK_location_dim FOREIGN KEY ( geo_key ) REFERENCES dwh.geo_dim ( geo_key ),
 CONSTRAINT FK_customer_dim FOREIGN KEY ( customer_key ) REFERENCES dwh.customer_dim ( customer_key ),
 CONSTRAINT FK_shipping_dim FOREIGN KEY ( ship_key ) REFERENCES dwh.shipping_dim ( ship_key ),
 CONSTRAINT FK_calendar_dim_ship_date FOREIGN KEY ( ship_date_key ) REFERENCES dwh.calendar_dim ( date_key ),
 CONSTRAINT FK_calendar_dim_order_date FOREIGN KEY ( order_date_key ) REFERENCES dwh.calendar_dim ( date_key ),
 CONSTRAINT FK_manager_dim FOREIGN KEY ( manager_key ) REFERENCES dwh.managers_dim ( manager_key )
);

truncate table dwh.sales_fct;

insert into dwh.sales_fct
select
	row_number() over() as sales_key,
	od.order_key,
	o.sales,
	o.quantity,
	o.profit,
	o.discount,
	p.product_key,
	g.geo_key,
	cd.customer_key,
	s.ship_key,
	TO_CHAR(o.ship_date, 'YYYYMMDD')::INT AS ship_date_key,
	TO_CHAR(o.order_date, 'YYYYMMDD')::INT AS order_date_key,
	m.manager_key
from stg."order" o
inner join dwh.product_dim p on o.product_name = p.product_name and o.segment=p.segment and o.subcategory=p.subcategory and o.category=p.category and o.product_id=p.product_id 
inner join dwh.geo_dim g on o.postal_code::varchar = g.postal_code and g.country=o.country and g.city = o.city and o.state = g.state
inner join dwh.customer_dim cd on cd.customer_id=o.customer_id and cd.customer_name=o.customer_name
inner join dwh.shipping_dim s on o.ship_mode = s.ship_mode
inner join dwh.orders_dim od on o.order_id = od.order_id
inner join dwh.managers_dim m on o.region = m.region;

--################ query for dashboard
select * from dwh.sales_fct sf
inner join dwh.shipping_dim s on sf.ship_key=s.ship_key
inner join dwh.geo_dim g on sf.geo_key=g.geo_key
inner join dwh.product_dim p on sf.product_key=p.product_key
inner join dwh.customer_dim c on sf.customer_key=c.customer_key
inner join dwh.calendar_dim cd on sf.order_date_key=cd.date_key
inner join dwh.orders_dim od on sf.order_key=od.order_key
inner join dwh.managers_dim m on sf.manager_key=m.manager_key;