-- --------------------------------------------------------
-- Host:                         127.0.0.1
-- Server version:               5.5.14 - MySQL Community Server (GPL)
-- Server OS:                    Win32
-- HeidiSQL Version:             9.3.0.4984
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8mb4 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;

-- Dumping database structure for citruspay
CREATE DATABASE IF NOT EXISTS `citruspay` /*!40100 DEFAULT CHARACTER SET latin1 */;
USE `citruspay`;


-- Dumping structure for procedure citruspay.1_migrate_umuser-wallet(one to one)
DELIMITER //
CREATE DEFINER=`root`@`localhost` PROCEDURE `1_migrate_umuser-wallet(one to one)`()
    MODIFIES SQL DATA
BEGIN
declare fname varchar(255);
declare lname varchar(255);
declare mobile varchar(16);
declare email varchar(255);
declare account_type varchar(20);
declare account_status varchar(20);
declare verified_mobile varchar (255);
declare pass_reset bit;
declare passwd varchar(255);
declare is_passwd_system_gen bit;
declare uuid varchar(40);
declare password_reset_uuid varchar(40);
declare deleted int(11);
declare consumer_flag varchar(255);
declare user_type varchar(255);
declare done int default 0;

declare umuser_cursor cursor for select
citruspay.con_consumer_detail.first_name,
citruspay.con_consumer_detail.last_name,
citruspay.usr_cpuser_detail.mobile,
citruspay.usr_cpuser_detail.email,
citruspay.usr_cpuser_detail.deleted,
y.consumer_flag,
citruspay.usr_cpuser_detail.verified_mobile,
citruspay.usr_cpuser.pass_reset,
citruspay.usr_cpuser.password,
citruspay.usr_cpuser.is_password_system_generated, 
citruspay.usr_cpuser_detail.uuid as uuid_search, 
citruspay.usr_cpuser.uuid as password_reset_uuid
from
(((select con_consumer.consumer_detail,con_consumer.cp_user,con_consumer.consumer_flag
	from con_consumer
	group by con_consumer.cp_user
	having count(con_consumer.id)=1
		)y
		inner join con_consumer_detail   on
		y.consumer_detail=con_consumer_detail.id
	)
	inner join usr_cpuser  on
	y.cp_user=usr_cpuser.id
)inner join usr_cpuser_detail  on
usr_cpuser_detail.id=usr_cpuser.cp_user_detail
where usr_cpuser_detail.verified_mobile is not null
;

declare exit handler for not found set done= 1;
open umuser_cursor;
read_loop: LOOP

if done then
leave read_loop;
end if;

fetch umuser_cursor into fname,lname,mobile,email,deleted,consumer_flag,
verified_mobile,pass_reset,passwd,is_passwd_system_gen,uuid,password_reset_uuid;

if deleted =1 then
set  account_status='DELETED';
elseif(deleted=0 and consumer_flag='ENABLED') then
set account_status='ENABLED';
elseif (deleted=0 and consumer_flag='SUSPENDED') then
set account_status='SUSPENDED';
end if;

set account_type ='WALLET';
set user_type = 'CONSUMER';

insert into um_db.um_user
(um_db.um_user.first_name,
um_db.um_user.last_name,
um_db.um_user.mobile,
um_db.um_user.email,
um_db.um_user.account_type,
um_db.um_user.account_status,
um_db.um_user.user_type,
um_db.um_user.verified_mobile,
um_db.um_user.password_reset,
um_db.um_user.password,
um_db.um_user.is_password_system_generated,
um_db.um_user.uuid,
um_db.um_user.password_reset_uuid)
values
(fname,
lname,
mobile,
email,
account_type,
account_status,
user_type,
verified_mobile,
pass_reset,
passwd,
is_passwd_system_gen,
uuid,
password_reset_uuid);
end loop;
close umuser_cursor;
END//
DELIMITER ;


-- Dumping structure for procedure citruspay.2_migrate_umuser-basic(one to one)
DELIMITER //
CREATE DEFINER=`root`@`localhost` PROCEDURE `2_migrate_umuser-basic(one to one)`()
    MODIFIES SQL DATA
BEGIN
declare fname varchar(255);
declare lname varchar(255);
declare mobile varchar(16);
declare email varchar(255);
declare account_type varchar(20);
declare account_status varchar(20);
declare verified_mobile varchar (255);
declare pass_reset bit;
declare passwd varchar(255);
declare is_passwd_system_gen bit;
declare uuid varchar(40);
declare password_reset_uuid varchar(40);
declare deleted int(11);
declare consumer_flag varchar(255);
declare user_type varchar(255);
declare done int default 0;

declare umuser_cursor cursor for select
citruspay.con_consumer_detail.first_name,
citruspay.con_consumer_detail.last_name,
citruspay.usr_cpuser_detail.mobile,
citruspay.usr_cpuser_detail.email,
citruspay.usr_cpuser_detail.deleted,
y.consumer_flag,
citruspay.usr_cpuser_detail.verified_mobile,
citruspay.usr_cpuser.pass_reset,
citruspay.usr_cpuser.password,
citruspay.usr_cpuser.is_password_system_generated, 
citruspay.usr_cpuser_detail.uuid as uuid_search, 
citruspay.usr_cpuser.uuid as password_reset_uuid
from
(((select con_consumer.consumer_detail,con_consumer.cp_user,con_consumer.consumer_flag
	from con_consumer
	group by con_consumer.cp_user
	having count(con_consumer.id)=1
		)y
		inner join con_consumer_detail   on
		y.consumer_detail=con_consumer_detail.id
	)
	inner join usr_cpuser  on
	y.cp_user=usr_cpuser.id
)inner join usr_cpuser_detail  on
usr_cpuser_detail.id=usr_cpuser.cp_user_detail
where usr_cpuser_detail.verified_mobile is null
;

declare exit handler for not found set done= 1;
open umuser_cursor;
read_loop: LOOP

if done then
leave read_loop;
end if;

fetch umuser_cursor into fname,lname,mobile,email,deleted,consumer_flag,
verified_mobile,pass_reset,passwd,is_passwd_system_gen,uuid,password_reset_uuid;

if deleted =1 then
set  account_status='DELETED';
elseif(deleted=0 and consumer_flag='ENABLED') then
set account_status='ENABLED';
elseif (deleted=0 and consumer_flag='SUSPENDED') then
set account_status='SUSPENDED';
end if;

set account_type ='BASIC';
set user_type = 'CONSUMER';

insert into um_db.um_user
(um_db.um_user.first_name,
um_db.um_user.last_name,
um_db.um_user.mobile,
um_db.um_user.email,
um_db.um_user.account_type,
um_db.um_user.account_status,
um_db.um_user.user_type,
um_db.um_user.verified_mobile,
um_db.um_user.password_reset,
um_db.um_user.password,
um_db.um_user.is_password_system_generated,
um_db.um_user.uuid,
um_db.um_user.password_reset_uuid)
values
(fname,
lname,
mobile,
email,
account_type,
account_status,
user_type,
verified_mobile,
pass_reset,
passwd,
is_passwd_system_gen,
uuid,
password_reset_uuid);
end loop;
close umuser_cursor;
END//
DELIMITER ;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
