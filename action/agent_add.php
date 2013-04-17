<?php
    try {
        $sql = "INSERT INTO config VALUES (:agent, 3333, 'M', 0)";
        $STH = $DBH->prepare($sql);
        $STH->bindValue(":agent", purify($_REQUEST['agent']), PDO::PARAM_INT);
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