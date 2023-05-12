import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../../../routes/app_pages.dart';

class LoginController extends GetxController {
  RxBool isLoading = false.obs;
  TextEditingController emailC = TextEditingController();
  TextEditingController passC = TextEditingController();

  FirebaseAuth auth = FirebaseAuth.instance;

  Future<void> login() async {
    if (emailC.text.isNotEmpty && passC.text.isNotEmpty) {
      isLoading.value = true;
      try{
        UserCredential userCredential = await auth.signInWithEmailAndPassword(
          email: emailC.text,
          password: passC.text
        );

        // print(UserCredential);

        if (userCredential.user != null) {
          if(userCredential.user!.emailVerified == true){
            isLoading.value = false;
            if(passC.text == "123456") {
              Get.offAllNamed(Routes.NEW_PASSWORD);
            } else {
              Get.offAllNamed(Routes.HOME);

            }
          } else {
            Get.defaultDialog(
              title: "Belum Verifikasi",
              middleText: "Silahkan verifikasi email anda terlebih dahulu",
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
                ElevatedButton(
                  onPressed: () async {
                    try {
                      await userCredential.user!.sendEmailVerification();
                      Get.back();
                      Get.snackbar("Berhasil", "Email verifikasi telah dikirim");
                      isLoading.value = false;
                    } catch (e) {
                      isLoading.value = false;
                      Get.snackbar("Terjadi Kesalahan", "Tidak dapat mengirim email verifikasi.Hubungi admin");
                    }
                  },
                  child: Text(
                    "KIRIM ULANG",
                  ),
                ),
              ]
            );
          }
        }
      isLoading.value = false;
      } on FirebaseAuthException catch (e) {
        isLoading.value = false;
        if (e.code == 'user-not-found') {
          Get.snackbar('Terjadi Kesalahan', 'Email tidak terdaftar');
        } else if (e.code == 'wrong-password') {
          Get.snackbar('Terjadi Keasalahan', 'Password salah');
        }
      } catch (e) {
        isLoading.value = false;
        Get.snackbar('Terjadi Kesalahan', 'Tidak dapat login');
      }
    } else {
      // isLoading.value = false;
      Get.snackbar('Error', 'Email dan Password tidak boleh kosong');
    }
  }
}
