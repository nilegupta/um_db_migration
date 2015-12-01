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


-- Dumping structure for procedure citruspay.3_usr_user(usr_user+cpuser+con_consumer)
DELIMITER //
CREATE DEFINER=`root`@`localhost` PROCEDURE `3_usr_user(usr_user+cpuser+con_consumer)`()
    MODIFIES SQL DATA
BEGIN
declare fname varchar(255);
declare lname varchar(255);
declare mobile varchar(16);
declare email varchar(255);
declare account_type varchar(20);
declare account_status varchar(20);
declare user_type varchar(255);
declare verified_mobile varchar (255);
declare pass_reset bit;
declare passwd varchar(255);
declare is_passwd_system_gen bit;
declare uuid varchar(40);
declare password_reset_uuid varchar(40);

declare usr_user_deleted int(11);
declare usr_cpuser_deleted int(11);
declare usr_cpuser_enabled int(11);
declare con_consumer_consumer_flag varchar(255);

declare gender varchar(20);
declare date_of_birth date;

declare created datetime;
declare is_first_login int(11);
declare max_login_attempts int(11);
declare last_modified datetime;

declare address_first_name varchar(255);
declare address_last_name varchar(255);
declare address_street1 varchar(255);
declare address_street2 varchar(255);
declare address_city varchar(255);
declare address_state varchar(255);
declare address_country varchar(255);
declare zip varchar(32);

declare pancard_number varchar(15);
declare aadharcard_number varchar(15);


declare done int default 0;

declare count_id bigint(20) default 0;
declare count_row_completed bigint(20);

declare umuser_cursor cursor for select
citruspay.usr_user.first_name,
citruspay.usr_user.last_name,
citruspay.usr_user.`type`,
citruspay.usr_cpuser_detail.mobile,
citruspay.con_consumer_detail.email,
citruspay.con_consumer.consumer_flag,
citruspay.usr_cpuser.enabled,
citruspay.usr_cpuser.deleted as usr_cpuser_deleted,
citruspay.usr_user.deleted as usr_user_deleted,
citruspay.usr_cpuser_detail.verified_mobile,
citruspay.usr_cpuser.pass_reset,
citruspay.usr_cpuser.`password`,
citruspay.usr_cpuser.is_password_system_generated, 
citruspay.usr_cpuser_detail.`uuid` as uuid_search, 
citruspay.usr_cpuser.`uuid` as password_reset_uuid,

citruspay.con_consumer_detail.sex,
citruspay.con_consumer_detail.date_of_birth,

citruspay.usr_cpuser.created,
citruspay.usr_cpuser.is_first_login,
citruspay.usr_cpuser.max_login_attempts,
citruspay.usr_cpuser_detail.last_modified,

citruspay.con_consumer_detail.first_name as ccd_fn,
citruspay.con_consumer_detail.last_name as ccd_ln,
citruspay.con_consumer_detail.address_street1,
citruspay.con_consumer_detail.address_street2,
citruspay.con_consumer_detail.address_city,
citruspay.con_consumer_detail.address_state,
citruspay.con_consumer_detail.address_country,
citruspay.con_consumer_detail.address_zip,

citruspay.con_consumer_detail.pan_card,
citruspay.con_consumer_detail.aadhar_card
from
usr_user inner join usr_cpuser on
usr_user.cp_user=usr_cpuser.id
inner join usr_cpuser_detail on
usr_cpuser.cp_user_detail=usr_cpuser_detail.id
inner join con_consumer on
con_consumer.cp_user=usr_cpuser.id
inner join con_consumer_detail on
con_consumer.consumer_detail=con_consumer_detail.id;

DECLARE exit handler FOR not found set done= 1;

open umuser_cursor;
read_loop: LOOP

set count_id=count_id+1;

if done then
leave read_loop;
end if;

fetch umuser_cursor into fname,lname,user_type,mobile,email,con_consumer_consumer_flag,
usr_cpuser_enabled,usr_cpuser_deleted,usr_user_deleted,verified_mobile,pass_reset,passwd,
is_passwd_system_gen,uuid,password_reset_uuid,gender,date_of_birth,created,is_first_login,
max_login_attempts,last_modified,address_first_name,address_last_name,address_street1,
address_street2,address_city,address_state,address_country,zip,pancard_number,aadharcard_number;

if (con_consumer_consumer_flag='DELETED' or usr_cpuser_deleted=1 or usr_user_deleted=1) then
set  account_status='DELETED';
elseif(usr_cpuser_enabled=1 and con_consumer_consumer_flag='ENABLED') then
set account_status='ENABLED';
elseif (usr_cpuser_enabled=0 or con_consumer_consumer_flag='SUSPENDED') then
set account_status='SUSPENDED';
end if;

if(verified_mobile !=NULL) then
set account_type ='WALLET';
else
set account_type='BASIC';
end if;

select fname,lname,user_type,account_type,account_status,mobile,email,
con_consumer_consumer_flag,usr_cpuser_enabled,usr_cpuser_deleted,
usr_user_deleted,verified_mobile,pass_reset,passwd,is_passwd_system_gen,
uuid,password_reset_uuid,gender,date_of_birth,created,is_first_login,
max_login_attempts,last_modified,address_first_name,address_last_name,
address_street1,address_street2,address_city,address_state,address_country,
zip,pancard_number,aadharcard_number;



if (! (count_id % 10)) then		#logger
set count_row_completed=count_id;
SELECT 'Row completed:' + count_row_completed;
end if;


end loop;
close umuser_cursor;
END//
DELIMITER ;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
