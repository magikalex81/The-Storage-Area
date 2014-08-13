USE postfix;
CREATE TABLE admin (
  username varchar(255) NOT NULL default '',
  password varchar(255) NOT NULL default '',
  created datetime NOT NULL default '0000-00-00 00:00:00',
  modified datetime NOT NULL default '0000-00-00 00:00:00',
  active tinyint(1) NOT NULL default '1',
  superadmin tinyint(1) NOT NULL,
  PRIMARY KEY  (username)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COMMENT='Postfix Admin - Virtual Admins';

#
# Table structure for table alias
#
CREATE TABLE alias (
  address varchar(255) NOT NULL default '',
  goto text NOT NULL,
  domain varchar(255) NOT NULL default '',
  created datetime NOT NULL default '0000-00-00 00:00:00',
  modified datetime NOT NULL default '0000-00-00 00:00:00',
  active tinyint(1) NOT NULL default '1',
  PRIMARY KEY  (address)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COMMENT='Postfix Admin - Virtual Aliases';

# 
# Table structure for table `alias_domain`
# 

CREATE TABLE alias_domain (
  alias_domain varchar(255) NOT NULL default '',
  target_domain varchar(255) NOT NULL default '',
  created datetime NOT NULL default '0000-00-00 00:00:00',
  modified datetime NOT NULL default '0000-00-00 00:00:00',
  active tinyint(1) NOT NULL default '1',
  PRIMARY KEY  (alias_domain),
  KEY active (active),
  KEY target_domain (target_domain)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COMMENT='Postfix Admin - Domain Aliases';

#
# Table structure for table domain
#
CREATE TABLE domain (
  domain varchar(255) NOT NULL default '',
  description varchar(255) character set utf8 collate utf8_unicode_ci NOT NULL,
  aliases int(10) NOT NULL default '0',
  rcpts int(10) NOT NULL DEFAULT '-1',
  mailboxes int(10) NOT NULL default '0',
  maxquota bigint(20) NOT NULL default '0',
  quota bigint(20) NOT NULL default '0',
  transport varchar(255) default NULL,
  backupmx tinyint(1) NOT NULL default '0',
  created datetime NOT NULL default '0000-00-00 00:00:00',
  modified datetime NOT NULL default '0000-00-00 00:00:00',
  active tinyint(1) NOT NULL default '1',
  transport_relay varchar(255) DEFAULT NULL,
  transport_port varchar(10) NOT NULL,
  verify varchar(255) NOT NULL,
  imap_server varchar(255) NOT NULL,
  relayhost varchar(255) DEFAULT NULL,
  PRIMARY KEY  (domain)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COMMENT='Postfix Admin - Virtual Domains';
#
# Table structure for table domain_admins
#
CREATE TABLE domain_admins (
  username varchar(255) NOT NULL default '',
  domain varchar(255) NOT NULL default '',
  created datetime NOT NULL default '0000-00-00 00:00:00',
  active tinyint(1) NOT NULL default '1',
  KEY username (username)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COMMENT='Postfix Admin - Domain Admins';

# 
# Table structure for table `fetchmail`
# 

CREATE TABLE fetchmail (
  id int(11) unsigned NOT NULL auto_increment,
  mailbox varchar(255) NOT NULL default '',
  src_server varchar(255) NOT NULL default '',
  src_auth enum('password','kerberos_v5','kerberos','kerberos_v4','gssapi','cram-md5','otp','ntlm','msn','ssh','any') default NULL,
  src_user varchar(255) NOT NULL default '',
  src_password varchar(255) NOT NULL default '',
  src_folder varchar(255) NOT NULL default '',
  poll_time int(11) unsigned NOT NULL default '10',
  fetchall tinyint(1) unsigned NOT NULL default '0',
  keep tinyint(1) unsigned NOT NULL default '0',
  protocol enum('POP3','IMAP','POP2','ETRN','AUTO') default NULL,
  extra_options text,
  returned_text text,
  mda varchar(255) NOT NULL default '',
  date timestamp NOT NULL default CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

#
# Table structure for table log
#
CREATE TABLE log (
  timestamp datetime NOT NULL default '0000-00-00 00:00:00',
  username varchar(255) NOT NULL default '',
  domain varchar(255) NOT NULL default '',
  action varchar(255) NOT NULL default '',
  data varchar(255) NOT NULL default '',
  KEY timestamp (timestamp),
  KEY domain_timestamp (domain,timestamp)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COMMENT='Postfix Admin - Log';

#
# Table structure for table mailbox
#
CREATE TABLE mailbox (
  username varchar(255) NOT NULL default '',
  password varchar(255) NOT NULL default '',
  name varchar(255) character set utf8 collate utf8_unicode_ci NOT NULL,
  maildir varchar(255) NOT NULL default '',
  quota bigint(20) NOT NULL default '0',
  local_part varchar(255) NOT NULL,
  domain varchar(255) NOT NULL default '',
  created datetime NOT NULL default '0000-00-00 00:00:00',
  modified datetime NOT NULL default '0000-00-00 00:00:00',
  active tinyint(1) NOT NULL default '1',
  PRIMARY KEY  (username)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COMMENT='Postfix Admin - Virtual Mailboxes';

#
# Table structure for table vacation
#
CREATE TABLE vacation (
  email varchar(255) NOT NULL default '',
  subject varchar(255) character set utf8 collate utf8_unicode_ci NOT NULL,
  body text character set utf8 collate utf8_unicode_ci NOT NULL,
  cache text NOT NULL,
  domain varchar(255) NOT NULL,
  created datetime NOT NULL default '0000-00-00 00:00:00',
  active tinyint(1) NOT NULL default '1',
  PRIMARY KEY  (email),
  KEY email (email)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Postfix Admin - Virtual Vacation';

# vacation_notification table 
 
CREATE TABLE vacation_notification ( 
    on_vacation varchar(255) NOT NULL, 
    notified varchar(255) NOT NULL, 
    notified_at timestamp NOT NULL default CURRENT_TIMESTAMP, 
    PRIMARY KEY  (on_vacation,notified)
)  ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Postfix Admin - Virtual Vacation Notifications';
ALTER TABLE vacation_notification
  ADD CONSTRAINT vacation_notification_pkey FOREIGN KEY (on_vacation) REFERENCES vacation (email) ON DELETE CASCADE;

# 
# config table 
#
CREATE TABLE config (
  id int(11) NOT NULL auto_increment,
  name varchar(20) NOT NULL default '',
  value varchar(20) NOT NULL default '',
  PRIMARY KEY  (id),
  UNIQUE KEY name (name)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 COMMENT='PostfixAdmin settings' AUTO_INCREMENT=2 ;

CREATE TABLE relay (
  `address` varchar(255) NOT NULL DEFAULT '',
  `goto` text NOT NULL,
  `domain` varchar(255) NOT NULL DEFAULT '',
  `created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `modified` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `active` tinyint(1) NOT NULL DEFAULT '1',
  `backupmx` tinyint(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (`address`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 ROW_FORMAT=DYNAMIC COMMENT='Postfix Admin - relay';

CREATE TABLE `transport` (
  `destination` varchar(255) NOT NULL,
  `transport` varchar(255) NOT NULL,
  `active` tinyint(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (`destination`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

CREATE TABLE `quota` (
  `username` varchar(255) NOT NULL,
  `path` varchar(100) NOT NULL,
  `current` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`username`,`path`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

CREATE TABLE `quota2` (
  `username` varchar(100) NOT NULL,
  `bytes` bigint(20) NOT NULL DEFAULT '0',
  `messages` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`username`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

INSERT INTO `domain` (`domain`, `description`, `aliases`, `rcpts`, `mailboxes`, `maxquota`, `quota`, `transport`, `backupmx`, `created`, `modified`, `active`, `transport_relay`, `transport_port`, `verify`, `imap_server`) VALUES
('starbridge.org', 'Test Domain', 0, -1, 0, 0, 0, 'dovecot', 0, '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, '', '', 'unlisted', '');
INSERT INTO alias (address,goto,domain) VALUES ('user@starbridge.org', 'user@starbridge.org','starbridge.org');
INSERT INTO alias (address,goto,domain) VALUES ('admin@starbridge.org', 'admin@starbridge.org','starbridge.org');
INSERT INTO alias (address,goto,domain) VALUES ('alias@starbridge.org', 'user@starbridge.org','starbridge.org');
INSERT INTO alias (address,goto,domain) VALUES ('root@starbridge.org', 'admin@starbridge.org','starbridge.org');
INSERT INTO alias (address,goto,domain) VALUES ('postmaster@starbridge.org', 'admin@starbridge.org','starbridge.org');
INSERT INTO mailbox (username,password,name,maildir,domain)  VALUES ('user@starbridge.org','5ebe2294ecd0e0f08eab7690d2a6ee69','Mailbox User','user@starbridge.org/','starbridge.org');
INSERT INTO mailbox (username,password,name,maildir,domain)  VALUES ('admin@starbridge.org','5ebe2294ecd0e0f08eab7690d2a6ee69','Mailbox Admin','admin@starbridge.org/','starbridge.org');
INSERT INTO domain_admins (username, domain, active) VALUES ('@starbridge.org','ALL','1');
INSERT INTO `admin` (`username`, `password`, `created`, `modified`, `active`) VALUES 
('@starbridge.org', '5ebe2294ecd0e0f08eab7690d2a6ee69', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1);
INSERT INTO domain_admins (username, domain, active) VALUES ('@.','ALL','1');
INSERT INTO `admin` (`username`, `password`, `created`, `modified`, `active`) VALUES
('@.', '5ebe2294ecd0e0f08eab7690d2a6ee69', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1);
INSERT INTO config (id, name, value) VALUES 
(1, 'version', '1284');
