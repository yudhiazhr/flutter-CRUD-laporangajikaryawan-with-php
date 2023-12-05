<?php
include '../koneksi.php';

$nik = $_POST['nik'];

$sqlQuery = "DELETE FROM tabel_karyawan WHERE nik = '$nik' ";

$resultOfQuery = $connectNow->query($sqlQuery);

if($resultOfQuery)
{
    echo json_encode(array("success"=>true));
}
else
{
    echo json_encode(array("success"=>false));
}
