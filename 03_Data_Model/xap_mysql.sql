--
--  XAP eXtendable Application Platform
--
--


-- mysqldump -h host -uroot -ppassword databasename --default-character-set=latin1 

# 2014-12-04
# 2014-10-09  additional columns for XAP-CLASS-ATTRIBUTE 
# 2014-10-09  removed duplicate enumeration_id attribute from XAP-ENUMERATION-ENTRY
#
# 2014-09-12  added some references in the meta model


drop database xap;

create database xap;

use xap;




create table xap_user
(xap_id             int         not null auto_increment,
 xap_cre_dat        datetime    not null,
 xap_user_id        int         not null,
 xap_project_id     int         not null,
 xap_access         varchar(3)  not null default 'ddr',
 xap_deleted        char(1)     not null default 'n', 
 xap_upd_dat        datetime    null,
 xap_upd_user_id    int         null,
 xap_reservation_id int         null,
 --
 name               varchar(20) not null,
 password           varchar(32) null, -- md5 encrypted password
 person_id          int null,
 primary key (xap_id),
 unique key (name)
);


insert into xap_user (xap_id, xap_cre_dat, xap_user_id, xap_project_id, name, password)
  values (1, now(), 1, 1, 'xap', md5('xap'));

alter table xap_user add foreign key (xap_user_id) references xap_user(xap_id) on delete cascade;
alter table xap_user add foreign key (xap_upd_user_id) references xap_user(xap_id) on delete set null;

  

create table xap_person
(xap_id             int         not null auto_increment,
 xap_cre_dat        datetime    not null,
 xap_user_id        int         not null,
 xap_project_id     int         not null,
 xap_access         varchar(3)  not null default 'ddr',
 xap_deleted        char(1)     not null default 'n', 
 xap_upd_dat        datetime    null,
 xap_upd_user_id    int         null,
 xap_reservation_id int         null,
 --
 first_name      varchar(50),
 last_name       varchar(50),
 email           varchar(100),
 --
 primary key (xap_id),
 foreign key (xap_user_id) references xap_user(xap_id) on delete cascade,
 foreign key (xap_upd_user_id) references xap_user(xap_id) on delete set null
);

alter table xap_user add foreign key (person_id) references xap_person(xap_id) on delete set null;





  
create table xap_reservation
(xap_id             int         not null auto_increment,
 xap_cre_dat        datetime    not null,
 xap_user_id        int         not null,
 xap_project_id     int         not null,
 xap_access         varchar(3)  not null default 'ddr',
 xap_deleted        char(1)     not null default 'n', 
 xap_upd_dat        datetime    null,
 xap_upd_user_id    int         null,
 xap_reservation_id int         null,
 --
 table_name        varchar(50),   -- table_name is used,
                                  --   because it could reference a class,
				  --                                reference,
				  --                                whatever
 record_id         int,
 user_id           int,
 --
 primary key (xap_id),
 foreign key (xap_user_id) references xap_user(xap_id) on delete cascade,
 foreign key (xap_upd_user_id) references xap_user(xap_id) on delete set null,
 --
 foreign key (user_id) references xap_user(xap_id)
);


alter table xap_user        add foreign key (xap_reservation_id) references xap_reservation(xap_id) on delete cascade;
alter table xap_person      add foreign key (xap_reservation_id) references xap_reservation(xap_id) on delete cascade;
alter table xap_reservation add foreign key (xap_reservation_id) references xap_reservation(xap_id) on delete cascade;


create table xap_project
(xap_id             int         not null auto_increment,
 xap_cre_dat        datetime    not null,
 xap_user_id        int         not null,
 xap_project_id     int         not null,
 xap_access         varchar(3)  not null default 'ddr',
 xap_deleted        char(1)     not null default 'n', 
 xap_upd_dat        datetime    null,
 xap_upd_user_id    int         null,
 xap_reservation_id int         null,
 --
 primary key (xap_id),
 foreign key (xap_user_id)        references xap_user(xap_id)        on delete cascade,
 foreign key (xap_upd_user_id)    references xap_user(xap_id)        on delete set null,
 foreign key (xap_reservation_id) references xap_reservation(xap_id) on delete cascade,
 --
 name              varchar(50) not null,
 description       varchar(300)
);
 


insert into xap_project (xap_id, xap_cre_dat, xap_user_id, xap_project_id, name)
  values (1, now(), 1, 1, 'xap');



alter table xap_user        add foreign key (xap_project_id)     references xap_project(xap_id) on delete cascade;
alter table xap_person      add foreign key (xap_project_id)     references xap_project(xap_id) on delete cascade;
alter table xap_reservation add foreign key (xap_project_id)     references xap_project(xap_id) on delete cascade;
alter table xap_project     add foreign key (xap_project_id)     references xap_project(xap_id) on delete cascade;





create table xap_project_str
(xap_id             int         not null auto_increment,
 xap_cre_dat        datetime    not null,
 xap_user_id        int         not null,
 xap_project_id     int         not null,
 xap_access         varchar(3)  not null default 'ddr',
 xap_deleted        char(1)     not null default 'n', 
 xap_upd_dat        datetime    null,
 xap_upd_user_id    int         null,
 xap_reservation_id int         null,
 --
 xap_id_1           int not null,
 xap_id_2           int not null,
 --
 primary key (xap_id),
 foreign key (xap_user_id)        references xap_user(xap_id)        on delete cascade,
 foreign key (xap_project_id)     references xap_project(xap_id)     on delete cascade,
 foreign key (xap_upd_user_id)    references xap_user(xap_id)        on delete set null,
 foreign key (xap_reservation_id) references xap_reservation(xap_id) on delete set null,
 --
 unique key(xap_id_1, xap_id_2),
 foreign key (xap_id_1) references xap_project(xap_id) on delete cascade, 
 foreign key (xap_id_2) references xap_project(xap_id) on delete cascade
);







