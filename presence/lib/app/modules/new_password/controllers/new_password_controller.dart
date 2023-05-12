import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../../../routes/app_pages.dart';

class NewPasswordController extends GetxController {
  TextEditingController newPassC = TextEditingController();
  FirebaseAuth auth = FirebaseAuth.instance;
  void newPassword() async{
    if(newPassC.text.isNotEmpty){
      if(newPassC.text != "123456"){
        try {
          String email = auth.currentUser!.email!;

          await auth.currentUser!.updatePassword(newPassC.text);

          await auth.signOut();

          await auth.signInWithEmailAndPassword(
            email: email,
            password: newPassC.text
          );

          Get.offAllNamed(Routes.HOME);
        } on FirebaseAuthException catch (e) {
          if (e.code == 'weak-password') {
            Get.snackbar('Terjadi Kesalahan', 'password terlalu lemah');
          }
        } catch (e){
          Get.snackbar('Terjadi Kesalahan', 'Tidak dapat mengubah password baru. Hubungi admin');
        }
      } else {
        Get.snackbar("Terjadi Kesalahan", "Password tidak boleh sama dengan password lama");
      }
    }else {
      Get.snackbar("Terjadi Kesalahan", "Password tidak boleh kosong");
    }
  }
}
