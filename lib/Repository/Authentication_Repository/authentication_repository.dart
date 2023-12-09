

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fix_fill/Controller/notification_controller.dart';
import 'package:fix_fill/Repository/Authentication_Repository/Exceptions/signup_email_password_failure.dart';
import 'package:fix_fill/Auth//Welcome.dart';
import 'package:fix_fill/rider/upload_doc.dart';
import 'package:fix_fill/station/station_map_screen.dart';
import 'package:fix_fill/user/dashboard.dart';
import 'package:fix_fill/main.dart';
import 'package:fix_fill/rider/rider.dart';
import 'package:fix_fill/station/shop.dart';
import 'package:fix_fill/Auth/signup.dart';
import 'package:fix_fill/user/user.dart';
import 'package:fix_fill/widgets/bottom_nav_admin.dart';
import 'package:fix_fill/widgets/bottom_nav_bar.dart';
import 'package:fix_fill/widgets/bottom_navbar_rider.dart';
import 'package:get/get.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

import '../../widgets/bottom_nav_user.dart';

class AuthenticationRepository extends GetxController{
  static AuthenticationRepository get instance=> Get.find();
  // const admin = require('firebase-admin')
  final _auth= FirebaseAuth.instance;
  late final Rx<User?> firebaseUser;
  // final notificationController = Get.put(FirebaseNotificationController());


  @override
  void onReady() {
    firebaseUser=Rx<User?>(_auth.currentUser);
    firebaseUser.bindStream(_auth.userChanges());
    ever(firebaseUser, _setInitialScreen);
  }

  _setInitialScreen(User?user){
    if(user==null) {
      Get.offAll(()=>const signup());
    }
    // user!=null ? Get.offAll(()=>const dashboard()):Get.offAll(()=>const signup());
  }
  Future <String?> createUserWithEmailAndPassword(String name,String email, String password, String selectedOption) async{
    String exceptionMessage = '';
    // try {
      try {
        if(selectedOption=="User"){

          email="user_"+email;
          print(email);
          UserCredential userCredential = await _auth
              .createUserWithEmailAndPassword(
              email: email, password: password);
          await FirebaseFirestore.instance.collection('users').doc(
              userCredential.user!.uid).set({
            'name': name,
          });
          Get.offAll(()=> BottomNavUser());
        }
        else if(selectedOption=="Rider"){

email="rider_"+email;
UserCredential userCredential = await _auth
    .createUserWithEmailAndPassword(
    email: email, password: password);
await FirebaseFirestore.instance.collection('rider').doc(
    userCredential.user!.uid).set({
  'name': name,
  'status':"Pending"
});
  Get.offAll(()=>const Welcome());

        }
        else if(selectedOption=="Station"){
email="station_"+email;
UserCredential userCredential = await _auth
    .createUserWithEmailAndPassword(
    email: email, password: password);
await FirebaseFirestore.instance.collection('station').doc(
    userCredential.user!.uid).set({
  'name': name,
});
DocumentSnapshot<Map<String, dynamic>> userSnapshot =
await FirebaseFirestore.instance.collection('station').doc(userCredential.user!.uid).get();
if (userSnapshot.exists && userSnapshot.data()!.containsKey('location') && userSnapshot.data()?['location'] != null) {
  // Location is set, navigate to the main screen
  Get.offAll(() => const BottomNavigationBarExample());
} else {
  // Location is not set, navigate to the location selection screen
  Get.offAll(() => StationLocationPickerScreen(stationId: userCredential.user!.uid,));
}

        }

    }on FirebaseAuthException catch(e){
      exceptionMessage = e.message ?? 'An error occurred';

      SignupWithEmailPasswordFailure failure= SignupWithEmailPasswordFailure.code(e.code);
      print("FIREBASE EXCEPTIONpp ${failure.message}");
      print(e.code);
      return failure.message;

      // throw ex;
    }catch(_){
      final ex= SignupWithEmailPasswordFailure();
      print("FIREBASE EXCEPTIONsss ${ex.message}");
      // return ex.message;
      throw ex;
    }
  }