create table xap_role
(xap_id             int         not null auto_increment,
 xap_cre_dat        datetime    not null,
 xap_user_id        int         not null,
 xap_project_id     int         not null,
 xap_access         varchar(3)  not null default 'ddr',
 xap_deleted        char(1)     not null default 'n', 
 xap_upd_dat        datetime    null,
 xap_upd_user_id    int         null,
 xap_reservation_id int         null,
 --
 name            varchar(50) not null,
 description     varchar(300),
 --
 primary key (xap_id),
 foreign key (xap_user_id)        references xap_user(xap_id)        on delete cascade,
 foreign key (xap_project_id)     references xap_project(xap_id)     on delete cascade,
 foreign key (xap_upd_user_id)    references xap_user(xap_id)        on delete set null,
 foreign key (xap_reservation_id) references xap_reservation(xap_id) on delete set null,
 --
 unique key (name)
);
 


insert into xap_role (xap_id, xap_cre_dat, xap_user_id, xap_project_id, name)
  values (1, now(), 1, 1, 'sysadmin');

  
create table xap_role_str
(xap_id             int         not null auto_increment,
 xap_cre_dat        datetime    not null,
 xap_user_id        int         not null,
 xap_project_id     int         not null,
 xap_access         varchar(3)  not null default 'ddr',
 xap_deleted        char(1)     not null default 'n', 
 xap_upd_dat        datetime    null,
 xap_upd_user_id    int         null,
 xap_reservation_id int         null,
 --
 xap_id_1          int not null,
 xap_id_2          int not null,
 --
 primary key (xap_id),
 foreign key (xap_user_id)        references xap_user(xap_id)        on delete cascade,
 foreign key (xap_project_id)     references xap_project(xap_id)     on delete cascade,
 foreign key (xap_upd_user_id)    references xap_user(xap_id)        on delete set null,
 foreign key (xap_reservation_id) references xap_reservation(xap_id) on delete set null,
 --
 foreign key (xap_id_1) references xap_role(xap_id) on delete cascade, 
 foreign key (xap_id_2) references xap_role(xap_id) on delete cascade
);



create table xap_user_role_project
(xap_id             int         not null auto_increment,
 xap_cre_dat        datetime    not null,
 xap_user_id        int         not null,
 xap_project_id     int         not null,
 xap_access         varchar(3)  not null default 'ddr',
 xap_deleted        char(1)     not null default 'n', 
 xap_upd_dat        datetime    null,
 xap_upd_user_id    int         null,
 xap_reservation_id int         null,
 --
 user_id           int not null,
 project_id        int not null,
 role_id           int not null,
 valid_from        date,
 valid_to          date,
 --
 primary key (xap_id),
 foreign key (xap_user_id)        references xap_user(xap_id)        on delete cascade,
 foreign key (xap_project_id)     references xap_project(xap_id)     on delete cascade,
 foreign key (xap_upd_user_id)    references xap_user(xap_id)        on delete set null,
 foreign key (xap_reservation_id) references xap_reservation(xap_id) on delete set null,
 --
 foreign key (user_id) references xap_user(xap_id) on delete cascade,
 foreign key (project_id) references xap_project(xap_id) on delete cascade,
 foreign key (role_id) references xap_role(xap_id) on delete cascade
);


insert into xap_user_role_project (xap_id, xap_cre_dat, xap_user_id, xap_project_id, user_id, project_id, role_id)
values(1, now(), 1, 1, 1, 1, 1);




-- -----------------------------------------------------------------------------
--   Meta Data Model Tables
-- -----------------------------------------------------------------------------



create table xap_enumeration
(xap_id             int         not null auto_increment,
 xap_cre_dat        datetime    not null,
 xap_user_id        int         not null,
 xap_project_id     int         not null,
 xap_access         varchar(3)  not null default 'ddr',
 xap_deleted        char(1)     not null default 'n', 
 xap_upd_dat        datetime    null,
 xap_upd_user_id    int         null,
 xap_reservation_id int         null,
 --
 primary key (xap_id),
 foreign key (xap_user_id)        references xap_user(xap_id)        on delete cascade,
 foreign key (xap_project_id)     references xap_project(xap_id)     on delete cascade,
 foreign key (xap_upd_user_id)    references xap_user(xap_id)        on delete set null,
 foreign key (xap_reservation_id) references xap_reservation(xap_id) on delete set null,
 --
 name            varchar(50),
 description     varchar(300),
 --
 unique key (name)
);
 

create table xap_enumeration_entry
(xap_id             int         not null auto_increment,
 xap_cre_dat        datetime    not null,
 xap_user_id        int         not null,
 xap_project_id     int         not null,
 xap_access         varchar(3)  not null default 'ddr',
 xap_deleted        char(1)     not null default 'n', 
 xap_upd_dat        datetime    null,
 xap_upd_user_id    int         null,
 xap_reservation_id int         null,
 --
 primary key (xap_id),
 foreign key (xap_user_id)        references xap_user(xap_id)        on delete cascade,
 foreign key (xap_project_id)     references xap_project(xap_id)     on delete cascade,
 foreign key (xap_upd_user_id)    references xap_user(xap_id)        on delete set null,
 foreign key (xap_reservation_id) references xap_reservation(xap_id) on delete set null,
 --
 enumeration_id  int not null,
 entry_id        int not null,          /* unique within one enumeration */
 entry_text      varchar(255) not null,
 description     varchar(255),
 --
 unique key(enumeration_id, entry_id),
 unique key(enumeration_id, entry_text),
 foreign key (enumeration_id) references xap_enumeration(xap_id) on delete cascade
);





