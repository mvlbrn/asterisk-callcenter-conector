<?php

require("include/tools.php");
require("include/config.php");

$db_local=$db['asterisk-ro'];

try {
    $DBH = new PDO("mysql:host={$db_local['dbhost']};dbname={$db_local['dbname']}", $db_local['dbuser'], $db_local['dbpass'], array(PDO::MYSQL_ATTR_INIT_COMMAND => "SET NAMES utf8"));
    $DBH->setAttribute( PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION );
    $sql = "SELECT * FROM `config_agent`";
    $STH = $DBH->prepare($sql);
    $STH->execute();
    $STH->setFetchMode(PDO::FETCH_ASSOC);
    while($row = $STH->fetch()) {
        print($row['agent'].', '.$row['name']."\n");
    }
}
catch(PDOException $e) {
    echo $e->getMessage();
}
$DBH = null;
?>
