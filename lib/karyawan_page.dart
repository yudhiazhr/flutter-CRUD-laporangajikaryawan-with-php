  import 'dart:convert';
  import 'dart:io';
  import 'package:flutter/material.dart';
  import 'package:fluttertoast/fluttertoast.dart';
  import 'package:get/get.dart';
  import 'package:laporanpenggajiankaryawanapps/model/karyawan.dart';
  import 'package:http/http.dart' as http;
  import 'package:laporanpenggajiankaryawanapps/tambah_data_page.dart';
  import 'package:path_provider/path_provider.dart';
  import 'api_connection/api_connection.dart';
  import 'package:pdf/pdf.dart';
  import 'package:pdf/widgets.dart' as pdfWidgets;
  import 'package:printing/printing.dart';

class KaryawanScreen extends StatefulWidget {
  
  const KaryawanScreen({super.key});

  @override
  State<KaryawanScreen> createState() => _KaryawanScreenState();
}
class _KaryawanScreenState extends State<KaryawanScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text("Pt. Baroqah tbk", style: TextStyle(color: Colors.black,),),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.only(left: 20, right: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  
                  Text("Hello 👋", style: TextStyle(fontSize: 20, color: Colors.grey.shade700),),
                  Text("HRD PT. Baroqah tbk", style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,)),
                  SizedBox(height: 20,),
                  Text("Data Karyawan: ", style: TextStyle(fontSize: 18,),),
                  SizedBox(height: 10,),
                  semuaDataKaryawanWidget(context),
                  
                ],
              ),
            ),
          ],
        ),
      ),
      
      bottomNavigationBar: Material(
              color: Colors.blue,
              child: MaterialButton(
              minWidth: 131,
                onPressed : () {
                   Get.to(()=> TambahDataScreen());
                   
                },
                child: Text("Tambah data",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14,  color: Colors.white),),
                  
              ),
            ));
    }

  
  // WidgetDataKaryawan 
 Widget semuaDataKaryawanWidget(context) {
  final TextEditingController bulanController = TextEditingController();
  final TextEditingController tahunController = TextEditingController();

  return FutureBuilder(
    future: ambilSemuaRecordDataKaryawan(),
    builder: (context, AsyncSnapshot<List<Karyawan>> dataSnapShot) {
      if (dataSnapShot.connectionState == ConnectionState.waiting) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      }
      if (dataSnapShot.data == null) {
        return const Center(
          child: Text(
            "No Trending item found",
          ),
        );
      }
      if (dataSnapShot.data!.length > 0) {
        
        return Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [ 
              SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text('Cetak Laporan'),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextField(
                            controller: bulanController,
                            decoration: InputDecoration(
                              hintText: 'Periode bulan',
                            ),
                          ),
                          TextField(
                            controller: tahunController,
                            decoration: InputDecoration(
                              hintText: 'Periode tahun',
                            ),
                          ),
                        ],
                      ),
                      actions: [
                        TextButton(
                          child: Text('Batal'),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                        TextButton(
                          child: Text('Cetak'),
                          onPressed: () {
                            generatePdf(dataSnapShot.data!, bulanController.text, tahunController.text);
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    ),
                  );
                },
                child: Text('Cetak Laporan Gaji'),
              ),
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    
                    DataTable(
                      columns: const [
                        DataColumn(label: Text('NIK')),
                        DataColumn(label: Text('Nama')),
                        DataColumn(label: Text('Jabatan')),
                        DataColumn(label: Text('Status')),
                        DataColumn(label: Text('Gaji Pokok')),
                        DataColumn(label: Text('Bonus')),
                        DataColumn(label: Text('PPH')),
                        DataColumn(label: Text('Gaji Bersih')),
                        DataColumn(label: Text('  Edit     Hapus')),
                        
                        ],
                        
                        rows: dataSnapShot.data!.map((eachRecordKaryawan) {
                        final TextEditingController namaController = TextEditingController(text: eachRecordKaryawan.nama_karyawan);
                        final TextEditingController jabatanController = TextEditingController(text: eachRecordKaryawan.jabatan_karyawan);
                        final TextEditingController statusController = TextEditingController(text: eachRecordKaryawan.status_karyawan);

                        final TextEditingController gapokController = TextEditingController(text: eachRecordKaryawan.gapok_karyawan.toString());
        
                        double bonus = 0.0;
                        double pph = 0.0;
                        double gajiBersih = 0.0;
        
                        if (eachRecordKaryawan.jabatan_karyawan == 'Manager') {
                          bonus = eachRecordKaryawan.gapok_karyawan * 0.5;
                        } else if (eachRecordKaryawan.jabatan_karyawan == 'Supervisor') {
                          bonus = eachRecordKaryawan.gapok_karyawan * 0.4;
                        } else if (eachRecordKaryawan.jabatan_karyawan == 'Staff') {
                          bonus = eachRecordKaryawan.gapok_karyawan * 0.3;
                        }
        
                        pph = (eachRecordKaryawan.gapok_karyawan + bonus) * 0.05;
                        gajiBersih = (eachRecordKaryawan.gapok_karyawan + bonus) - pph;
        
                        
                        return DataRow(cells: [
                          DataCell(Text(eachRecordKaryawan.nik)),
                          DataCell(Text(eachRecordKaryawan.nama_karyawan)),
                          DataCell(Text(eachRecordKaryawan.jabatan_karyawan)),
                          DataCell(Text(eachRecordKaryawan.status_karyawan)),
                          DataCell(Text(eachRecordKaryawan.gapok_karyawan.toString())),
                          DataCell(Text(bonus.toStringAsFixed(0))),
                          DataCell(Text("-"+pph.toStringAsFixed(0))),
                          DataCell(Text(gajiBersih.toStringAsFixed(0))),
                          DataCell(
                            Row(
                              children: [
                                IconButton(
                                  icon: Icon(Icons.edit),
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        title: Text('Edit Data Karyawan'),
                                        content: StatefulBuilder(
                                          builder: (BuildContext context, StateSetter setState) {
                                            String selectedJabatan = jabatanController.text; // Menyimpan jabatan terpilih
                                            int selectedGapok = 0; // Menyimpan gaji pokok terpilih

                                            String selectedStatus = statusController.text;
                                            List<Map<String, dynamic>> statusOptions = [
                                              {'status' : 'Belum Menikah'},
                                              {'status' : 'Sudah Menikah'}
                                            ];

                                            void onStatusChanged(String? value) {
                                              if (value != null) {
                                                setState(() {
                                                  
                                                  statusController.text = selectedStatus;
                                                });
                                              }
                                            }

                                            // Opsi-opsi jabatan beserta gaji pokoknya
                                            List<Map<String, dynamic>> jabatanOptions = [
                                              {'jabatan': 'Manager', 'gapok': 10000000},
                                              {'jabatan': 'Supervisor', 'gapok': 8000000},
                                              {'jabatan': 'Staff', 'gapok': 6500000},
                                            ];
        
                                            // Fungsi untuk mengubah jabatan dan gaji pokok berdasarkan pilihan dropdown
                                            void onJabatanChanged(String? value) {
                                              if (value != null) {
                                                setState(() {
                                                  selectedJabatan = value;
                                                  selectedGapok = jabatanOptions.firstWhere((option) => option['jabatan'] == value)['gapok'];
                                                  gapokController.text = selectedGapok.toString();
                                                  jabatanController.text = selectedJabatan;
                                                });
                                              }
                                            }
        
                                            return Column(
                                              mainAxisSize: MainAxisSize.min,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text('Nama'),
                                                TextFormField(
                                                  controller: namaController,
                                                  decoration: InputDecoration(
                                                    hintText: 'Masukkan nama karyawan',
                                                  ),
                                                ),
                                                SizedBox(height: 8),

                                                Text('Status'),
                                                DropdownButtonFormField<String>(
                                                  value: selectedStatus,
                                                  onChanged: onStatusChanged,
                                                  items: statusOptions.map((option) {
                                                    return DropdownMenuItem<String>(
                                                      value: option['status'],
                                                      child: Text(option['status']),
                                                    );
                                                  }).toList(),
                                                ),

                                                SizedBox(height: 8,),
                                                Text('Jabatan'),
                                                DropdownButtonFormField<String>(
                                                  value: selectedJabatan,
                                                  onChanged: onJabatanChanged,
                                                  items: jabatanOptions.map((option) {
                                                    return DropdownMenuItem<String>(
                                                      value: option['jabatan'],
                                                      child: Text(option['jabatan']),
                                                    );
                                                  }).toList(),
                                                ),
                                                SizedBox(height: 8),
                                                Text('Gaji Pokok'),
                                                TextFormField(
                                                  controller: gapokController,
                                                  keyboardType: TextInputType.number,
                                                  decoration: InputDecoration(
                                                    hintText: 'Masukkan gaji pokok',
                                                    enabled: false,
                                                  ),
                                                ),
                                              ],
                                            );
                                          },
                                        ),
                                        actions: [
                                          TextButton(
                                            child: Text('Batal'),
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                          ),
                                          TextButton(
                                            child: Text('Simpan'),
                                            onPressed: () {
                                              Karyawan updatedKaryawan = eachRecordKaryawan.copyWith(
                                                nama_karyawan: namaController.text,
                                                jabatan_karyawan: jabatanController.text,
                                                status_karyawan: statusController.text,
                                                gapok_karyawan: int.parse(gapokController.text),
                                              );
        
                                              updateData(updatedKaryawan).then((isUpdated) {
                                                if (isUpdated) {
                                                  setState(() {
                                                    eachRecordKaryawan = updatedKaryawan;
                                                  });
                                                  Navigator.pop(context);
                                                }
                                              });
                                            },
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                                IconButton(
                                  icon: Icon(Icons.delete),
                                  onPressed: () {
                                    Get.dialog(
                                      AlertDialog(
                                        title: Text("Konfirmasi"),
                                        content: Text("Apakah Anda yakin ingin menghapus data karyawan ini?"),
                                        actions: [
                                          TextButton(
                                            child: Text("Batal"),
                                            onPressed: () {
                                              Get.back();
                                            },
                                          ),
                                          TextButton(
                                            child: Text("Hapus"),
                                            onPressed: () {
                                              hapusKaryawan(eachRecordKaryawan.nik).then((isDeleted) {
                                                if (isDeleted) {
                                                  setState(() {
                                                    dataSnapShot.data!.remove(eachRecordKaryawan);
                                                  });
                                                }
                                              });
                                              Get.back();
                                            },
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ]);
                      }).toList(),
                    ),
                  ],
                ),
                
              ),
            ],
          ),
        );
      } else {
        return const Center(
          child: Text("Empty, No Data."),
        );
      }
    },
  );
}

// generate PDF
void generatePdf(List<Karyawan> data, String bulan, String tahun) async {
  final pdf = pdfWidgets.Document();
  final tableHeaders = ['NIK', 'Nama', 'Jabatan', 'Gaji Pokok', 'Bonus', 'PPH', 'Gaji Bersih'];

  // Tambahkan header tabel
    pdf.addPage(
    pdfWidgets.MultiPage(
      pageFormat: PdfPageFormat.a4,
      build: (context) => [
        pdfWidgets.Text(
          'Laporan Gaji Karyawan',
          style: pdfWidgets.TextStyle(fontSize: 20, fontWeight: pdfWidgets.FontWeight.bold),
        ),
        pdfWidgets.SizedBox(height: 16),
        pdfWidgets.Text(
          'Periode: $bulan $tahun',
          style: pdfWidgets.TextStyle(fontWeight: pdfWidgets.FontWeight.bold),
        ),
      pdfWidgets.SizedBox(height: 16),
      pdfWidgets.Table.fromTextArray(
        headers: tableHeaders,
        columnWidths: {
          0: pdfWidgets.FixedColumnWidth(50), 
          1: pdfWidgets.FixedColumnWidth(100), 
          2: pdfWidgets.FixedColumnWidth(120), 
          3: pdfWidgets.FixedColumnWidth(80),  
          4: pdfWidgets.FixedColumnWidth(80),  
          5: pdfWidgets.FixedColumnWidth(80), 
          6: pdfWidgets.FixedColumnWidth(80), 
        },
        data: [
          ...data.map((record) => [
            record.nik,
            record.nama_karyawan,
            record.jabatan_karyawan,
            record.gapok_karyawan.toString(),
            (_calculateBonus(record.gapok_karyawan.toDouble(), record.jabatan_karyawan)).toStringAsFixed(0),
            (_calculatePPH(record.gapok_karyawan.toDouble(), record.jabatan_karyawan)).toStringAsFixed(0),
            (_calculateGajiBersih(record.gapok_karyawan.toDouble(), record.jabatan_karyawan)).toStringAsFixed(0),
          ])
        ],
      ),
      pdfWidgets.SizedBox(height: 16),
      pdfWidgets.Row(
        mainAxisAlignment: pdfWidgets.MainAxisAlignment.spaceBetween,
        children: [
          pdfWidgets.Text(
            'Total Gaji Yang harus Di Bayarkan:',
            style: pdfWidgets.TextStyle(fontWeight: pdfWidgets.FontWeight.bold),
          ),
          pdfWidgets.Text(
            calculateTotalGajiKeseluruhan(data).toStringAsFixed(0), // Menampilkan total gaji keseluruhan
            style: pdfWidgets.TextStyle(fontWeight: pdfWidgets.FontWeight.bold),
          ),
        ],
      ),
    ],
  ),
);

  // Simpan file PDF
  final output = await getTemporaryDirectory();
  final outputFile = File('${output.path}/data_karyawan.pdf');
  await outputFile.writeAsBytes(await pdf.save());

  // Cetak file PDF
  await Printing.layoutPdf(onLayout: (PdfPageFormat format) async => pdf.save());
}
  

double calculateTotalGajiKeseluruhan(List<Karyawan> data) {
  double totalGaji = 0;
  for (var record in data) {
    double bonus = _calculateBonus(record.gapok_karyawan.toDouble(), record.jabatan_karyawan);
    double pph = _calculatePPH(record.gapok_karyawan.toDouble(), record.jabatan_karyawan);
    double gajiBersih = _calculateGajiBersih(record.gapok_karyawan.toDouble(), record.jabatan_karyawan);
    totalGaji += gajiBersih + bonus - pph;
  }
  return totalGaji;
}

double _calculateBonus(double gapok, String jabatan) {
  if (jabatan == 'Manager') {
    return gapok * 0.5;
  } else if (jabatan == 'Supervisor') {
    return gapok * 0.4;
  } else if (jabatan == 'Staff') {
    return gapok * 0.3;
  } else {
    return 0.0;
  }
}

double _calculatePPH(double gapok, String jabatan) {
  final bonus = _calculateBonus(gapok.toDouble(), jabatan);
  return (gapok + bonus) * 0.05;
}

double _calculateGajiBersih(double gapok, String jabatan) {
  final bonus = _calculateBonus(gapok.toDouble(), jabatan);
  final pph = _calculatePPH(gapok.toDouble(), jabatan);
  return (gapok + bonus) - pph;
}

  // updateData
  Future<bool> updateData(Karyawan karyawan) async {
  try {
    var res = await http.post(
      Uri.parse(API.updateData),
      body: {
        "nik": karyawan.nik,
        "nama_karyawan": karyawan.nama_karyawan,
        "jabatan_karyawan": karyawan.jabatan_karyawan,
        "status_karyawan" : karyawan.status_karyawan,
        "gapok_karyawan": karyawan.gapok_karyawan.toString(),
      },
    );

    if (res.statusCode == 200) {
      var responseBody = jsonDecode(res.body);

      if (responseBody["success"] == true) {
        Fluttertoast.showToast(msg: "Data karyawan berhasil diperbarui");
        return true;
      } else {
        Fluttertoast.showToast(msg: "Gagal memperbarui data karyawan");
        return false;
      }
    } else {
      Fluttertoast.showToast(msg: "Error, Status Code is not 200");
      return false;
    }
  } catch (errorMessage) {
    print("Error: $errorMessage");
    Fluttertoast.showToast(msg: "Error: $errorMessage");
    return false;
  }
}

  //hapus karyawan
  Future<bool> hapusKaryawan(String nik) async {
    try {
      var res = await http.post(
        Uri.parse(API.hapusData), 
        body: {
          "nik": nik,
        },
      );

      if (res.statusCode == 200) {
        var responseBody = jsonDecode(res.body);

        if (responseBody["success"] == true) {
          Fluttertoast.showToast(msg: "Karyawan berhasil dihapus");
          return true;
        } else {
          Fluttertoast.showToast(msg: "Gagal menghapus karyawan");
          return false;
        }
      } else {
        Fluttertoast.showToast(msg: "Error, Status Code is not 200");
        return false;
      }
    } catch (errorMessage) {
      print("Error: $errorMessage");
      Fluttertoast.showToast(msg: "Error: $errorMessage");
      return false;
    }
  }

  // Ambil Data Semua Karyawan
  Future<List<Karyawan>> ambilSemuaRecordDataKaryawan() async
  {
    List<Karyawan> listSemuaRecordDataKaryawan = [];

    try
    {
      var res = await http.post(
          Uri.parse(API.readData)
      );

      if(res.statusCode == 200)
      {
        var responseBodyOfSemuaRecordDataKaryawan = jsonDecode(res.body);
        
        
        if(responseBodyOfSemuaRecordDataKaryawan["success"] == true)
        {
          (responseBodyOfSemuaRecordDataKaryawan["dataKaryawan"] as List).forEach((eachRecord)
          {
            listSemuaRecordDataKaryawan.add(Karyawan.fromJson(eachRecord));
          });
        }
      }
      else
      {
        Fluttertoast.showToast(msg: "Error, status code is not 200");
      }
    }
    catch(errorMsg)
    {
      print("Error:: " + errorMsg.toString());
    }

    return listSemuaRecordDataKaryawan;
  }

}