create table xap_data_type
(xap_id             int         not null auto_increment,
 xap_cre_dat        datetime    not null,
 xap_user_id        int         not null,
 xap_project_id     int         not null,
 xap_access         varchar(3)  not null default 'ddr',
 xap_deleted        char(1)     not null default 'n', 
 xap_upd_dat        datetime    null,
 xap_upd_user_id    int         null,
 xap_reservation_id int         null,
 --
 primary key (xap_id),
 foreign key (xap_user_id)        references xap_user(xap_id)        on delete cascade,
 foreign key (xap_project_id)     references xap_project(xap_id)     on delete cascade,
 foreign key (xap_upd_user_id)    references xap_user(xap_id)        on delete set null,
 foreign key (xap_reservation_id) references xap_reservation(xap_id) on delete set null,
 --
 name        varchar(50) not null,
 base_type   int not null,  /* references entry in xap_data_type_enum */
 data_len    int,  /* length of text field, number of digits */
 data_prec   int,  /* number of digits behind comma */
 enum_id     int,  /* in case of an enumeration, the enumeration to be used is specified here */
 class_id    int,  /* in case of a reference, the class to which the attribute points needs to be specified */
 --
 unique key(name),
 foreign key (base_type) references xap_enumeration_entry(xap_id) on delete restrict,
 foreign key (enum_id)   references xap_enumeration(xap_id) on delete restrict
 -- foreign key to class to be added after table xap_class is created
);



create table xap_class
(xap_id             int         not null auto_increment,
 xap_cre_dat        datetime    not null,
 xap_user_id        int         not null,
 xap_project_id     int         not null,
 xap_access         varchar(3)  not null default 'ddr',
 xap_deleted        char(1)     not null default 'n', 
 xap_upd_dat        datetime    null,
 xap_upd_user_id    int         null,
 xap_reservation_id int         null,
 --
 primary key (xap_id),
 foreign key (xap_user_id)        references xap_user(xap_id)        on delete cascade,
 foreign key (xap_project_id)     references xap_project(xap_id)     on delete cascade,
 foreign key (xap_upd_user_id)    references xap_user(xap_id)        on delete set null,
 foreign key (xap_reservation_id) references xap_reservation(xap_id) on delete set null,
 --
 name        varchar(50) not null,
 table_name  varchar(50),
 description varchar(300),
 --
 unique key(name)
);

alter table xap_data_type add foreign key (class_id)  references xap_class(xap_id) on delete restrict;


create table xap_class_attribute
(xap_id             int         not null auto_increment,
 xap_cre_dat        datetime    not null,
 xap_user_id        int         not null,
 xap_project_id     int         not null,
 xap_access         varchar(3)  not null default 'ddr',
 xap_deleted        char(1)     not null default 'n', 
 xap_upd_dat        datetime    null,
 xap_upd_user_id    int         null,
 xap_reservation_id int         null,
 --
 primary key (xap_id),
 foreign key (xap_user_id)        references xap_user(xap_id)        on delete cascade,
 foreign key (xap_project_id)     references xap_project(xap_id)     on delete cascade,
 foreign key (xap_upd_user_id)    references xap_user(xap_id)        on delete set null,
 foreign key (xap_reservation_id) references xap_reservation(xap_id) on delete set null,
 --
 class_id    integer not null,
 sort_id     integer not null,
 name        varchar(50) not null,
 description varchar(300),
 data_type   int not null,  /* references entry in xap_data_type_enum */
 not_null    char(1) not null default 'n',
 unique_index_1  varchar(50) null,   
 unique_index_2  varchar(50) null,
 unique_index_3  varchar(50) null,
 instance_name int, /* indicates (sorted) if this attribute is used to build a short name for display,
                        e.g. at references */
 --
 unique key(class_id, name),
 foreign key (class_id) references xap_class(xap_id) on delete cascade,
 foreign key (data_type) references xap_data_type(xap_id) on delete restrict 
);
 


create table xap_relation
(xap_id             int         not null auto_increment,   
 xap_cre_dat        datetime    not null,
 xap_user_id        int         not null,
 xap_project_id     int         not null,
 xap_access         varchar(3)  not null default 'ddr',
 xap_deleted        char(1)     not null default 'n', 
 xap_upd_dat        datetime    null,
 xap_upd_user_id    int         null,
 xap_reservation_id int         null,
 --
 --
 primary key (xap_id),
 foreign key (xap_user_id)        references xap_user(xap_id)        on delete cascade,
 foreign key (xap_project_id)     references xap_project(xap_id)     on delete cascade,
 foreign key (xap_upd_user_id)    references xap_user(xap_id)        on delete set null,
 foreign key (xap_reservation_id) references xap_reservation(xap_id) on delete set null,
 --
 from_class_id int not null,
 to_class_id   int null,
 --
 name        varchar(50) not null,
 table_name  varchar(50),
 description varchar(255),
 --
 is_directed boolean, 
 --
 card_from_min  int null,  -- just for data consistency checks
 card_from_max  int null,  -- just for data consistency checks
 --
 card_to_min  int null,  -- just for data consistency checks
 card_to_max  int null,  -- just for data consistency checks
 --
 unique key(from_class_id, to_class_id, name),
 foreign key (from_class_id)     references xap_class(xap_id)     on delete cascade,
 foreign key (to_class_id)       references xap_class(xap_id)     on delete cascade

);



-- ------------------------------------------------------------
-- Enum for the Atomic Data Types 
-- ------------------------------------------------------------
 
insert into xap_enumeration (xap_id, xap_cre_dat, xap_user_id, xap_project_id, name) 
    values (1, now(), 1, 1, 'XAP_Data_Type_Enum');

    
insert into xap_enumeration_entry (xap_id, xap_cre_dat, xap_user_id, xap_project_id, enumeration_id, entry_id, entry_text) values (1, now(), 1, 1, 1, 1, 'String');
insert into xap_enumeration_entry (xap_id, xap_cre_dat, xap_user_id, xap_project_id, enumeration_id, entry_id, entry_text) values (2, now(), 1, 1, 1, 2, 'Integer');
insert into xap_enumeration_entry (xap_id, xap_cre_dat, xap_user_id, xap_project_id, enumeration_id, entry_id, entry_text) values (3, now(), 1, 1, 1, 3, 'Float');
insert into xap_enumeration_entry (xap_id, xap_cre_dat, xap_user_id, xap_project_id, enumeration_id, entry_id, entry_text) values (4, now(), 1, 1, 1, 4, 'Date');
insert into xap_enumeration_entry (xap_id, xap_cre_dat, xap_user_id, xap_project_id, enumeration_id, entry_id, entry_text) values (5, now(), 1, 1, 1, 5, 'DateTime');
insert into xap_enumeration_entry (xap_id, xap_cre_dat, xap_user_id, xap_project_id, enumeration_id, entry_id, entry_text) values (6, now(), 1, 1, 1, 6, 'Time');
insert into xap_enumeration_entry (xap_id, xap_cre_dat, xap_user_id, xap_project_id, enumeration_id, entry_id, entry_text) values (7, now(), 1, 1, 1, 7, 'Boolean');
insert into xap_enumeration_entry (xap_id, xap_cre_dat, xap_user_id, xap_project_id, enumeration_id, entry_id, entry_text) values (8, now(), 1, 1, 1, 8, 'Enumeration');
insert into xap_enumeration_entry (xap_id, xap_cre_dat, xap_user_id, xap_project_id, enumeration_id, entry_id, entry_text) values (9, now(), 1, 1, 1, 9, 'Reference');



