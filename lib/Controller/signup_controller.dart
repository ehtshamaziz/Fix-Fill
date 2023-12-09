

import 'package:fix_fill/Repository/Authentication_Repository/authentication_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class SignupController extends GetxController{
  static SignupController get instance=> Get.find();

  final name =TextEditingController();
  final email=TextEditingController();
  final password= TextEditingController();
  final roles =TextEditingController();

  Future <String?> registerUser(String name,String email, String password, String roles, String selectedOption) async{

    String? errorMessage = await AuthenticationRepository.instance.createUserWithEmailAndPassword(name,email, password,selectedOption);

    return errorMessage;
  }

}