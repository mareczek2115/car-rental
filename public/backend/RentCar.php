<?php
    include('DB_Connection.php');

    $data = json_decode(file_get_contents("php://input", true));

    $result = $conn->query("SELECT id FROM `users` WHERE `email_address`='$data->user_mail'");

    $id = '';

    while($row = mysqli_fetch_assoc($result)){
        $id = $row["id"];
    }

    $query = "INSERT INTO `awaiting_reservations` (`car_id`, `account_id`, `date_of_rent_start`, `date_of_expected_return`, `status`) VALUES($data->car_id, $id, '$data->start_date $data->start_hour', '$data->end_date $data->end_hour', 'awaiting')";

    $ver = $conn->query($query);

    $conn->close();

    if(!$ver){
        echo json_encode(array("result" => "error"));
    } else{
        echo json_encode(array("result" => "success"));
    }
