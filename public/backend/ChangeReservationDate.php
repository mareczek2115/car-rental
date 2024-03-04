<?php
    include('DB_Connection.php');

    $data = json_decode(file_get_contents("php://input", true));

    $table = $data->table."_reservations";

    $query;

    if($data->column == 'start'){
        $query = "UPDATE `$table` SET `date_of_rent_start`='$data->date' WHERE id=$data->id";
    } else{
        $query = "UPDATE `$table` SET `date_of_expected_return`='$data->date' WHERE id=$data->id";
    }

    $conn->query($query);

    $conn->close();

    echo json_encode(array("result" => "success"));