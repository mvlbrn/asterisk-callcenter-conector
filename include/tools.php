<?php
function agent_name($channel) {
    global $asterisk_url;
    @list ($name,$number) = preg_split("#/#", $channel);
    $lines = file($asterisk_url."/agents.php");
    foreach ($lines as $line_num => $line) {
        list ($lnumber, $lname) = preg_split("/,/",$line,2);
        if(trim($lnumber)==trim($number)) {
            return "$lnumber - $lname";
        }
    }
    return $channel;
}

function queue_name($channel) {
    global $asterisk_url;
    $number=$channel;
    $lines = file($asterisk_url."/queues.php");
    foreach ($lines as $line_num => $line) {
        list ($lnumber, $lname) = preg_split("/,/",$line,2);
        if(trim($lnumber)==trim($number)) {
            return "$lnumber - $lname";
        }
    }
    return $channel;
}

function toTime($value) {
    $v = $value;
    $result="";

    //Days
    if (floor($v / 86400) > 0) {
        $result .= floor($v / 86400).".";
        $v = $v % 86400;
    }

    //Hours
    $result .= "".str_pad(floor($v / 3600), 2, '0', STR_PAD_LEFT).":";
    $v = $v % 3600;

    //Minutes
    $result .= "".str_pad(floor($v / 60), 2, '0', STR_PAD_LEFT).":";
    $v = $v % 60;

    //Seconds
    $result .= str_pad($v, 2, '0', STR_PAD_LEFT);

    return $result;
}

function inc(&$value, $increment=1) {
    if (isset($value))
        $value+=$increment;
    else
        $value=$increment;
    return $value;
}

function purify($value) {
    return preg_replace('/[^%a-zA-z0-9а-яА-Я _-]/','',$value);
}
?>
