<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <title>Настройка коннекторов</title>
        <link rel="stylesheet" type="text/css" media="all" href="css/bootstrap.min.css">
        <script type="text/javascript" src="js/jquery-1.8.2.min.js"></script>
        <script type="text/javascript" src="js/bootstrap.min.js"></script>
        <script type="text/javascript" src="js/base64.js"></script>
        <script type="text/javascript" src="js/jquery.cookie.js"></script>

    </head>
    <body>
        <div class="container">
            <div class="row">
                <div class="span2">
                    <?php

                    require("include/tools.php");
                    require("include/config.php");

                    $action = @purify($_REQUEST['action']);
                    $agent = @purify($_REQUEST['agent']);
                    $mode = @purify($_REQUEST['mode']);
                    $penalty = @purify($_REQUEST['penalty']);
                    $queue = @purify($_REQUEST['queue']);

                    $db_local=$db['asterisk-rw'];

                    //Connecting
                    try {
                        $DBH = new PDO("mysql:host={$db_local['dbhost']};dbname={$db_local['dbname']}", $db_local['dbuser'], $db_local['dbpass'], array(PDO::MYSQL_ATTR_INIT_COMMAND => "SET NAMES utf8"));
                        $DBH->setAttribute( PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION );
                    }
                    catch(PDOException $e) {
                        echo $e->getMessage();
                    }

                    //Query for operator list
                    print("<center>Операторы</center>");
                    try {
                        $sql = "SELECT DISTINCT `agent` FROM `config` ORDER BY `agent` ASC;";
                        $STH = $DBH->prepare($sql);
                        //$STH->bindValue(":agent", purify($_REQUEST['agent']), PDO::PARAM_INT);
                        $STH->execute();
                        $STH->setFetchMode(PDO::FETCH_ASSOC);
                        while($row = $STH->fetch()) {
                            print("<a href='?action=agent_show&agent={$row['agent']}'>".$row['agent']."</a><br>\n");
                        }
                        print("<form><input class=span2 type=text name='agent'><input type=submit value='Добавить'><input type='hidden' name='action' value='agent_add'></form>");
                    }
                    catch(PDOException $e) {
                        echo $e->getMessage();
                    }
                    ?>
                </div>
                <div class="span10">
                    <?php
                        if (!empty($action) && file_exists("action/".$action.".php"))
                            include("action/".$action.".php");
                        else
                            die("Bad action!");
                    ?>
                </div>
            </div>
        </div>
    </body>
</html>