  Future <String?> loginWithEmailAndPassword(String email, String password,String selectedOptions) async{
    try {
      if(selectedOptions=="User"){
email="user_"+email;
        UserCredential userCredential=await _auth.signInWithEmailAndPassword(
            email: email, password: password);
        DocumentSnapshot<Map<String, dynamic>> userSnapshot =
        await FirebaseFirestore.instance.collection('users').doc(userCredential.user!.uid).get();

// final notificationController = Get.put(FirebaseNotificationController());
// notificationController.updateUser();
        Get.offAll(() =>  BottomNavUser());

      }else if(selectedOptions=="Rider"){
        email="rider_"+email;
        UserCredential userCredential=await _auth.signInWithEmailAndPassword(
            email: email, password: password);


        DocumentSnapshot<Map<String, dynamic>> userSnapshot =
        await FirebaseFirestore.instance.collection('rider').doc(userCredential.user!.uid).get();
        if (userSnapshot.exists && userSnapshot.data()!.containsKey('status') && userSnapshot.data()?['status'] == "Accepted") {
          // Location is set, navigate to the main screen
          Get.offAll(() => const BottomNavRider());
        } else {
          // Location is not set, navigate to the location selection screen
          Get.offAll(() => UploadDoc());
        }
        // DocumentSnapshot<Map<String, dynamic>> userSnapshot =
        // await FirebaseFirestore.instance.collection('rider').doc(userCredential.user!.uid).get();
        // Get.offAll(() => const BottomNavRider());

      }else if(selectedOptions=="Admin"){
        email="admin_"+email;
        UserCredential userCredential=await _auth.signInWithEmailAndPassword(
            email: email, password: password);
        DocumentSnapshot<Map<String, dynamic>> userSnapshot =
        await FirebaseFirestore.instance.collection('admin').doc(userCredential.user!.uid).get();
        Get.offAll(() => const BottomNavAdmin());

      }

      else if(selectedOptions=="Station"){
        email="station_"+email;
        UserCredential userCredential=await _auth.signInWithEmailAndPassword(
            email: email, password: password);
        DocumentSnapshot<Map<String, dynamic>> userSnapshot =
        await FirebaseFirestore.instance.collection('station').doc(userCredential.user!.uid).get();
        if (userSnapshot.exists && userSnapshot.data()!.containsKey('location') && userSnapshot.data()?['location'] != null) {
          // Location is set, navigate to the main screen
          Get.offAll(() => const BottomNavigationBarExample());
        } else {
          // Location is not set, navigate to the location selection screen
          Get.offAll(() => StationLocationPickerScreen(stationId: userCredential.user!.uid,));
        }
        // Get.offAll(() => const BottomNavigationBarExample());

      }
    }on FirebaseAuthException catch(e){
      print("I EROORR ${e}");
      SignupWithEmailPasswordFailure failure= SignupWithEmailPasswordFailure.code(e.code);
      print("FIREBASE EXCEPTIONpp ${failure.message}");
      print(e.code);
      return failure.message;
    }catch(_){}
  }

  Future<void> deleteRider(String riderId) async {
    try {
      await FirebaseFirestore.instance.collection('rider').doc(riderId).delete();
      // Handle successful deletion
    } catch (e) {
      // Handle any errors
      print('Error deleting rider: $e');
    }
  }

  Future<void> deleteStation(String stationId) async {
    try {
      await FirebaseFirestore.instance.collection('station').doc(stationId).delete();
      var collection = FirebaseFirestore.instance.collection('station').doc(stationId).collection('service');
      var snapshots = await collection.get();
      for (var doc in snapshots.docs) {
        await doc.reference.delete();
      }
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      CollectionReference orders = firestore.collection('orders');

      // Query the orders collection for orders with the specified stationId
      QuerySnapshot querySnapshot = await orders.where('ShopID', isEqualTo: stationId).get();

      // Iterate over the documents and delete each one
      for (QueryDocumentSnapshot doc in querySnapshot.docs) {
        await doc.reference.delete();
      }
      // Handle successful deletion
    } catch (e) {
      // Handle any errors
      print('Error deleting rider: $e');
    }
  }

  Future<void> deleteUser(String userId) async {
    try {
      await FirebaseFirestore.instance.collection('users').doc(userId).delete();
      var collection = FirebaseFirestore.instance.collection('users').doc(userId).collection('notifications');
      var snapshots = await collection.get();
      for (var doc in snapshots.docs) {
        await doc.reference.delete();
      }
      // Handle successful deletion
    } catch (e) {
      // Handle any errors
      print('Error deleting rider: $e');
    }
  }
  Future<void> logout() async => await _auth.signOut();
}

