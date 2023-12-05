<?php
include '../koneksi.php';

$sqlQuery = "SELECT * FROM tabel_karyawan ORDER BY nik ASC";

$resultOfQuery = $connectNow->query($sqlQuery);

if($resultOfQuery->num_rows > 0) 
{
    $recordKaryawan = array();
    while($rowFound = $resultOfQuery->fetch_assoc())
    {
        $recordKaryawan[] = $rowFound;
    }

    echo json_encode(
        array(
            "success"=>true,
            "dataKaryawan"=>$recordKaryawan,
        )
    );
}
else 
{
    echo json_encode(array("success"=>false));
}