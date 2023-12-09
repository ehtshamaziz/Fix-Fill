import 'package:firebase_core/firebase_core.dart';
import 'package:fix_fill/Controller/cart_controller.dart';
import 'package:fix_fill/Controller/notification_controller.dart';
import 'package:fix_fill/Repository/Authentication_Repository/authentication_repository.dart';
import 'package:fix_fill/Auth/Welcome.dart';
import 'package:fix_fill/Repository/Shop_Repository/shop_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';

Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp().then((value) => Get.put(AuthenticationRepository()));
  Get.put(ShopRepository());
  Get.put(FirebaseNotificationController());
  // Get.put(FirebaseNotificationController());

  Stripe.publishableKey = 'pk_test_51OHpu1BUs4cwQXC7zcYy41Du0CXyZMeRQ5ELDopcj5SwjbK19KorZSWLfN3b6LPwm25tK1cuPO1XUCDi7wV9hDUJ00ngcaYzlq';
  // await Stripe.instance.applySettings();
  runApp(const home());
}

class home extends StatefulWidget {
  const home({Key? key}) : super(key: key);

  @override
  State<home> createState() => _homeState();
}

class _homeState extends State<home> {
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: const Size(360, 690),
        minTextAdapt: true,
        splitScreenMode: true,
    // Use builder only if you need to use library outside ScreenUtilInit context
        builder: (_ , child) {
       return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Fix & Fill',

      theme: ThemeData(
        // primaryColor:Color(0XE214C5FF), colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.blue).copyWith(secondary: Colors.indigo),
        // hintColor: Color(0XFF233C63)
      ),
      home: Welcome(),
    );}
    );}
  }
