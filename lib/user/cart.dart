import 'package:fix_fill/Controller/cart_controller.dart';
import 'package:fix_fill/Controller/shop_controller.dart';
import 'package:fix_fill/model/CartData.dart';
import 'package:fix_fill/user/checkout.dart';
import 'package:fix_fill/widgets/navbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final controller = Get.put(CartController());
  double total = 0.0;

  @override
  Widget build(BuildContext context) {
    CartController.instance.groupCartItems(); // Call this here or in initState

    return Scaffold(
      appBar: AppBar(
        title: Text('Your Cart'),
      ),
      body: ListView.builder(
        itemCount: CartController.instance.groupedItems.keys.length,
        itemBuilder: (context, index) {
          String stationId = CartController.instance.groupedItems.keys.elementAt(index);
          // Future <String?> ShopName=;
          List<CartItem> stationItems = CartController.instance.groupedItems[stationId]!;
          double stationTotal = stationItems.fold(0, (sum, item) {
            sum=sum + (item.price * item.quantity);
            return sum;
          });

          return ExpansionTile(
            title:FutureBuilder<String>(
              future: ShopController.instance.getStationName(stationId),
              builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Text('Loading...'); // or any other placeholder you prefer
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  return Text('Station: ${snapshot.data}');
                }
              },
            ),
            children: <Widget>[
              ...stationItems.map((item) => ListTile(
                title: Text(item.category),
                subtitle: Text('Quantity: ${item.quantity}'),
                trailing: Text('${item.price}'),
              )).toList(),
              ListTile(
                title: Text("Station Total = ${stationTotal.toString()}"),
                trailing: ElevatedButton(
                    onPressed: () {
                      // Handle checkout logic for this station
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Checkout(total: stationTotal, stationId: stationId)),
                      );
                    },
                    child: Text("Proceedd To Checkout")
                ),
              ),
            ],
          );
        },
      ),
    );
  }
















// ===========================
  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     appBar: AppBar(
  //       title: Text('Yourr Cart'),
  //     ),
  //     body: ListView.builder(
  //       itemCount: CartController.instance.items.length,
  //       itemBuilder: (context, index) {
  //                   final item = CartController.instance.items[index];
  //
  //
  //         return ExpansionTile(
  //           title: Text('Station: ${item.shopID}'),
  //           children: <Widget>[
  //             ListTile(
  //               title: Text(item.category),
  //               subtitle: Text('Quantity: ${item.quantity}'),
  //               trailing:  Column(
  //                 mainAxisAlignment: MainAxisAlignment.center,
  //                 children: [
  //                   Text('\$${item.price}'),
  //
  //     // Text("Total =${total=CartController.instance.totalPrice}"),
  //         Text("Total =${total=item.price*item.quantity}"),
  //
  //
  //
  //
  //                   ElevatedButton(
  //                       onPressed: () {
  //                         print(total);
  //                         // Handle checkout logic for this station
  //                         Navigator.push(
  //                           context,
  //                           MaterialPageRoute(builder: (context) => Checkout(total: total,stationId: item.shopID)),
  //                         );
  //                       },
  //                       child: Text("Proceed To Checkout")
  //                   ),
  //                 ],
  //               ),
  //               // Add actions if needed
  //             )]);
  //
  //
  //           // ],
  //         // );
  //       // }).toList(),
  //   // ),
  //
  // },
  //     ),
  //   );
  // }
}

//   @override
//   Widget build(BuildContext context) {
//     // final CartController cartController = Get.find<CartController>();
//     // final controller=Get.put(CartController());
//     return Scaffold(
//       appBar: AppBar(title: Text('Yourr Cart')),
//       body:  Container( padding: EdgeInsets.fromLTRB(25,20,25,25),
//     child: Center(
//     child: Column(
//     children: <Widget>[
//       Container(
//         height: 300.h,
//         width: 300.w,
//
//         child:
//       ListView.builder(
//         itemCount: CartController.instance.items.length,
//         itemBuilder: (context, index) {
//
//           final item = CartController.instance.items[index];
//           return Row(
//               children: <Widget>[
//                 Expanded(child:
//                 ListTile(
//             title: Text(item.category),
//             subtitle: Text('Quanttity: ${item.quantity}'),
//             trailing: Text('\$${item.price}'),
//
//             // Add buttons or gestures to remove or update items
//           )),
//               ElevatedButton(onPressed: (){
//                 CartController.instance.removeItem(item.id);
//
//               }, child: Text("Remove"))
//               ]);
//
//         },
//
//       )),
//       Text("Total =${total=CartController.instance.totalPrice}"),
//       ElevatedButton(onPressed:(){
//         Navigator.push(
//           context,
//           MaterialPageRoute(builder: (context) => Checkout( total: total,)),
//         );
// }, child: Text("Proceed To checkout"))
//     ])
//       // bottomNavigationBar: Obx(() => Text('Total Price: \$${cartController.totalPrice}')),
//
//       )));
//   }
// }
