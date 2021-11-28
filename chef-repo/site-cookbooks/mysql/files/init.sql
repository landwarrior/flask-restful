create user IF NOT EXISTS myaccount@'%' identified by 'myaccount';
create user IF NOT EXISTS myaccount@localhost identified by 'myaccount';
grant all privileges on *.* to myaccount@'%' with grant option;
grant all privileges on *.* to myaccount@localhost with grant option;

CREATE TABLE IF NOT EXISTS mst_users (
  user_id int(11) NOT NULL AUTO_INCREMENT,
  user_name varchar(32) NOT NULL,
  group_id int(11) DEFAULT NULL,
  ins_date datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  upd_date datetime DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (user_id)
);

CREATE TABLE IF NOT EXISTS mst_groups (
  group_id int(11) NOT NULL AUTO_INCREMENT,
  group_name varchar(32) NOT NULL,
  ins_date datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  upd_date datetime DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (group_id)
);
