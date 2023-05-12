import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UpdatePasswordController extends GetxController {
  RxBool isLoading = false.obs;
  TextEditingController currentPasswordC = TextEditingController();
  TextEditingController newPasswordC = TextEditingController();
  TextEditingController confirmNewPasswordC = TextEditingController();

  FirebaseAuth auth = FirebaseAuth.instance;

  void updatePass() async{
    if(currentPasswordC.text.isNotEmpty && newPasswordC.text.isNotEmpty && confirmNewPasswordC.text.isNotEmpty){
      if(newPasswordC.text == confirmNewPasswordC.text){
        isLoading.value = true;
        try {
          String emailUser = auth.currentUser!.email!;

          await auth.signInWithEmailAndPassword(email: emailUser, password: currentPasswordC.text);

          await auth.currentUser!.updatePassword(newPasswordC.text);

          Get.back();
          
          Get.snackbar("Berhasil", "Berhasil update password");

        } on FirebaseAuthException catch (e) {
          if(e.code == "wrong-password"){
            Get.snackbar("Terjadi Kesalahan", "Password lama salah");
          }else {
            Get.snackbar("Terjadi Kesalahan", "${e.code.toLowerCase()}");
          }
        } catch (e) {
          Get.snackbar("Terjadi Kesalahan", "Gagal update password");
        }finally {
          isLoading.value = false;
        }
      } else {
        Get.snackbar("Terjadi Kesalahan", "Confirm Password tidak sama");
      }
    } else {
      Get.snackbar("Terjadi Kesalahan", "Semua field harus diisi");
    }
  }
}
