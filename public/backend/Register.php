<?php
    include('DB_Connection.php');

    $data = json_decode(file_get_contents("php://input", true));

    $email_regex = "/^([a-zA-Z0-9])+(\.[a-zA-Z0-9]+)*@[a-zA-Z0-9]+(\.[a-zA-Z]{2,4})+$/i";

    if(str_contains(strtolower($data->emailAddress), "' or")){
        $conn->close();
        $arr = array('result' => 'wrong');
        echo json_encode($arr);
    } else{
        $query = "SELECT email_address FROM users WHERE email_address='".$data->emailAddress."'";
        $result = $conn->query($query);
        $row = $result->fetch_row();

        if($row){
            $conn->close();
            $arr = array('result' => 'user_exists');
            echo json_encode($arr);
        } else{
            if($data->name != "" && $data->surname != "" && $data->emailAddress != "" && preg_match($email_regex, $data->emailAddress)){
                if($data->password == $data->repeatPassword && $data->password != ""){
                    $encrypted_password = password_hash($data->password, PASSWORD_DEFAULT);
                    $query = "INSERT INTO `users` (`name`, `surname`, `email_address`, `password`, `account_type`, `account_status`) VALUES('$data->name', '$data->surname', '$data->emailAddress', '$encrypted_password', 'klient', 'inactive')";
                    $result = $conn->query($query);

                    $conn->close();
                    $arr = array('result' => 'success');
                    echo json_encode($arr);
                } else{
                    $conn->close();

                    if($data->password == "") $arr = array('result' => 'empty_password');
                    else if($data->password != $data->repeatPassword) $arr = array('result' => 'passwords_unmatch');
                    else $arr = array('result' => 'wrong');

                    echo json_encode($arr);
                }
            } else{
                $conn->close();

                if(!preg_match($email_regex, $data->emailAddress)) $arr = array('result' => 'wrong_email');
                else $arr = array('result' => 'incomplete_data');

                echo json_encode($arr);
            }
        }
    }