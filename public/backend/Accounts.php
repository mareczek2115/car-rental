<?php
    include('DB_Connection.php');

    $query = "SELECT `name`, `surname`, `account_type`, `email_address`, `account_status` FROM `users`";

    $result = $conn->query($query);

    $arr = array();

    while($row = mysqli_fetch_assoc($result)){
        array_push($arr, array("name" => $row["name"]." ".$row["surname"], "account_type" => $row["account_type"], "email_address" => $row["email_address"], "account_status" => $row["account_status"]));
    }
    sort($arr);

    $conn->close();

    echo json_encode($arr);