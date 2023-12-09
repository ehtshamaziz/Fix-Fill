import 'package:fix_fill/Auth/Welcome.dart';

import 'package:fix_fill/station/orders.dart';
// import 'package:fix_fill/station/shop.dart';
import 'package:fix_fill/Auth/signup.dart';
import 'package:fix_fill/station/shop.dart';
// import 'package:fix_fill/station/stations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:ionicons/ionicons.dart';

import '../Controller/notification_controller.dart';
import '../user/cart.dart';
import '../user/dashboard.dart';
import '../user/user_orders.dart';


class BottomNavUser extends StatelessWidget {

  // late final Widget body;

   BottomNavUser({super.key});
  // var controllers;
  // @override
  // void init(){
  //   controllers = Get.put(FirebaseNotificationController());
  //
  // }



  @override
  Widget build(BuildContext context) {

// Call this when a user logs in or out

    // NavigationDestinationLabelBehavior.onlyShowSelected;
    bool isFuelTrue=true;
    bool isFuelFalse=false;
    List<Widget> _NavScreens() {
      return [
        // const Shop(),


        dashboard(),
        UserOrders(),
        CartScreen(),



      ];
    }


    List<PersistentBottomNavBarItem> _navBarsItems() {
      return [
        PersistentBottomNavBarItem(
          icon: Icon(Ionicons.home),
          title: ("Stations"),
          activeColorPrimary: CupertinoColors.activeBlue,
          inactiveColorPrimary: CupertinoColors.systemGrey,
        ),

        PersistentBottomNavBarItem(
          icon: Icon(Ionicons.book),
          title: ("Orders"),
          activeColorPrimary: CupertinoColors.activeBlue,
          inactiveColorPrimary: CupertinoColors.systemGrey,
        ),
        PersistentBottomNavBarItem(
          icon: Icon(Ionicons.cart),
          title: ("Cart"),
          activeColorPrimary: CupertinoColors.activeBlue,
          inactiveColorPrimary: CupertinoColors.systemGrey,
        ),


      ];
    }
    PersistentTabController _controller;
    _controller=PersistentTabController(initialIndex: 0);

    return Center(
      child: PersistentTabView(
        context,
        controller: _controller,
        screens: _NavScreens(),
        items: _navBarsItems(),
        confineInSafeArea: true,
        backgroundColor: Colors.white, // Default is Colors.white.
        handleAndroidBackButtonPress: true, // Default is true.
        resizeToAvoidBottomInset: true, // This needs to be true if you want to move up the screen when keyboard appears. Default is true.
        stateManagement: true, // Default is true.
        hideNavigationBarWhenKeyboardShows: true, // Recommended to set 'resizeToAvoidBottomInset' as true while using this argument. Default is true.
        decoration: NavBarDecoration(
          borderRadius: BorderRadius.circular(10.0),
          colorBehindNavBar: Colors.white,
        ),
        popAllScreensOnTapOfSelectedTab: true,
        popActionScreens: PopActionScreensType.all,
        itemAnimationProperties: ItemAnimationProperties( // Navigation Bar's items animation properties.
          duration: Duration(milliseconds: 200),
          curve: Curves.ease,
        ),
        screenTransitionAnimation: ScreenTransitionAnimation( // Screen transition animation on change of selected tab.
          animateTabTransition: true,
          curve: Curves.ease,
          duration: Duration(milliseconds: 200),
        ),
        navBarStyle: NavBarStyle.style1, // Choose the nav bar style with this property.
      ),
    );

  }


}