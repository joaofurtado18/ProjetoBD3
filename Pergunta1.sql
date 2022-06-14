drop table borrower cascade;
drop table loan cascade;
drop table depositor cascade;
drop table account cascade;
drop table customer cascade;
drop table branch cascade;

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
    (constraint pk_simple_category primary key(simple_category_name)
    constraint fk_simple_category foreign key(category) references category(category_name))

create table super_category
    (constraint pk_super_category primary key(super_category_name)
    constraint fk_super_category foreign key(category) references category(category_name))

create table product
   (EAN 	        numeric(13, 0)	not null unique,
    descr 	varchar(80)	not null,
    constraint pk_product primary key(EAN));
    constraint fk_product_category foreign key(category) references category(category_name)

create table has_category
   (constraint fk_has_category_EAN foreign key(product) references product(EAN);	    		
    constraint fk_has_category_name foreign key(category) references category(category_name))	    		
 

create table IVM
    (serial_number numeric(9, 0) not null unique
    manuf   varchar(80) not null unique
    constraint pk_IVM primary key(serial_number, manuf))

create table retail_point
    (retail_point_name  varchar(80) not null unique
    district            varchar(80)
    county              varchar(80)
    constraint pk_retail_point primary key(retail_point_name))

create table instaled_at
   (constraint fk_instaled_at_IVM foreign key(IVM) references IVM(serial_number, manuf)
   constraint fk_instaled_at_retail_point foreign key(retail_point) references retail_point(district, county))

create table shelf
    (shelf_number   numeric not null unique
    height          numeric
    shelf_name      varchar(80)
    constraint fk_shelf foreign key(IVM) references IVM(serial_number, manuf))

create table planogram
    (faces  numeric
    units   numeric
    loc     varchar(80)
    constraint fk_planogram_EAN foreign key(product) references product(EAN)
    constraint fk_planogram foreign key(shelf) references shelf(fk_shelf, shelf_number))

create table retailer
    (TIN            numeric(9, 0) not null unique
    retailer_name   varchar(80) unique)

create table responsable_for
   (constraint fk_responsable_for_IVM foreign key(IVM) references IVM(serial_number, manuf)
   constraint fk_responsable_for_TIN foreign key retailer references retailer(TIN)
   constraint fk_responsable_for_category foreign key(category) references category(category_name))

----------------------------------------
-- Populate Relations 
----------------------------------------

insert into customer values ('Adams',	'Main Street',	'Lisbon');
insert into customer values ('Brown',	'Main Street',	'Oporto');
insert into customer values ('Cook',	'Main Street',	'Lisbon');
insert into customer values ('Davis',	'Church Street','Oporto');
insert into customer values ('Evans',	'Forest Street','Coimbra');
insert into customer values ('Flores',	'Station Street','Braga');
insert into customer values ('Gonzalez','Sunny Street', 'Faro');
insert into customer values ('Iacocca',	'Spring Steet',	'Coimbra');
insert into customer values ('Johnson',	'New Street',	'Cascais');
insert into customer values ('King',	'Garden Street','Aveiro');
insert into customer values ('Lopez',	'Grand Street',	'Vila Real');
insert into customer values ('Martin',	'Royal Street',	'Braga');
insert into customer values ('Nguyen',	'School Street','Castelo Branco');
insert into customer values ('Oliver',	'First Stret',	'Oporto');
insert into customer values ('Parker',	'Hope Street',  'Oporto');

insert into branch values ('Central',	'Guimarães',		2100000);
insert into branch values ('Clerigos',  'Oporto',		3900000);
insert into branch values ('Downtown',	'Lisbon',		1900000);
insert into branch values ('Metro',	'Amadora',	 	400200);
insert into branch values ('Round Hill','Amadora',		8000000);
insert into branch values ('Ship Terminal', 'Sintra',	 	0400000);
insert into branch values ('University',	'Vila Real',	7200000);
insert into branch values ('Uptown',	'Amadora',		1700000);
insert into branch values ('Wine Celar', 'Oporto',		4002800);

insert into account values ('A-101',	'Downtown',	500);
insert into account values ('A-102',	'Uptown',	700);
insert into account values ('A-201',	'Uptown',	900);
insert into account values ('A-215',	'Metro',	600);
insert into account values ('A-217',	'University',	650);
insert into account values ('A-222',	'Central',	550);
insert into account values ('A-305',	'Round Hill',	800);
insert into account values ('A-333',	'Central',	750);
insert into account values ('A-444',	'Downtown',	850);

insert into depositor values ('Cook',	 'A-102');
insert into depositor values ('Johnson', 'A-101');
insert into depositor values ('Cook',	 'A-101');
insert into depositor values ('Johnson', 'A-201');
insert into depositor values ('Brown',	 'A-215');
insert into depositor values ('Iacocca', 'A-217');
insert into depositor values ('Evans',   'A-222');
insert into depositor values ('Flores',	 'A-305');
insert into depositor values ('Oliver',  'A-333');
insert into depositor values ('Brown',	 'A-444');

insert into loan values ('L-11', 'Round Hill',	6000);
insert into loan values ('L-14', 'Downtown',	4000);
insert into loan values ('L-15', 'Uptown',	3000);
insert into loan values ('L-16', 'Uptown',	7000);
insert into loan values ('L-17', 'Downtown',	1000);
insert into loan values ('L-20', 'Downtown',	8000);
insert into loan values ('L-21', 'Central',	9000);
insert into loan values ('L-23', 'Central',	2000);
insert into loan values ('L-93', 'Metro',	5000);

insert into borrower values ('Brown',	'L-11');
insert into borrower values ('Nguyen',	'L-14');
insert into borrower values ('Cook',	'L-15');
insert into borrower values ('Iacocca',	'L-16');
insert into borrower values ('Gonzalez','L-17');
insert into borrower values ('Iacocca',	'L-17');
insert into borrower values ('Parker',	'L-20');
insert into borrower values ('Brown',	'L-21');
insert into borrower values ('Brown',	'L-23');
insert into borrower values ('Davis',	'L-93');
