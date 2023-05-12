import 'dart:io';

import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/update_profile_controller.dart';

class UpdateProfileView extends GetView<UpdateProfileController> {
  UpdateProfileView({Key? key}) : super(key: key);

  final Map<String, dynamic> user = Get.arguments;

  @override
  Widget build(BuildContext context) {
    print(user);
    controller.nip.text = user["nip"];
    controller.nama.text = user["nama"];
    controller.email.text = user["email"];
    return Scaffold(
      appBar: AppBar(
        title: const Text('UPDATE PROFILE'),
        centerTitle: true,
      ),
      body: ListView(
        padding: EdgeInsets.all(20),
        children: [
          TextFormField(
            readOnly: true,
            controller: controller.nip,
            decoration: InputDecoration(
              labelText: 'NIP',
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          TextFormField(
            controller: controller.nama,
            decoration: InputDecoration(
              labelText: 'Nama Pegawai',
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          TextFormField(
            readOnly: true,
            controller: controller.email,
            decoration: InputDecoration(
              labelText: 'Email',
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(
            height: 25,
          ),
          const Text(
            "Photo Profile",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GetBuilder<UpdateProfileController>(
                builder: (c){
                  if(c.image != null){
                    return ClipOval(
                      child: Container(
                        height: 100,
                        width: 100,
                        child: Image.file(
                          File(c.image!.path),
                          fit: BoxFit.cover,
                        )
                      ),
                    );
                  } else {
                    if(user["profile"] != null){
                      return Column(
                        children: [
                          ClipOval(
                            child: Container(
                              height: 100,
                              width: 100,
                              child: Image.network(
                                user["profile"],
                                fit: BoxFit.cover,
                              )
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              controller.deleteImage(user["uid"]);
                            },
                            child: Text("delete"),
                          )
                        ],
                      );
                    } else {
                      return Text ("Tidak Ada Foto Profile.");
                    }
                  }
                },
              ),
              // user["profile"] != null && user["profile"] != "" ? Text("Foto Profile.") :Text("no choosen.") ,
              TextButton(
                onPressed: () {
                  controller.pickImage();
                },
                child: Text("Choose Photo"),
              )
            ],
          ),
          SizedBox(
            height: 30,
          ),
          Obx(() => ElevatedButton(
              onPressed: () {
                if (controller.isLoading.isFalse) {
                  controller.updateProfile(user["uid"]);
                }
              },
              child:
                  Text(controller.isLoading.isFalse ? 'Simpan' : 'Loading...')))
        ],
      ),
    );
  }
}