-- ----------------------------------------------------------------------------
-- Data Types   that are used by the XAP Tables 
-- ----------------------------------------------------------------------------


insert into xap_data_type (xap_id, xap_cre_dat, xap_user_id, xap_project_id, name, base_type, data_len, data_prec) values ( 1, now(), 1, 1, 'ID',                2,  10, 0);
insert into xap_data_type (xap_id, xap_cre_dat, xap_user_id, xap_project_id, name, base_type, data_len, data_prec) values ( 2, now(), 1, 1, 'I10',               2,  10, 0);
insert into xap_data_type (xap_id, xap_cre_dat, xap_user_id, xap_project_id, name, base_type, data_len, data_prec) values ( 3, now(), 1, 1, 'Name',              1,  50, 0);
insert into xap_data_type (xap_id, xap_cre_dat, xap_user_id, xap_project_id, name, base_type, data_len, data_prec) values ( 4, now(), 1, 1, 'NameShort',         1,  20, 0);
insert into xap_data_type (xap_id, xap_cre_dat, xap_user_id, xap_project_id, name, base_type, data_len, data_prec) values ( 5, now(), 1, 1, 'NameLong ',         1, 255, 0);
insert into xap_data_type (xap_id, xap_cre_dat, xap_user_id, xap_project_id, name, base_type, data_len, data_prec) values ( 6, now(), 1, 1, 'EncryptedPassword', 1,  32, 0);
insert into xap_data_type (xap_id, xap_cre_dat, xap_user_id, xap_project_id, name, base_type, data_len, data_prec) values ( 7, now(), 1, 1, 'Line',              1, 255, 0);
insert into xap_data_type (xap_id, xap_cre_dat, xap_user_id, xap_project_id, name, base_type, data_len, data_prec) values ( 8, now(), 1, 1, 'Text',              1, 255, 0);
insert into xap_data_type (xap_id, xap_cre_dat, xap_user_id, xap_project_id, name, base_type, data_len, data_prec) values ( 9, now(), 1, 1, 'Email',             1, 100, 0);
insert into xap_data_type (xap_id, xap_cre_dat, xap_user_id, xap_project_id, name, base_type, data_len, data_prec) values (10, now(), 1, 1, 'Description',       1, 300, 0);
insert into xap_data_type (xap_id, xap_cre_dat, xap_user_id, xap_project_id, name, base_type, data_len, data_prec) values (11, now(), 1, 1, 'Date',              4, 255, 0);
insert into xap_data_type (xap_id, xap_cre_dat, xap_user_id, xap_project_id, name, base_type, data_len, data_prec) values (12, now(), 1, 1, 'DateTime',          5, 255, 0);
insert into xap_data_type (xap_id, xap_cre_dat, xap_user_id, xap_project_id, name, base_type, data_len, data_prec) values (13, now(), 1, 1, 'Time',              6, 255, 0);
insert into xap_data_type (xap_id, xap_cre_dat, xap_user_id, xap_project_id, name, base_type, data_len, data_prec) values (14, now(), 1, 1, 'Boolean',           7,   1, 0);
insert into xap_data_type (xap_id, xap_cre_dat, xap_user_id, xap_project_id, name, base_type, data_len, data_prec) values (15, now(), 1, 1, 'Access',            1,   3, 0);
insert into xap_data_type (xap_id, xap_cre_dat, xap_user_id, xap_project_id, name, base_type, data_len, data_prec, enum_id) values (16, now(), 1, 1, 'BaseType',          8,  10, 0, 1);

-- there is a base type "Enumeration"
--  for each enumeration a specific type needs to be defined.
-- there is a type Reference for an attribute pointing to a different object
--    for each class of object a specific type needs to be defined.

--  reference data types can only be defined after the classes have been created.


-- -----------------------------------------------------------------------------
-- XAP Classes
-- -----------------------------------------------------------------------------

select 'XAP Classes';

-- as attributes of a class can be pointers to other classes, all
-- classes are created first, and the class attributes are added later.

insert into xap_class (xap_id, xap_cre_dat, xap_user_id, xap_project_id, name, table_name) values ( 1, now(), 1, 1, 'XAP-User',              'xap_user');

-- create data type "reference to user"
insert into xap_data_type (xap_id, xap_cre_dat, xap_user_id, xap_project_id, name, base_type, data_len, data_prec, class_id) values (19, now(), 1, 1, 'User-Reference',          9,  10, 0, 1);



insert into xap_class (xap_id, xap_cre_dat, xap_user_id, xap_project_id, name, table_name) values ( 2, now(), 1, 1, 'XAP-Person',            'xap_person');

-- create data type "reference to person"
insert into xap_data_type (xap_id, xap_cre_dat, xap_user_id, xap_project_id, name, base_type, data_len, data_prec, class_id) values (20, now(), 1, 1, 'Person-Reference',          9,  10, 0, 2);


			  
			  
insert into xap_class (xap_id, xap_cre_dat, xap_user_id, xap_project_id, name, table_name) values ( 3, now(), 1, 1, 'XAP-Reservation',       'xap_reservation');

-- create data type "reference to reservation"
insert into xap_data_type (xap_id, xap_cre_dat, xap_user_id, xap_project_id, name, base_type, data_len, data_prec, class_id) values (21, now(), 1, 1, 'Reservation-Reference',          9,  10, 0, 3);





