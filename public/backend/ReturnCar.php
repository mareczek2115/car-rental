<?php
    include('DB_Connection.php');

    date_default_timezone_set("Europe/Warsaw");

    $data = json_decode(file_get_contents("php://input", true));

    $query = "SELECT account_id, date_of_expected_return, account_type FROM `active_reservations` INNER JOIN `users` ON active_reservations.account_id = users.id WHERE active_reservations.id=$data->id";
    $result = $conn->query($query);

    $account_id = "";
    $account_type = "";
    $date = "";
    $time = "";
    while($row = mysqli_fetch_assoc($result)){
        $date = substr($row["date_of_expected_return"], 0, 10);
        $time = substr($row["date_of_expected_return"], 11);
        $account_id = $row["account_id"];
        $account_type = $row["account_type"];
    }

    $origin = new DateTime(date("d-m-Y"));
    $target = new DateTime($date);
    $time = $target->diff($origin);

    $user_status = "";

    $query = "UPDATE `active_reservations` SET date_of_expected_return='".date("Y-m-d H:i:s")."' WHERE id=$data->id";
    $conn->query($query);

    $query = "DELETE FROM `active_reservations` WHERE id=$data->id";
    $conn->query($query);

    if($account_type != "administrator"){
        if(intval($time->format('%R%a')) > 0){
            $query = "UPDATE `users` SET account_status='banned' WHERE id=$account_id";
            $conn->query($query);
            $conn->close();
            echo json_encode(array("result" => "account_banned"));
        } else if(intval($time->format('%R%a')) == 0){
            if($time > date("H:i:s")){
                $query = "UPDATE `users` SET account_status='banned' WHERE id=$account_id";
                $conn->query($query);
                $conn->close();
                echo json_encode(array("result" => "account_banned"));
            }
        } else{
            $conn->close();
            echo json_encode(array("result" => "success"));
        }
    } else{
        $conn->close();
        echo json_encode(array("result" => "success"));
    }