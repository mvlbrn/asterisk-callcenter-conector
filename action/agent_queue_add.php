<?php
    try {
        $sql = "INSERT INTO `config` (`agent`, `queue`, `mode`, `penalty`) VALUES (:agent, :queue, :mode, 0) ON DUPLICATE KEY UPDATE `mode`=:mode";
        $STH = $DBH->prepare($sql);
        $STH->bindValue(":agent", purify($_REQUEST['agent']), PDO::PARAM_INT);
        $STH->bindValue(":queue", purify($_REQUEST['queue']), PDO::PARAM_STR);
        $STH->bindValue(":mode", purify($_REQUEST['mode']), PDO::PARAM_STR);
        $STH->execute();
    }
    catch(PDOException $e) {
        echo $e->getMessage();
    }
    print("<h2>Сделано</h2>");
?>
<script language = 'javascript'>
    document.location.href='?action=agent_show&agent=<?php print($agent); ?>';
</script>