insert into xap_class (xap_id, xap_cre_dat, xap_user_id, xap_project_id, name, table_name) values ( 4, now(), 1, 1, 'XAP-Project',           'xap_project');

-- create data type "reference to project"
insert into xap_data_type (xap_id, xap_cre_dat, xap_user_id, xap_project_id, name, base_type, data_len, data_prec, class_id) values (22, now(), 1, 1, 'Project-Reference',          9,  10, 0, 4);





insert into xap_class (xap_id, xap_cre_dat, xap_user_id, xap_project_id, name, table_name) values ( 5, now(), 1, 1, 'XAP-Role',              'xap_role');


-- create data type "reference to person"
insert into xap_data_type (xap_id, xap_cre_dat, xap_user_id, xap_project_id, name, base_type, data_len, data_prec, class_id) values (23, now(), 1, 1, 'Role-Reference',          9,  10, 0, 5);




 
insert into xap_class (xap_id, xap_cre_dat, xap_user_id, xap_project_id, name, table_name) values ( 6, now(), 1, 1, 'XAP-Enumeration',       'xap_enumeration');

-- create data type "reference to enum"
insert into xap_data_type (xap_id, xap_cre_dat, xap_user_id, xap_project_id, name, base_type, data_len, data_prec, class_id) values (24, now(), 1, 1, 'Enumeration-Reference',          9,  10, 0, 6);





insert into xap_class (xap_id, xap_cre_dat, xap_user_id, xap_project_id, name, table_name) values ( 7, now(), 1, 1, 'XAP-Enumeration-Entry', 'xap_enumeration_entry');


-- create data type "reference to enum entry"
insert into xap_data_type (xap_id, xap_cre_dat, xap_user_id, xap_project_id, name, base_type, data_len, data_prec, class_id) values (25, now(), 1, 1, 'EnumEntry-Reference',          9,  10, 0, 7);



insert into xap_class (xap_id, xap_cre_dat, xap_user_id, xap_project_id, name, table_name) values ( 8, now(), 1, 1, 'XAP-Data-Type',         'xap_data_type');


-- create data type "reference to person"
insert into xap_data_type (xap_id, xap_cre_dat, xap_user_id, xap_project_id, name, base_type, data_len, data_prec, class_id) values (26, now(), 1, 1, 'Data-Type-Reference',          9,  10, 0, 8);

                         
insert into xap_class (xap_id, xap_cre_dat, xap_user_id, xap_project_id, name, table_name) values ( 9, now(), 1, 1, 'XAP-Class',             'xap_class');


-- create data type "reference to class"
insert into xap_data_type (xap_id, xap_cre_dat, xap_user_id, xap_project_id, name, base_type, data_len, data_prec, class_id) values (27, now(), 1, 1, 'Class-Reference',          9,  10, 0, 9);



insert into xap_class (xap_id, xap_cre_dat, xap_user_id, xap_project_id, name, table_name) values ( 12, now(), 1, 1, 'XAP-Relation',  'xap_relation');


-- create data type "reference to class"
insert into xap_data_type (xap_id, xap_cre_dat, xap_user_id, xap_project_id, name, base_type, data_len, data_prec, class_id) values (29, now(), 1, 1, 'Relation-Reference',          9,  10, 0, 12);




-- ------------------------------------------------------------------------



insert into xap_class_attribute(xap_cre_dat, xap_user_id, xap_project_id,
                                class_id, sort_id, name, description, data_type) 
                        select now(), 1, 1, 
                                cls.xap_id, 1, 'name', 'login name', dt.xap_id
                        from xap_class cls,
                             xap_data_type dt
                        where cls.name='XAP-User'
                          and dt.name='NameShort';
                          

insert into xap_class_attribute(xap_cre_dat, xap_user_id, xap_project_id,
                                class_id, sort_id, name, description, data_type) 
                        select now(), 1, 1, 
                                cls.xap_id, 2, 'password', 'encrypted password', dt.xap_id
                        from xap_class cls,
                             xap_data_type dt
                        where cls.name='XAP-User'
                          and dt.name='EncryptedPassword';

              
insert into xap_class_attribute(xap_cre_dat, xap_user_id, xap_project_id,
                                class_id, sort_id, name, description, data_type) 
                        select now(), 1, 1, 
                                cls.xap_id, 3, 'person_id', 'person', dt.xap_id
                        from xap_class cls,
                             xap_data_type dt
                        where cls.name='XAP-User'
                          and dt.name='Person-Reference'; 
                          
-- still missing: person_id  ... reference to xap_person
 
/*
insert into xap_reference (xap_cre_dat, xap_user_id, xap_project_id,
                  sort_id,
                  from_class_id,
                  to_class_id,
                  name
                  )
               select now(), 1, 1, 1, dt.xap_id, en.xap_id, 'person_id'
               from xap_class dt,
                    xap_class en
               where dt.name='XAP-User'
                 and en.name='XAP-Person';
*/



-- first_name      varchar(50),
-- last_name       varchar(50),
-- email           varchar(100),

insert into xap_class_attribute(xap_cre_dat, xap_user_id, xap_project_id,
                                class_id, sort_id, name, description, data_type, instance_name) 
                        select now(), 1, 1, 
                                cls.xap_id, 1, 'last_name', 'last name', dt.xap_id, 1
                        from xap_class cls,
                             xap_data_type dt
                        where cls.name='XAP-Person'
                          and dt.name='Name';
                          
                     
insert into xap_class_attribute(xap_cre_dat, xap_user_id, xap_project_id,
                                class_id, sort_id, name, description, data_type, instance_name) 
                        select now(), 1, 1, 
                                cls.xap_id, 2, 'first_name', 'first name', dt.xap_id, 2
                        from xap_class cls,
                             xap_data_type dt
                        where cls.name='XAP-Person'
                          and dt.name='Name';


