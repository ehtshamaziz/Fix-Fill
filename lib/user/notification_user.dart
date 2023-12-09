import 'package:firebase_auth/firebase_auth.dart';
import 'package:fix_fill/Controller/notification_controller.dart';
import 'package:fix_fill/Controller/shop_controller.dart';
import 'package:fix_fill/model/notification.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NotificationPage extends StatelessWidget {
  @override
  @override
  Widget build(BuildContext context) {
    // final NotificationController notificationController = Get.find();
    String userrUid = FirebaseAuth.instance.currentUser!.uid;
    print(userrUid);

    return Scaffold(
      appBar: AppBar(title: Text("Notifications")),
      body: FutureBuilder<List<NotificationModel>>(
        future: ShopController.instance.fetchUserNotifications(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }
          if (snapshot.hasError) {
            return Text("Error: ${snapshot.error}");
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text("No notifications!!",style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),));
          }

          List<NotificationModel> notifications = snapshot.data!;
          // var notifications = notificationController.notifications
          //     .where((notification) => notification.id == userrUid)
          //     .toList();

          if (notifications.isEmpty) {
            return Center(child: Text("No notifications"));
          }
          return ListView.builder(
            itemCount: notifications.length,
            itemBuilder: (context, index) {
              var notification = notifications[index];
              return ListTile(
                title: Text(notification.title),
                subtitle: Text(notification.description),
                // Trailing with formatted dateTime
              );
            },
          );
        },
      ),
    );
  }
}




