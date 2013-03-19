<?php
// !!!!!!!!!!!!!!!!!!!!!!!!!!!!
// Rename this file to config.php
//
// Credentials for MYSQL database
$db=array (
    'asterisk-ro' => array(            // For ReadOnly
        'dbhost' => '127.0.0.1',
        'dbname' => 'calllog',
        'dbuser' => 'username',
        'dbpass' => 'userpassword',
    ),
    'asterisk-rw' => array(           // For configuration edit
        'dbhost' => '127.0.0.1',
        'dbname' => 'calllog',
        'dbuser' => 'username2',
        'dbpass' => 'userpassword2',
    ),
    );

//From this address with /agents.php and /queues.php lists will be retrived. This may be local or remote path
//f.e.: $asterisk_url='/var/data/connector';
$asterisk_url='http://myasteriskserver.mydoma.in/connector';

//Format is "name, value" per line for both files, for example:
//12345, Record name1
//7534345, Record name2

?>
