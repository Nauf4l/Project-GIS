import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/add_pegawai_controller.dart';

class AddPegawaiView extends GetView<AddPegawaiController> {
  const AddPegawaiView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Pegawai'),
        centerTitle: true,
      ),
      body: ListView(
        padding: EdgeInsets.all(20),
        children: [
          TextFormField(
            onChanged: (value) => controller.nip = value,
            decoration: InputDecoration(
              labelText: 'NIP',
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          TextFormField(
            onChanged: (value) => controller.nama = value,
            decoration: InputDecoration(
              labelText: 'Nama Pegawai',
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          TextFormField(
            onChanged: (value) => controller.job = value,
            decoration: InputDecoration(
              labelText: 'Job',
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          TextFormField(
            onChanged: (value) => controller.email = value,
            decoration: InputDecoration(
              labelText: 'Email',
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(
            height: 30,
          ),
          Obx(() => ElevatedButton(
              onPressed: () {
                if (controller.isLoading.isFalse) {
                  controller.addPegawai();
                }
              },
              child:
                  Text(controller.isLoading.isFalse ? 'Simpan' : 'Loading...')))
        ],
      ),
    );
  }
}