insert into xap_class_attribute(xap_cre_dat, xap_user_id, xap_project_id,
                                class_id, sort_id, name, description, data_type) 
                        select now(), 1, 1, 
                                cls.xap_id, 3, 'email', 'email', dt.xap_id
                        from xap_class cls,
                             xap_data_type dt
                        where cls.name='XAP-Person'
                          and dt.name='Email';

                                               

insert into xap_class_attribute(xap_cre_dat, xap_user_id, xap_project_id,
                                class_id, sort_id, name, description, data_type) 
                        select now(), 1, 1, 
                                cls.xap_id, 1, 'table_name', 'table_name', dt.xap_id
                        from xap_class cls,
                             xap_data_type dt
                        where cls.name='XAP-Reservation'
                          and dt.name='Name';




insert into xap_class_attribute(xap_cre_dat, xap_user_id, xap_project_id,
                                class_id, sort_id, name, description, data_type, instance_name) 
                        select now(), 1, 1, 
                                cls.xap_id, 1, 'name', 'name', dt.xap_id, 1
                        from xap_class cls,
                             xap_data_type dt
                        where cls.name='XAP-Project'
                          and dt.name='Name';
			  
insert into xap_class_attribute(xap_cre_dat, xap_user_id, xap_project_id,
                                class_id, sort_id, name, description, data_type) 
                        select now(), 1, 1, 
                                cls.xap_id, 2, 'description', 'description', dt.xap_id
                        from xap_class cls,
                             xap_data_type dt
                        where cls.name='XAP-Project'
                          and dt.name='Description';


insert into xap_class_attribute(xap_cre_dat, xap_user_id, xap_project_id,
                                class_id, sort_id, name, description, data_type, instance_name) 
                        select now(), 1, 1, 
                                cls.xap_id, 1, 'name', 'name', dt.xap_id, 1
                        from xap_class cls,
                             xap_data_type dt
                        where cls.name='XAP-Role'
                          and dt.name='Name';
			  
insert into xap_class_attribute(xap_cre_dat, xap_user_id, xap_project_id,
                                class_id, sort_id, name, description, data_type) 
                        select now(), 1, 1, 
                                cls.xap_id, 2, 'description', 'description', dt.xap_id
                        from xap_class cls,
                             xap_data_type dt
                        where cls.name='XAP-Role'
                          and dt.name='Description';




insert into xap_class_attribute(xap_cre_dat, xap_user_id, xap_project_id,
                                class_id, sort_id, name, description, data_type, instance_name) 
                        select now(), 1, 1, 
                                cls.xap_id, 1, 'name', 'name', dt.xap_id, 1
                        from xap_class cls,
                             xap_data_type dt
                        where cls.name='XAP-Enumeration'
                          and dt.name='Name';
			  
insert into xap_class_attribute(xap_cre_dat, xap_user_id, xap_project_id,
                                class_id, sort_id, name, description, data_type) 
                        select now(), 1, 1, 
                                cls.xap_id, 2, 'description', 'description', dt.xap_id
                        from xap_class cls,
                             xap_data_type dt
                        where cls.name='XAP-Enumeration'
                          and dt.name='Description';


                          
                   
insert into xap_class_attribute(xap_cre_dat, xap_user_id, xap_project_id,
                                class_id, sort_id, name, description, data_type, instance_name) 
                        select now(), 1, 1, 
                                cls.xap_id, 1, 'enumeration_id', 'enumeration', dt.xap_id, 1
                        from xap_class cls,
                             xap_data_type dt
                        where cls.name='XAP-Enumeration-Entry'
                          and dt.name='Enumeration-Reference';                          

                                                 
insert into xap_class_attribute(xap_cre_dat, xap_user_id, xap_project_id,
                                class_id, sort_id, name, description, data_type) 
                        select now(), 1, 1, 
                                cls.xap_id, 2, 'entry_id', 'enumeration id', dt.xap_id
                        from xap_class cls,
                             xap_data_type dt
                        where cls.name='XAP-Enumeration-Entry'
                          and dt.name='I10'; 

                          
insert into xap_class_attribute(xap_cre_dat, xap_user_id, xap_project_id,
                                class_id, sort_id, name, description, data_type) 
                        select now(), 1, 1, 
                                cls.xap_id, 3, 'entry_text', 'entry text', dt.xap_id
                        from xap_class cls,
                             xap_data_type dt
                        where cls.name='XAP-Enumeration-Entry'
                          and dt.name='Description';  

insert into xap_class_attribute(xap_cre_dat, xap_user_id, xap_project_id,
                                class_id, sort_id, name, description, data_type) 
                        select now(), 1, 1, 
                                cls.xap_id, 4, 'description', 'description', dt.xap_id
                        from xap_class cls,
                             xap_data_type dt
                        where cls.name='XAP-Enumeration-Entry'
                          and dt.name='Description';

                          



insert into xap_class_attribute(xap_cre_dat, xap_user_id, xap_project_id,
                                class_id, sort_id, name, description, data_type) 
                        select now(), 1, 1, 
                                cls.xap_id, 1, 'name', 'name', dt.xap_id
                        from xap_class cls,
                             xap_data_type dt
                        where cls.name='XAP-Data-Type'
                          and dt.name='Name';


insert into xap_class_attribute(xap_cre_dat, xap_user_id, xap_project_id,
                                class_id, sort_id, name, description, data_type) 
                        select now(), 1, 1, 
                                cls.xap_id, 2, 'base_type', 'base_type', dt.xap_id
                        from xap_class cls,
                             xap_data_type dt
                        where cls.name='XAP-Data-Type'
                          and dt.name='BaseType';


insert into xap_class_attribute(xap_cre_dat, xap_user_id, xap_project_id,
                                class_id, sort_id, name, description, data_type) 
                        select now(), 1, 1, 
                                cls.xap_id, 3, 'data_len', 'data length', dt.xap_id
                        from xap_class cls,
                             xap_data_type dt
                        where cls.name='XAP-Data-Type'
                          and dt.name='I10';
                          
                          
