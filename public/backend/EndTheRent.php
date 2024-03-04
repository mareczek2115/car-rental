<?php
    include('DB_Connection.php');

    $data = json_decode(file_get_contents("php://input", true));

    $query = "DELETE FROM `active_reservations` WHERE id=$data->id";

    $conn->query($query);

    $conn->close();

    echo json_encode(array("result" => "success"));