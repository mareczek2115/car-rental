<?php
    include('DB_Connection.php');

    $data = json_decode(file_get_contents("php://input", true));

    if($data->type === "accept"){
        $query = "UPDATE `awaiting_reservations` SET `status`='active' WHERE `id`=$data->id";
        $query2 = "DELETE FROM `awaiting_reservations` WHERE `status`='active'";
        $conn->query($query);
        $conn->query($query2);
        // echo $conn->error;
        $conn->close();
    } else{
        $query = "DELETE FROM `awaiting_reservations` WHERE `id`=$data->id";
        $conn->query($query);
        $conn->close();
    }

    echo json_encode(array("result" => "success"));