insert into xap_class_attribute(xap_cre_dat, xap_user_id, xap_project_id,
                                class_id, sort_id, name, description, data_type) 
                        select now(), 1, 1, 
                                cls.xap_id, 4, 'data_prec', 'data precision', dt.xap_id
                        from xap_class cls,
                             xap_data_type dt
                        where cls.name='XAP-Data-Type'
                          and dt.name='I10';
                          
 
                        
insert into xap_class_attribute(xap_cre_dat, xap_user_id, xap_project_id,
                                class_id, sort_id, name, description, data_type) 
                        select now(), 1, 1, 
                                cls.xap_id, 5, 'enum_id', 'enumeration id', dt.xap_id
                        from xap_class cls,
                             xap_data_type dt
                        where cls.name='XAP-Data-Type'
                          and dt.name='Enumeration-Reference';
                          
                                               
insert into xap_class_attribute(xap_cre_dat, xap_user_id, xap_project_id,
                                class_id, sort_id, name, description, data_type) 
                        select now(), 1, 1, 
                                cls.xap_id, 6, 'class_id', 'class id', dt.xap_id
                        from xap_class cls,
                             xap_data_type dt
                        where cls.name='XAP-Data-Type'
                          and dt.name='Class-Reference';
                          
                          
                          
                          

  --  is the attribute, which is indicating / referening the enumeration to be used
  --     an attribute or a reference attribute .... ???
/*
insert into xap_class_attribute(xap_cre_dat, xap_user_id, xap_project_id,
                                class_id, sort_id, name, description, data_type) 
                        select now(), 1, 1, 
                                cls.xap_id, 5, 'enum_id', 'enumeration', dt.xap_id
                        from xap_class cls,
                             xap_data_type dt
                        where cls.name='XAP-Data-Type'
                          and dt.name='Enumeration';                          
*/

/*  2013-12-03: to be done TBD:
            remove table xap_references,
            as a reference should be an attribute of a class.
            A basic data type reference must be modelled.
           
           

insert into xap_reference (xap_cre_dat, xap_user_id, xap_project_id,
                  sort_id,
                  from_class_id,
                  to_class_id,
                  name
                  )
               select now(), 1, 1, 1, dt.xap_id, en.xap_id, 'enum_id'
               from xap_class dt,
                    xap_class en
               where dt.name='XAP-Data-Type'
                 and en.name='XAP-Enumeration';
                 
  */                       
 
insert into xap_class_attribute(xap_cre_dat, xap_user_id, xap_project_id,
                                class_id, sort_id, name, description, data_type, instance_name) 
                        select now(), 1, 1, 
                                cls.xap_id, 1, 'name', 'name', dt.xap_id, 1
                        from xap_class cls,
                             xap_data_type dt
                        where cls.name='XAP-Class'
                          and dt.name='Name';
			  
insert into xap_class_attribute(xap_cre_dat, xap_user_id, xap_project_id,
                                class_id, sort_id, name, description, data_type) 
                        select now(), 1, 1, 
                                cls.xap_id, 2, 'table_name', 'table name', dt.xap_id
                        from xap_class cls,
                             xap_data_type dt
                        where cls.name='XAP-Class'
                          and dt.name='Name';
		
insert into xap_class_attribute(xap_cre_dat, xap_user_id, xap_project_id,
                                class_id, sort_id, name, description, data_type) 
                        select now(), 1, 1, 
                                cls.xap_id, 3, 'description', 'description', dt.xap_id
                        from xap_class cls,
                             xap_data_type dt
                        where cls.name='XAP-Class'
                          and dt.name='Description';
			  

insert into xap_class (xap_id, xap_cre_dat, xap_user_id, xap_project_id, name, table_name) values (10, now(), 1, 1, 'XAP-Class-Attribute',   'xap_class_attribute');

-- create data type "reference to class attribute"
insert into xap_data_type (xap_id, xap_cre_dat, xap_user_id, xap_project_id, name, base_type, data_len, data_prec, class_id) values (28, now(), 1, 1, 'Class-Attribute-Reference',          9,  10, 0, 10);

                         
insert into xap_class_attribute(xap_cre_dat, xap_user_id, xap_project_id,
                                class_id, sort_id, name, description, data_type) 
                        select now(), 1, 1, 
                                cls.xap_id, 1, 'class_id', 'description', dt.xap_id
                        from xap_class cls,
                             xap_data_type dt
                        where cls.name='XAP-Class-Attribute'
                          and dt.name='Class-Reference';
                          
                                             
insert into xap_class_attribute(xap_cre_dat, xap_user_id, xap_project_id,
                                class_id, sort_id, name, description, data_type) 
                        select now(), 1, 1, 
                                cls.xap_id, 2, 'sort_id', 'sort_id', dt.xap_id
                        from xap_class cls,
                             xap_data_type dt
                        where cls.name='XAP-Class-Attribute'
                          and dt.name='I10';


insert into xap_class_attribute(xap_cre_dat, xap_user_id, xap_project_id,
                                class_id, sort_id, name, description, data_type) 
                        select now(), 1, 1, 
                                cls.xap_id, 3, 'name', 'description', dt.xap_id
                        from xap_class cls,
                             xap_data_type dt
                        where cls.name='XAP-Class-Attribute'
                          and dt.name='Name';
			  
                          
                                             
insert into xap_class_attribute(xap_cre_dat, xap_user_id, xap_project_id,
                                class_id, sort_id, name, description, data_type) 
                        select now(), 1, 1, 
                                cls.xap_id, 4, 'description', 'description', dt.xap_id
                        from xap_class cls,
                             xap_data_type dt
                        where cls.name='XAP-Class-Attribute'
                          and dt.name='Description';
                          
                                           
insert into xap_class_attribute(xap_cre_dat, xap_user_id, xap_project_id,
                                class_id, sort_id, name, description, data_type) 
                        select now(), 1, 1, 
                                cls.xap_id, 5, 'data_type', 'Date Type', dt.xap_id
                        from xap_class cls,
                             xap_data_type dt
                        where cls.name='XAP-Class-Attribute'
                          and dt.name='Data-Type-Reference';
                          
 
                                         
