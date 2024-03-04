<?php
    include('DB_Connection.php');

    $data = json_decode(file_get_contents("php://input", true));

    if(count($data->account_type) > 0){
        foreach($data->account_type as $user){
            $query = "UPDATE `users` SET `account_type`='$user->account_type' WHERE `email_address`='$user->email_address'";
            $conn->query($query);
        }
    }

    if(count($data->account_status) > 0){
        foreach($data->account_status as $user){
            $query = "UPDATE `users` SET `account_status`='$user->account_status' WHERE `email_address`='$user->email_address'";
            $conn->query($query);
        }
    }

    $conn->close();

    echo json_encode(array("result" => "success"));