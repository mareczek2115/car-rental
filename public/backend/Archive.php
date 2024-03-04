<?php
    include('DB_Connection.php');

    $data = json_decode(file_get_contents("php://input", true));

    $query = "SELECT brand, model, name, surname, email_address, date_of_rent, date_of_return FROM `archival_reservations` INNER JOIN `cars` ON archival_reservations.car_id = cars.id INNER JOIN `users` ON archival_reservations.account_id = users.id ORDER BY $data->order";

    $result = $conn->query($query);

    $arr = array();

    while($row = mysqli_fetch_assoc($result)){
        array_push($arr, array("brand" => $row["brand"], "model" => $row["model"], "account" => $row["name"]." ".$row["surname"], "email_address" => $row["email_address"], "date_of_rent" => $row["date_of_rent"], "date_of_return" => $row["date_of_return"]));
    }

    $conn->close();

    echo json_encode($arr);