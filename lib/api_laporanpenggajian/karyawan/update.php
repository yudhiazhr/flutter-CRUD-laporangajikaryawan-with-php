<?php
include '../koneksi.php';

$nik = $_POST['nik'];
$nama_karyawan = $_POST['nama_karyawan'];
$jabatan_karyawan = $_POST['jabatan_karyawan'];
$status_karyawan = $_POST['status_karyawan'];
$gapok_karyawan = $_POST['gapok_karyawan'];

$sqlQuery = "UPDATE tabel_karyawan SET nama_karyawan = '$nama_karyawan', jabatan_karyawan = '$jabatan_karyawan', status_karyawan = '$status_karyawan', gapok_karyawan = '$gapok_karyawan' WHERE nik = '$nik'";

$resultOfQuery = $connectNow->query($sqlQuery);

if ($resultOfQuery) {
    echo json_encode(array("success" => true));
} else {
    echo json_encode(array("success" => false));
}
