import 'package:fix_fill/Repository/Authentication_Repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  static LoginController get instance => Get.find();

  /// TextField Controllers to get data from TextFields
  final email = TextEditingController();
  final password = TextEditingController();

  /// TextField Validation

  //Call this Function from Design & it will do the rest
  Future <String?> login(String email, String password,String selectedOption) async {
    String? errorMessage = await AuthenticationRepository.instance.loginWithEmailAndPassword(email, password,selectedOption);
    return errorMessage;

    // if(error != null) {
    //   Get.showSnackbar(GetSnackBar(message: error.toString(),));
    // }

  }
  Future<void> deleteRider(String riderId) async {
    AuthenticationRepository.instance.deleteRider(riderId);

  }
  Future<void> deleteUser(String userId) async {
    AuthenticationRepository.instance.deleteUser(userId);

  }
  Future<void> deleteStation(String stationId) async {
    AuthenticationRepository.instance.deleteStation(stationId);

  }
}