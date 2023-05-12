import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AddPegawaiController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool isLoadingAddPegawai = false.obs;
  String nip = '';
  String nama = '';
  String email = '';
  String job = '';
  TextEditingController passAdmin = TextEditingController();

  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> prosesAddPegawai() async {
    if (passAdmin.text.isNotEmpty) {
      isLoadingAddPegawai.value = true;
      try {
        String emailAdmin = auth.currentUser!.email!;

        UserCredential userCredentialAdmin =
            await auth.signInWithEmailAndPassword(
                email: emailAdmin, password: passAdmin.text);

        UserCredential pegawaiCredential = await auth
            .createUserWithEmailAndPassword(email: email, password: '123456');

        if (pegawaiCredential != null) {
          String uid = pegawaiCredential.user!.uid;
          await firestore.collection("pegawai").doc(uid).set({
            "nip": nip,
            "nama": nama,
            "job": job,
            "email": email,
            "uid": uid,
            "role": "pegawai",
            "createdAt": DateTime.now().toIso8601String(),
          });

          await pegawaiCredential.user!.sendEmailVerification();

          await auth.signOut();

          UserCredential userCredentialAdmin =
              await auth.signInWithEmailAndPassword(
                  email: emailAdmin, password: passAdmin.text);

          Get.back(); //tutup dialog
          Get.back(); //back to home
          Get.snackbar("Berhasil", "Berhasil menambahkan pegawai");
        }
        isLoadingAddPegawai.value = false;
        // print(pegawaiCredential);
      } on FirebaseAuthException catch (e) {
        isLoadingAddPegawai.value = false;
        if (e.code == 'weak-password') {
          Get.snackbar('Terjadi Kesalahan', 'Password terlalu lemah');
        } else if (e.code == 'email-already-in-use') {
          Get.snackbar('Terjadi Kesalahan', 'Email sudah digunakan');
        } else if (e.code == 'wrong-password') {
          Get.snackbar('Terjadi Kesalahan', 'Password salah');
        } else {
          Get.snackbar('Terjadi Kesalahan', "${e.code}");
        }
      } catch (e) {
        isLoadingAddPegawai.value = false;
        print(e);
        Get.snackbar('Error', 'Terjadi kesalahan');
      }
    } else {
      isLoading.value = false;
      Get.snackbar("Terjadi Kesalahan", "Password admin tidak boleh kosong");
    }
  }

  Future<void> addPegawai() async {
    if (nip.isNotEmpty && nama.isNotEmpty && job.isNotEmpty && email.isNotEmpty) {
      isLoading.value = true;
      Get.defaultDialog(
          title: "Validasi Admin",
          content: Column(
            children: [
              Text("Masukkan password untuk validasi"),
              SizedBox(
                height: 10,
              ),
              TextField(
                controller: passAdmin,
                autocorrect: false,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: "Password",
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            OutlinedButton(
              onPressed: () {
                isLoading.value = false;
                Get.back();
              },
              child: Text(
                "CANCEL",
              ),
            ),
            Obx(() => ElevatedButton(
                onPressed: () async {
                  if (isLoadingAddPegawai.isFalse) {
                    await prosesAddPegawai();
                  }
                  isLoading.value = false;
                },
                child: Text(
                  isLoadingAddPegawai.isFalse ? "ADD PEGAWAI" : "LOADING...",
                )))
          ]);
    } else {
      Get.snackbar('Error', 'Semua field harus diisi');
    }
  }
}
