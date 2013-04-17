-- SQL example structure

CREATE TABLE `config` (
  `agent` bigint(10) NOT NULL,
  `queue` varchar(20) NOT NULL,
  `mode` varchar(10) NOT NULL,
  `penalty` int(11) NOT NULL,
  UNIQUE KEY `agent_queue` (`agent`,`queue`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `config_agent` (
  `agent` bigint(20) NOT NULL,
  `name` varchar(128) DEFAULT NULL,
  PRIMARY KEY (`agent`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `config_queue` (
  `queue` varchar(20) NOT NULL,
  `description` varchar(128) DEFAULT NULL,
  `readable` varchar(11) NOT NULL,
  PRIMARY KEY (`queue`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
