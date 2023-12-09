import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class FirebaseNotificationController extends GetxController {
  var notificationCount = RxInt(0);
  StreamSubscription<User?>? _authStateSubscription;
  StreamSubscription<QuerySnapshot>? _notificationSubscription;

  @override
  void onInit() {
    super.onInit();
    _authStateSubscription = FirebaseAuth.instance.authStateChanges().listen(_onAuthStateChanged);
  }

  void _onAuthStateChanged(User? user) {
    if (user != null) {
      _setNotificationListener(user.uid);
    } else {
      notificationCount.value = 0;
      _notificationSubscription?.cancel();
    }
  }

  void _setNotificationListener(String userId) {
    _notificationSubscription?.cancel(); // Cancel any existing subscription
    _notificationSubscription = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('notifications')
        .snapshots()
        .listen((snapshot) {
      notificationCount.value = snapshot.docs.length;
    });
  }

  @override
  void onClose() {
    _authStateSubscription?.cancel();
    _notificationSubscription?.cancel();
    super.onClose();
  }
}

