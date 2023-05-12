import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as s;

class UpdateProfileController extends GetxController {
  RxBool isLoading = false.obs;
  TextEditingController nip = TextEditingController();
  TextEditingController nama = TextEditingController();
  TextEditingController email = TextEditingController();

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  s.FirebaseStorage storage = s.FirebaseStorage.instance;

  final ImagePicker picker = ImagePicker();
  XFile? image;

  void pickImage() async {
    image = await picker.pickImage(source: ImageSource.gallery);
    update();
  }

  Future<void> updateProfile(String uid) async{
    if(nip.text.isNotEmpty && nama.text.isNotEmpty && email.text.isNotEmpty){
      isLoading.value = true;
      try {
        Map<String, dynamic> data = {
          "nama": nama.text,
        };
        if(image != null){
          File file = File(image!.path);
          String ext = image!.name.split(".").last;

          await storage.ref('$uid/profile.$ext').putFile(file);
          String urlImage = await storage.ref('$uid/profile.$ext').getDownloadURL();

          data.addAll({"profile": urlImage});
        }
        await firestore.collection("pegawai").doc(uid).update(data);
        image = null;
        Get.snackbar("Berhasil", "Berhasil update profile");
      } catch (e) {
        Get.snackbar("Terjadi Kesalahan", "Gagal update profile");
      } finally {
        isLoading.value = false;
      }
    }
  }

  void deleteImage(String uid) async {
    try {
      await firestore.collection("pegawai").doc(uid).update({
        "profile": FieldValue.delete(),
      });
      Get.back();
      Get.snackbar("Berhasil", "Berhasil hapus profile");
    } catch (e) {
      Get.snackbar("Terjadi Kesalahan", "Gagal hapus profile");
    } finally {
      update();
    }
  }
}
