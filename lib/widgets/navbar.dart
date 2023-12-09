import 'package:firebase_auth/firebase_auth.dart';
import 'package:fix_fill/Controller/notification_controller.dart';
import 'package:fix_fill/user/notification_user.dart';
import 'package:fix_fill/user/userdetail.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';




class NavBar extends StatefulWidget {
  const NavBar({Key? key}) : super(key: key);


  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  // final controller = Get.put(FirebaseNotificationController());

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Text(

              'User Info',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            title: Text('Notifications'),
            onTap: () {
              Navigator.push(context,MaterialPageRoute(builder: (context)=>NotificationPage()));

              // Navigate to the Home Page
              // Navigator.pop(context); // Close the drawer
            },
          ),
          ListTile(
            title: Text('Settings'),
            onTap: () {
              // Navigate to the Settings Page (You can replace it with your own route)
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => UserDetailsScreen()),
              );// Close the drawer
            },
          ),ListTile(
            title: Text('Logout'),
            onTap: () {

              FirebaseAuth.instance.signOut();
              // final notificationController = Get.put(FirebaseNotificationController());
              // notificationController.updateUser();
              // notificationController.updateUser();

              // Navigate to the Settings Page (You can replace it with your own route)
              Navigator.pop(context); // Close the drawer
            },
          ),
        ],
      ),
    );
  }
  }

