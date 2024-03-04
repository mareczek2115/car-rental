<?php
    include('DB_Connection.php');

    $query = "SELECT * FROM `cars` ORDER BY `brand`";

    $result = $conn->query($query);

    $arr = array();

    while($row = mysqli_fetch_assoc($result)){
        array_push($arr, array("id" => $row["id"], "brand" => $row["brand"], "model" => $row["model"], "transmission" => $row["transmission"], "fuel_type" => $row["fuel_type"], "average_fuel_consumption" => $row["average_fuel_consumption"], "number_of_doors" => $row["number_of_doors"]));
    }

    $conn->close();

    echo json_encode($arr);