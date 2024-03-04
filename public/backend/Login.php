<?php
    include('DB_Connection.php');

    $data = json_decode(file_get_contents("php://input", true));

    // if(str_contains(strtolower($data->emailAddress), "' or")){
    //     $conn->close();
    //     $arr = array('result' => 'wrong');
    //     echo json_encode($arr);
    // } else{
        $escaped_password = $conn->real_escape_string($data->emailAddress);
        $query = "SELECT `name`, `surname`, `email_address`, `password`, `account_type`, `account_status` FROM `users` WHERE email_address='$escaped_password'";
        $result = $conn->query($query);

        $conn->close();

        $row = $result->fetch_assoc();

        if(!$row){
            // $conn->close();
            $arr = array('result' => 'wrong');
            echo json_encode($arr);
        } else{
            if($row["account_status"] === 'inactive' || $row["account_status"] === 'banned'){
                // $conn->close();
                $arr = array('result' => $row["account_status"]);
                echo json_encode($arr);
            } else if(password_verify($data->password, $row["password"])){
                // $conn->close();
                $arr = array('result' => 'success', 'user' => $row["name"]." ".$row["surname"], 'user_email' => $row["email_address"], 'account_type' => $row["account_type"]);
                echo json_encode($arr);
            } else{
                // $conn->close();
                $arr = array('result' => 'wrong');
                echo json_encode($arr);
            }
        }
    // }