insert into xap_class_attribute(xap_cre_dat, xap_user_id, xap_project_id,
                                class_id, sort_id, name, description, data_type) 
                        select now(), 1, 1, 
                                cls.xap_id, 6, 'not_null', 'not_null', dt.xap_id
                        from xap_class cls,
                             xap_data_type dt
                        where cls.name='XAP-Class-Attribute'
                          and dt.name='Boolean';                          
                          
                                         
insert into xap_class_attribute(xap_cre_dat, xap_user_id, xap_project_id,
                                class_id, sort_id, name, description, data_type) 
                        select now(), 1, 1, 
                                cls.xap_id, 7, 'unique_index_1', 'unique_index_1', dt.xap_id
                        from xap_class cls,
                             xap_data_type dt
                        where cls.name='XAP-Class-Attribute'
                          and dt.name='NameShort';   
                          
                        
                                         
insert into xap_class_attribute(xap_cre_dat, xap_user_id, xap_project_id,
                                class_id, sort_id, name, description, data_type) 
                        select now(), 1, 1, 
                                cls.xap_id, 8, 'unique_index_2', 'unique_index_2', dt.xap_id
                        from xap_class cls,
                             xap_data_type dt
                        where cls.name='XAP-Class-Attribute'
                          and dt.name='NameShort';  
                          
                        
                                         
insert into xap_class_attribute(xap_cre_dat, xap_user_id, xap_project_id,
                                class_id, sort_id, name, description, data_type) 
                        select now(), 1, 1, 
                                cls.xap_id, 9, 'unique_index_3', 'unique_index_3', dt.xap_id
                        from xap_class cls,
                             xap_data_type dt
                        where cls.name='XAP-Class-Attribute'
                          and dt.name='NameShort';   
  
                                         
insert into xap_class_attribute(xap_cre_dat, xap_user_id, xap_project_id,
                                class_id, sort_id, name, description, data_type) 
                        select now(), 1, 1, 
                                cls.xap_id, 10, 'instance_name', 'instance_name', dt.xap_id
                        from xap_class cls,
                             xap_data_type dt
                        where cls.name='XAP-Class-Attribute'
                          and dt.name='I10';   
                          
                          
			  
/*  TBD  2013-12-04 
insert into xap_reference (xap_cre_dat, xap_user_id, xap_project_id,
                  sort_id,
                  from_class_id,
                  to_class_id,
                  name
                  )
               select now(), 1, 1, 1, dt.xap_id, en.xap_id, 'data_type'
               from xap_class dt,
                    xap_class en
               where dt.name='XAP-Class-Attribute'
                 and en.name='XAP-Class';
                 
insert into xap_reference (xap_cre_dat, xap_user_id, xap_project_id,
                  sort_id,
                  from_class_id,
                  to_class_id,
                  name
                  )
               select now(), 1, 1, 1, dt.xap_id, en.xap_id, 'data_type'
               from xap_class dt,
                    xap_class en
               where dt.name='XAP-Class-Attribute'
                 and en.name='XAP-Data-Type';                          
*/                          
                          
-- -------------------
--  Associations 
-- -------------------


insert into xap_class_attribute(xap_cre_dat, xap_user_id, xap_project_id,
                                class_id, sort_id, name, description, data_type) 
                        select now(), 1, 1, 
                                cls.xap_id, 1, 'name', 'name', dt.xap_id
                        from xap_class cls,
                             xap_data_type dt
                        where cls.name='XAP-Relation'
                          and dt.name='NameShort';

insert into xap_class_attribute(xap_cre_dat, xap_user_id, xap_project_id,
                                class_id, sort_id, name, description, data_type) 
                        select now(), 1, 1, 
                                cls.xap_id, 2, 'description', 'description', dt.xap_id
                        from xap_class cls,
                             xap_data_type dt
                        where cls.name='XAP-Relation'
                          and dt.name='Description';

insert into xap_class_attribute(xap_cre_dat, xap_user_id, xap_project_id,
                                class_id, sort_id, name, description, data_type) 
                        select now(), 1, 1, 
                                cls.xap_id, 3, 'card_from_min', 'card_from_min', dt.xap_id
                        from xap_class cls,
                             xap_data_type dt
                        where cls.name='XAP-Relation'
                          and dt.name='I10';


                          
insert into xap_class_attribute(xap_cre_dat, xap_user_id, xap_project_id,
                                class_id, sort_id, name, description, data_type) 
                        select now(), 1, 1, 
                                cls.xap_id, 4, 'card_from_max', 'card_from_max', dt.xap_id
                        from xap_class cls,
                             xap_data_type dt
                        where cls.name='XAP-Relation'
                          and dt.name='I10';


                         
insert into xap_class_attribute(xap_cre_dat, xap_user_id, xap_project_id,
                                class_id, sort_id, name, description, data_type) 
                        select now(), 1, 1, 
                                cls.xap_id, 5, 'from_class_id', 'from_class_id', dt.xap_id
                        from xap_class cls,
                             xap_data_type dt
                        where cls.name='XAP-Relation'
                          and dt.name='Class-Reference';

                         
insert into xap_class_attribute(xap_cre_dat, xap_user_id, xap_project_id,
                                class_id, sort_id, name, description, data_type) 
                        select now(), 1, 1, 
                                cls.xap_id, 6, 'to_class_id', 'to_class_id', dt.xap_id
                        from xap_class cls,
                             xap_data_type dt
                        where cls.name='XAP-Relation'
                          and dt.name='Class-Reference';
                          



/*
create table xap_relation
(--
 from_class_id int not null,
 to_class_id   int null,
 --
 name        varchar(50) not null,
 table_name  varchar(50),
 description varchar(255),
 --
 is_directed boolean, 
 --
 card_from_min  int null,  -- just for data consistency checks
 card_from_max  int null,  -- just for data consistency checks
 --
 card_to_min  int null,  -- just for data consistency checks
 card_to_max  int null,  -- just for data consistency checks
 --
 unique key(from_class_id, to_class_id, name),
 foreign key (from_class_id)     references xap_class(xap_id)     on delete cascade,
 foreign key (to_class_id)       references xap_class(xap_id)     on delete cascade

);
*/
