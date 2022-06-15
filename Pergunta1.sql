drop table category cascade;
drop table simple_category cascade;
drop table super_category cascade;
drop table has_other cascade;
drop table product cascade;
drop table has_category cascade;
drop table IVM cascade;
drop table retail_point cascade;
drop table instaled_at cascade;
drop table shelf cascade;
drop table planogram cascade;
drop table retailer cascade;
drop table responsable_for cascade;
drop table replenishment_event cascade;



----------------------------------------
-- Table Creation
----------------------------------------

-- Named constraints are global to the database.
-- Therefore the following use the following naming rules:
--   1. pk_table for names of primary key constraints
--   2. fk_table_another for names of foreign key constraints

create table category
   (category_name 	varchar(80)	not null unique,
    constraint pk_category primary key(category_name));

create table simple_category
    (simple_category_name   varchar(80) not null unique,
    constraint pk_simple_category primary key(simple_category_name),
    constraint fk_simple_category foreign key(simple_category_name) references category(category_name));

create table super_category
    (super_category_name   varchar(80) not null unique,
    constraint pk_super_category primary key(super_category_name),
    constraint fk_super_category foreign key(super_category_name) references category(category_name));

create table has_other
    (has_other_super_category   varchar(80)	not null unique,
    has_other_category          varchar(80)	not null unique,
    constraint pk_has_other_super_category primary key(has_other_super_category),
    constraint fk_has_other_super_category foreign key(has_other_super_category) references super_category,
    constraint fk_has_other_category foreign key(has_other_category) references category);

create table product
   (EAN 	            numeric(13, 0) not null unique,
    descr 	            varchar(80)	not null,
    product_category    varchar(80) not null unique,
    constraint pk_product primary key(EAN),
    constraint fk_product_category foreign key(product_category) references category(category_name));

create table has_category
   (EAN 	            numeric(13, 0) not null unique,
   category_name 	    varchar(80)	not null unique,
   constraint fk_has_category_EAN foreign key(EAN) references product(EAN),  		
   constraint fk_has_category_name foreign key(category_name) references category(category_name));

create table IVM
    (serial_number      numeric(9, 0) not null,
    manuf               varchar(80) not null,
    unique(serial_number, manuf),
    constraint pk_IVM primary key(serial_number, manuf));

create table retail_point
    (retail_point_name  varchar(80) not null unique,
    district            varchar(80),
    county              varchar(80),
    unique(district, county),
    constraint pk_retail_point primary key(retail_point_name));

create table instaled_at
    (serial_number numeric(9, 0) not null unique,
    manuf   varchar(80) not null unique,
    district            varchar(80),
    county              varchar(80),
    unique(district, county),
    constraint pk_instaled_at primary key(serial_number, manuf),
    constraint fk_instaled_at_IVM foreign key(serial_number, manuf) references IVM(serial_number, manuf),
    constraint fk_instaled_at_retail_point foreign key(district, county) references retail_point(district, county));

create table shelf
    (shelf_number   numeric not null,
    shelf_name      varchar(80),
    height          numeric,
    serial_number   numeric(9, 0) not null, 
    manuf           varchar(80) not null,
    unique(shelf_number, serial_number, manuf),
    constraint pk_shelf primary key(shelf_number, serial_number, manuf),
    constraint fk_shelf foreign key(serial_number, manuf) references IVM(serial_number, manuf));

create table planogram
    (faces          numeric,
    units           numeric,
    loc             varchar(80),
    EAN             numeric(13, 0) not null unique,
    serial_number   numeric(9, 0) not null unique, 
    shelf_number    numeric not null unique,
    manuf           varchar(80) not null unique,
    constraint pk_planogram primary key(EAN, shelf_number, serial_number, manuf),
    constraint fk_planogram_EAN foreign key(EAN) references product(EAN),
    constraint fk_planogram_shelf foreign key(serial_number, shelf_number, manuf) references shelf(serial_number, shelf_number, manuf));

create table retailer
    (TIN            numeric(9, 0) not null unique,
    retailer_name   varchar(80) unique,
    constraint pk_retailer primary key(TIN));

create table responsable_for
   (serial_number       numeric(9, 0) not null unique,
    manuf               varchar(80) not null unique,
    TIN                 numeric(9, 0) not null unique,
    category_name       varchar(80) not null unique,
    constraint pk_responsable_for primary key(serial_number, manuf), 
    constraint fk_responsable_for_IVM foreign key(serial_number, manuf) references IVM(serial_number, manuf),
    constraint fk_responsable_for_TIN foreign key(TIN) references retailer(TIN),
    constraint fk_responsable_for_category foreign key(category_name) references category(category_name));

create table replenishment_event
   (EAN             numeric(13, 0) not null unique,
    serial_number   numeric(9, 0) not null unique, 
    shelf_number    numeric not null unique,
    manuf           varchar(80) not null unique,
    TIN             numeric(9, 0) not null unique,
    instant         varchar(80) not null unique,
    constraint pk_replenishment_event primary key(EAN, shelf_number, serial_number, manuf, instant),
    constraint fk_replenishment_event_EAN foreign key(EAN, serial_number, shelf_number, manuf) references planogram(EAN, serial_number, shelf_number, manuf),
    constraint fk_replenishment_event_TIN foreign key(TIN) references retailer(TIN));

INSERT INTO category VALUES ("Food");
INSERT INTO category VALUES ("Beverages");
INSERT INTO category VALUES ("Perishable");
INSERT INTO category VALUES ("Non Perishable");
INSERT INTO category VALUES ("Animal Meat");
INSERT INTO category VALUES ("Grains");
INSERT INTO category VALUES ("Bread");
INSERT INTO category VALUES ("Beef");
INSERT INTO category VALUES ("Pork");
INSERT INTO category VALUES ("Water");
INSERT INTO category VALUES ("Juice");
INSERT INTO category VALUES ("Soda");

INSERT INTO super_category VALUES ("Food");
INSERT INTO super_category VALUES ("Beverages");
INSERT INTO super_category VALUES ("Perishable");
INSERT INTO super_category VALUES ("Non Perishable");
INSERT INTO super_category VALUES ("Animal Meat");

INSERT INTO simple_category VALUES ("Grains");
INSERT INTO simple_category VALUES ("Bread");
INSERT INTO simple_category VALUES ("Beef");
INSERT INTO simple_category VALUES ("Pork");
INSERT INTO simple_category VALUES ("Water");
INSERT INTO simple_category VALUES ("Juice");
INSERT INTO simple_category VALUES ("Soda");

INSERT INTO has_other VALUES ("Food", "Perishable");
INSERT INTO has_other VALUES ("Food", "Non Perishable");
INSERT INTO has_other VALUES ("Beverages", "Water");
INSERT INTO has_other VALUES ("Beverages", "Juice");
INSERT INTO has_other VALUES ("Beverages", "Soda");
INSERT INTO has_other VALUES ("Perishable", "Animal Meat");
INSERT INTO has_other VALUES ("Non Perishable", "Grains");
INSERT INTO has_other VALUES ("Animal Meat", "Beef");
INSERT INTO has_other VALUES ("Animal Meat", "Pork");
