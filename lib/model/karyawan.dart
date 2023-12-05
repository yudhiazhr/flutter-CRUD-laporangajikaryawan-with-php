class Karyawan {
  String nik;
  String nama_karyawan;
  String jabatan_karyawan;
  String status_karyawan;
  int gapok_karyawan;

  Karyawan({
    required this.status_karyawan,
    required this.nik,
    required this.nama_karyawan,
    required this.jabatan_karyawan,
    required this.gapok_karyawan,
  });

  Karyawan copyWith({
    String? nik,
    String? nama_karyawan,
    String? status_karyawan,
    String? jabatan_karyawan,
    int? gapok_karyawan,
  }) {
    return Karyawan(
      nik: nik ?? this.nik,
      nama_karyawan: nama_karyawan ?? this.nama_karyawan,
      jabatan_karyawan: jabatan_karyawan ?? this.jabatan_karyawan,
      status_karyawan: status_karyawan ?? this.status_karyawan,
      gapok_karyawan: gapok_karyawan ?? this.gapok_karyawan,
    );
  }

  factory Karyawan.fromJson(Map<String, dynamic> json) => Karyawan(
    nik: json['nik'],
    nama_karyawan:json['nama_karyawan'],
    jabatan_karyawan:json['jabatan_karyawan'],
    status_karyawan: json['status_karyawan'],
    gapok_karyawan:int.parse(json['gapok_karyawan']),
  );

  Map<String, dynamic> toJson() => {
    'nik' : nik,
    'nama_karyawan' : nama_karyawan,
    'jabatan_karyawan' : jabatan_karyawan,
    'status_karyawan' : status_karyawan,
    'gapok_karyawan' : gapok_karyawan,
    };
}