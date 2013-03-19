<?php
    $mode = array (
        'A' => 'Автовход',
        'M' => 'Ручной вход',
        'P' => 'Постоянная',
    );
    print("<h2>Оператор ".$agent."</h2>");
    try {
        $sql = "SELECT `config`.*, `description`, `readable` FROM `config` LEFT JOIN `config_queue` ON `config`.`queue` = `config_queue`.`queue` WHERE `agent`=:agent ORDER BY `queue`;";
        $STH = $DBH->prepare($sql);
        $STH->bindValue(":agent", purify($_REQUEST['agent']), PDO::PARAM_INT);
        $STH->execute();
        $STH->setFetchMode(PDO::FETCH_ASSOC);
        print("<table class='table table-striped table-bordered table-condensed'>");
        while($row = $STH->fetch()) {
            print("<tr><td>{$row['queue']} ({$row['readable']})</td><td>{$mode[$row['mode']]}</td> <td>Пенальти {$row['penalty']} <a href='?action=agent_edit_penalty&agent={$agent}&queue={$row['queue']}&penalty=up'>+</a> <a href='?action=agent_edit_penalty&agent={$agent}&queue={$row['queue']}&penalty=down'>-</a> </td> <td><a href='?action=agent_queue_remove&agent={$agent}&queue={$row['queue']}'>удалить</a></td></tr>\n");
        }
        print("</table>");
    }
    catch(PDOException $e) {
        echo $e->getMessage();
    }
    
    //Queues
    print("<h2>Действия</h2>");
    try {
        $sql = "SELECT * FROM `config_queue` ORDER BY `queue`;";
        $STH = $DBH->prepare($sql);
        $STH->execute();
        $STH->setFetchMode(PDO::FETCH_ASSOC);
        print("<table class='table table-striped table-bordered table-condensed'>");
        while($row = $STH->fetch()) {
            print("<tr><td>{$row['queue']} ({$row['readable']})</td><td>");
            foreach ($mode as $id => $value)
                print("<a href='?action=agent_queue_add&agent={$agent}&queue={$row['queue']}&mode=$id'>+ &quot;$value</a><br>");
            print("</td></tr>\n");
        }
        print("</table>");
    }
    catch(PDOException $e) {
        echo $e->getMessage();
    }

?>