<?php
    include('DB_Connection.php');

    $data = json_decode(file_get_contents("php://input", true));

    $query = "SELECT awaiting_reservations.id, brand, model, date_of_rent_start, date_of_expected_return, status FROM `awaiting_reservations` INNER JOIN `cars` ON awaiting_reservations.car_id = cars.id INNER JOIN `users` ON awaiting_reservations.account_id = users.id WHERE users.email_address='$data->userEmail' ";
    $awaiting_reservations = $conn->query($query);

    $query = "SELECT active_reservations.id, brand, model, date_of_rent_start, date_of_expected_return, status FROM `active_reservations` INNER JOIN `cars` ON active_reservations.car_id = cars.id INNER JOIN `users` ON active_reservations.account_id = users.id WHERE users.email_address='$data->userEmail' ";
    $active_reservations = $conn->query($query);

    $query = "SELECT brand, model, date_of_rent, date_of_return FROM `archival_reservations` INNER JOIN `cars` ON archival_reservations.car_id = cars.id INNER JOIN `users` ON archival_reservations.account_id = users.id WHERE users.email_address='$data->userEmail'";
    $archival_reservations = $conn->query($query);

    $conn->close();

    $arr = array();
    $arr2 = array();
    $arr3 = array();
    $arr4 = array();


    while($row = mysqli_fetch_assoc($awaiting_reservations)){
        array_push($arr2, array("id" => $row["id"], "brand" => $row["brand"], "model" => $row["model"], "date_of_rent_start" => $row["date_of_rent_start"], "date_of_expected_return" => $row["date_of_expected_return"], "status" => $row["status"]));
    }

    while($row = mysqli_fetch_assoc($active_reservations)){
        array_push($arr3, array("id" => $row["id"], "brand" => $row["brand"], "model" => $row["model"], "date_of_rent_start" => $row["date_of_rent_start"], "date_of_expected_return" => $row["date_of_expected_return"], "status" => $row["status"]));
    }

    while($row = mysqli_fetch_assoc($archival_reservations)){
        array_push($arr4, array("brand" => $row["brand"], "model" => $row["model"], "date_of_rent" => $row["date_of_rent"], "date_of_return" => $row["date_of_return"]));
    }

    array_push($arr, array("awaiting_reservations" => $arr2, "active_reservations" => $arr3, "archival_reservations" => $arr4));

    echo json_encode($arr);