create schema if not exists dwh;


-- ************************************** calendar_dim
drop table if exists dwh.calendar_dim;
CREATE TABLE dwh.calendar_dim
(
 date_id  date NOT NULL,
 year     int NOT NULL,
 quarter  int NOT NULL,
 month    int NOT NULL,
 week     int NOT NULL,
 week_day varchar(20) NOT NULL,
 CONSTRAINT PK_calendar_dim PRIMARY KEY ( date_id )
);

truncate table dwh.calendar_dim;

insert into dwh.calendar_dim
select
	to_char(order_date, 'yyyymmdd')::date as date_id,
	extract('year' from order_date)::int as year,
	extract('quarter' from order_date)::int as quarter,
    extract('month' from order_date)::int as month,
    extract('week' from order_date)::int as week,
    to_char(order_date, 'dy') as week_day
from (
	select distinct order_date
	from stg."order"
	union
	select distinct ship_date
	from stg."order"
) a;


-- ************************************** customer_dim
drop table if exists dwh.customer_dim;
CREATE TABLE dwh.customer_dim
(
 customer_id   varchar(10) NOT NULL,
 customer_name varchar(25) NOT NULL,
 CONSTRAINT PK_customer_dim PRIMARY KEY ( customer_id )
);

truncate table dwh.customer_dim;

insert into dwh.customer_dim
select customer_id, customer_name
from (select distinct customer_id, customer_name from stg."order") a;


-- ************************************** location_dim
drop table if exists dwh.location_dim;
CREATE TABLE dwh.location_dim
(
 location_id serial NOT NULL,
 country     varchar(20) NOT NULL,
 region      varchar(15) NOT NULL,
 "state"     varchar(25) NOT NULL,
 city        varchar(20) NOT NULL,
 postal_code varchar(20) NULL,
 CONSTRAINT PK_location_dim PRIMARY KEY ( location_id )
);

truncate table dwh.location_dim;

insert into dwh.location_dim
select
	row_number() over() as location_id,
	country,
	region,
	state,
	city,
	postal_code
from (select distinct country, region, city, state, postal_code from stg."order" ) a;

update dwh.location_dim
set postal_code = '05401'
where city = 'Burlington'  and postal_code is null;

update stg.order
set postal_code = '05401'
where city = 'Burlington'  and postal_code is null;

-- ************************************** product_dim
drop table if exists dwh.product_dim;
CREATE TABLE dwh.product_dim
(
 product_id   varchar(20) NOT NULL,
 product_name varchar(150) NOT NULL,
 category     varchar(20) NOT NULL,
 subcategory  varchar(15) NOT NULL,
 segment      varchar(15) NOT NULL,
 CONSTRAINT PK_product_dim PRIMARY KEY ( product_id )
);

truncate table dwh.product_dim;

insert into dwh.product_dim
select
	product_id,
	product_name,
	category,
	subcategory,
	segment
from (select distinct on (product_id) product_id, product_name, category, subcategory, segment from stg."order") a;

-- ************************************** shipping_dim
drop table if exists dwh.shipping_dim;
CREATE TABLE dwh.shipping_dim
(
 ship_id   serial NOT NULL,
 ship_mode varchar(20) NOT NULL,
 CONSTRAINT PK_shipping_dim PRIMARY KEY ( ship_id )
);

truncate table dwh.shipping_dim;

insert into dwh.shipping_dim
select
	row_number() over() as ship_id,
	ship_mode
from (select distinct ship_mode from stg."order" ) a;

-- ************************************** sales_fact
drop table if exists dwh.sales_fact;

CREATE TABLE dwh.sales_fact
(
 row_id      serial NOT NULL,
 order_id    varchar(20) NOT NULL,
 sales       numeric(9, 4) NOT NULL,
 quantity    int NOT NULL,
 profit      numeric(21, 16) NOT NULL,
 discount    numeric(4, 2) NOT NULL,
 product_id  varchar(20) NOT NULL,
 location_id serial NOT NULL,
 customer_id varchar(10) NOT NULL,
 ship_id     serial NOT NULL,
 ship_date   date NOT NULL,
 order_date  date NOT NULL,
 CONSTRAINT PK_sales_fact PRIMARY KEY ( row_id ),
 CONSTRAINT FK_product_dim FOREIGN KEY ( product_id ) REFERENCES dwh.product_dim ( product_id ),
 CONSTRAINT FK_location_dim FOREIGN KEY ( location_id ) REFERENCES dwh.location_dim ( location_id ),
 CONSTRAINT FK_customer_dim FOREIGN KEY ( customer_id ) REFERENCES dwh.customer_dim ( customer_id ),
 CONSTRAINT FK_shipping_dim FOREIGN KEY ( ship_id ) REFERENCES dwh.shipping_dim ( ship_id ),
 CONSTRAINT FK_calendar_dim_ship_date FOREIGN KEY ( ship_date ) REFERENCES dwh.calendar_dim ( date_id ),
 CONSTRAINT FK_calendar_dim_order_date FOREIGN KEY ( order_date ) REFERENCES dwh.calendar_dim ( date_id )
);

insert into dwh.sales_fact
select
	o.row_id,
	o.order_id,
	o.sales,
	o.quantity,
	o.profit,
	o.discount,
	o.product_id,
	l.location_id,
	o.customer_id,
	s.ship_id,
	o.ship_date,
	o.order_date
from stg."order" o
inner join dwh.location_dim l on o.postal_code::varchar = l.postal_code and l.country=o.country and l.city = o.city and o.state = l.state
inner join dwh.shipping_dim s on o.ship_mode = s.ship_mode;