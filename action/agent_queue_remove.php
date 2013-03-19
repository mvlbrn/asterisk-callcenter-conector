<?php
    try {
        $sql = "DELETE FROM `config` WHERE `agent`=:agent AND `queue`=:queue";
        $STH = $DBH->prepare($sql);
        $STH->bindValue(":agent", purify($_REQUEST['agent']), PDO::PARAM_INT);
        $STH->bindValue(":queue", purify($_REQUEST['queue']), PDO::PARAM_STR);
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