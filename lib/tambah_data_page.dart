import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:laporanpenggajiankaryawanapps/karyawan_page.dart';
import 'package:http/http.dart' as http;
import 'package:laporanpenggajiankaryawanapps/widgets/mybutton.dart';
import 'package:laporanpenggajiankaryawanapps/widgets/mytextfromfield.dart';

import 'api_connection/api_connection.dart';


class TambahDataScreen extends StatefulWidget {
   

  @override
  State<TambahDataScreen> createState() => _TambahDataScreenState();
}

class _TambahDataScreenState extends State<TambahDataScreen> {
  String? selectedJabatan; 
  String? selectedStatus;
  List<String> jabatanOptions = ['Manager', 'Supervisor', 'Staff'];
  List<String> statusOptions = ['Sudah Menikah', 'Belum Menikah'];



var _formKey = GlobalKey<FormState>();
var nikEditingController = TextEditingController();
var namaKaryawanEditingController = TextEditingController();
var jabatanKaryawanEditingController = TextEditingController();
var statusKaryawanEditingController = TextEditingController();
var gajiPokokKaryawanEditingController = TextEditingController();

simpanDataRecord() async {
  
   try {
      var response = await http.post(
        Uri.parse(API.tambahData),
        body: {
          'nik' : nikEditingController.text.trim().toString(),
          'nama_karyawan': namaKaryawanEditingController.text.trim().toString(),
          'jabatan_karyawan' : jabatanKaryawanEditingController.text.trim().toString(),
          'status_karyawan' : statusKaryawanEditingController.text.trim().toString(),
          'gapok_karyawan' : gajiPokokKaryawanEditingController.text.trim().toString(),
        },
      );

      if(response.statusCode == 200)
      {
        var resBodyOftambahData= jsonDecode(response.body);

        if(resBodyOftambahData['success'] == true)
        {
          Fluttertoast.showToast(msg: "Data baru berhasil di tambahkan");

          setState(() {
            nikEditingController.clear();
            namaKaryawanEditingController.clear();
            jabatanKaryawanEditingController.clear();
            gajiPokokKaryawanEditingController.clear();
          });
          Get.to(()=> KaryawanScreen());
        }
        else
        {
          Fluttertoast.showToast(msg: "Data gagal ditambahkan, coba lagi");
        }
      }
      else
      {
        Fluttertoast.showToast(msg: "Status is not 200");
      }
    }
    catch(errorMsg)
    {
      print("Error:: " + errorMsg.toString());
    }

}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
          onPressed: () {
              Get.to(() => KaryawanScreen());
            
          },
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text("Pt. Baroqah tbk", style: TextStyle(color: Colors.black,),),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Form(
          key:_formKey,
          child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.only(left: 20, right: 20),
              child: Text("Tambah Data Karyawan"),
            ),
            Container(
              padding: EdgeInsets.only(left: 20,right: 20,top: 10,bottom: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  MyTextFormField(
                    controller: nikEditingController, 
                    name: "NIK", 
                    validator: (value) => value == "" ? "Tolong isi NIK" : null,
                        onSaved: (value) {
                        nikEditingController.text = value!;
                        },
                        enabled: true,
                      ),
                  SizedBox(height: 15,),

                  MyTextFormField(
                    controller: namaKaryawanEditingController, 
                    name: "Nama karyawan", 
                    validator: (value) => value == "" ? "Tolong isi nama karyawan" : null,
                        onSaved: (value) {
                        namaKaryawanEditingController.text = value!;
                        },
                        enabled: true,
                      ),
                  SizedBox(height: 15,),

                  DropdownButtonFormField<String>(
                    value: selectedStatus,
                    onChanged: (value) {
                      statusKaryawanEditingController.text = value!;
                      setState(() {
                        selectedStatus = value;
                        if (selectedStatus == 'Belum Menikah') {
                          statusKaryawanEditingController.text = 'Belum Menikah';
                        } else if (selectedStatus == 'Sudah Menikah') {
                          statusKaryawanEditingController.text = 'Sudah Menikah';
                        } 
                      });
                    },
                    items: statusOptions.map((String status) {
                      return DropdownMenuItem<String>(
                        value: status,
                        child: Text(status),
                      );
                    }).toList(),
                    decoration: InputDecoration(
                      labelText: 'status',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 15,),

                  DropdownButtonFormField<String>(
                    value: selectedJabatan,
                    onChanged: (value) {
                      jabatanKaryawanEditingController.text = value!;
                      setState(() {
                        selectedJabatan = value;
                        if (selectedJabatan == 'Manager') {
                          gajiPokokKaryawanEditingController.text = '10000000';
                        } else if (selectedJabatan == 'Supervisor') {
                          gajiPokokKaryawanEditingController.text = '8000000';
                        } else if (selectedJabatan == 'Staff') {
                          gajiPokokKaryawanEditingController.text = '6500000';
                        }
                      });
                    },
                    items: jabatanOptions.map((String jabatan) {
                      return DropdownMenuItem<String>(
                        value: jabatan,
                        child: Text(jabatan),
                      );
                    }).toList(),
                    decoration: InputDecoration(
                      labelText: 'Jabatan',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 15,),

                  MyTextFormField(
                    controller: gajiPokokKaryawanEditingController,
                    name: "Gaji pokok",
                    validator: (value) => value == "" ? "Tolong isi gaji karyawan" : null,
                    onSaved: (value) {
                      gajiPokokKaryawanEditingController.text = value!;
                    },
                    enabled: false,
                  ),       

                  SizedBox(height: 20,),
                  MyButton(name: "Tambah", 
                  onPressed: () {
                    if(_formKey.currentState!.validate())
                      {
                        Fluttertoast.showToast(msg: "Menambahkan ...");
                      }
                      simpanDataRecord();
                  }),
                ],
              ),
            ),
          
          ],
        ),
      ),
      ),
    );
  }
}