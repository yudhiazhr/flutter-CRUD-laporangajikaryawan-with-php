class API {
    
    // koneksi database
    static const hostConnect = "http://192.168.100.229/api_laporanpenggajian";
    static const hostConnectKaryawan = "$hostConnect/karyawan";
    static const hostConnectPayroll = "$hostConnect/payroll";

    //tambah data
    static const tambahData = "$hostConnectKaryawan/add.php";
    //read data
    static const readData = "$hostConnectKaryawan/read.php";
    //hapus data
    static const hapusData = "$hostConnectKaryawan/delete.php";
    //edit data
    static const updateData = "$hostConnectKaryawan/update.php";


}