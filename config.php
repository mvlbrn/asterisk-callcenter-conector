<?php

require("include/tools.php");
require("include/config.php");

$db_local=$db['asterisk-ro'];

try {
    $DBH = new PDO("mysql:host={$db_local['dbhost']};dbname={$db_local['dbname']}", $db_local['dbuser'], $db_local['dbpass'], array(PDO::MYSQL_ATTR_INIT_COMMAND => "SET NAMES utf8"));
    $DBH->setAttribute( PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION );
    $sql = "SELECT `config`.*, `description`, `readable` FROM `config` LEFT JOIN `config_queue` ON `config`.`queue` = `config_queue`.`queue` WHERE `agent`=:agent ORDER BY `queue`;";
    $STH = $DBH->prepare($sql);
    $STH->bindValue(":agent", purify($_REQUEST['agent']), PDO::PARAM_INT);
    $STH->execute();
    $STH->setFetchMode(PDO::FETCH_ASSOC);
    print('<?xml version="1.0" encoding="UTF-8"?>'."\n");
    print('<data>'."\n");
    //print ($STH->queryString." : ".$STH->rowCount()."\n");

    while($row = $STH->fetch()) {
        print('<element>'."\n");
        print('<queue>'.$row['queue'].'</queue>'."\n");
        print('<mode>'.$row['mode'].'</mode>'."\n");
        print('<penalty>'.$row['penalty'].'</penalty>'."\n");
        print('<readable>'.$row['readable'].'</readable>'."\n");
        print('<description>'.$row['description'].'</description>'."\n");
        print('</element>'."\n");
    }
    print('</data>'."\n");

}
catch(PDOException $e) {
    echo $e->getMessage();
}
$DBH = null;
?>
