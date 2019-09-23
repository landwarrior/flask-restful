grant all privileges on *.* to myaccount@'%' identified by 'myaccount' with grant option;
grant all privileges on *.* to myaccount@localhost identified by 'myaccount' with grant option;

CREATE TABLE IF NOT EXISTS users (
  user_id int(11) NOT NULL,
  user_name varchar(32) NOT NULL,
  group_id int(11) DEFAULT NULL,
  ins_date datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  upd_date datetime DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (user_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS groups (
  group_id int(11) NOT NULL,
  group_name varchar(32) NOT NULL,
  ins_date datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  upd_date datetime DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (group_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
