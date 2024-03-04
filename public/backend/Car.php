<?php
    include('DB_Connection.php');

    $data = json_decode(file_get_contents("php://input", true));

    $query = "SELECT * FROM `cars` WHERE `id`=$data->id";

    $result = $conn->query($query);

    $conn->close();

    while($row = mysqli_fetch_assoc($result)){
        echo json_encode(array("brand" => $row["brand"], "model" => $row["model"], "transmission" => $row["transmission"], "fuel_type" => $row["fuel_type"], "average_fuel_consumption" => $row["average_fuel_consumption"], "number_of_doors" => $row["number_of_doors"], "price_per_hour" => $row["price_per_hour"]));
    }