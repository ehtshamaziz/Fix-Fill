
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fix_fill/Controller/shop_controller.dart';
import 'package:fix_fill/rider/orderDetail_screen.dart';
import 'package:fix_fill/widgets//navbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';



class RiderOrders extends StatefulWidget {
  const RiderOrders({Key? key}) : super(key: key);

  @override
  State<RiderOrders> createState() => _RiderOrdersState();
}

var controller =Get.put(ShopController());
String formatTimestamp(Timestamp timestamp) {
  var format = DateFormat('yyyy-MM-dd – kk:mm');
  return format.format(timestamp.toDate());
}
class _RiderOrdersState extends State<RiderOrders> {
  var controller =Get.put(ShopController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Rider"),
      ),
      drawer: NavBar(),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: ShopController.instance.AllOrders(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text("No orders foundd"));
          }

          List<Map<String, dynamic>> orders = snapshot.data!;
          return ListView.builder(
            itemCount: orders.length,
            itemBuilder: (context, index) {
              Map<String, dynamic> order = orders[index];
              String formattedDate = formatTimestamp(order['timestamp']);

              return Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 2,
                        offset: Offset(0,3),
                      )
                    ]

                ),

                margin: EdgeInsets.all(30),
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text("Order:",style:TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                      SizedBox(height: 10,),
                      Row(
                        children: [
                          Icon(Icons.check_circle_outline, color: Colors.green),
                          SizedBox(width: 8),
                          Text("Status: ${order['Status']}", style: TextStyle(fontSize: 16)),

SizedBox(width: 35,),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => OrderDetailScreen(order: order)));
                            },
                            style: ButtonStyle(
                           // Change the background color
                              textStyle: MaterialStateProperty.all<TextStyle>(
                                TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold), // Change the text style
                              ),
                              elevation: MaterialStateProperty.all<double>(4.0), // Change the elevation
                              shape: MaterialStateProperty.all<OutlinedBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0), // Change the border radius
                                ),
                              ),
                            ),
                            child: Text("Show Detail"),
                          ),
                        ],
                      ),
                      // Divider(height: 10, thickness: 1),
                      SizedBox(height: 20,),
                      Row(
                        children: [
                          Icon(Icons.attach_money, color: Colors.blue),
                          SizedBox(width: 8),
                          Text("Total Price: ${order['totalPrice']} \$", style: TextStyle(fontSize: 16)),
                          SizedBox(width: 35,),

                          ElevatedButton(onPressed: (){
                            ShopController.instance.ChangeOrderStatus(order['docID']);
                            setState(() {
                              RiderOrders();
                            });
                            },
                            // _showUpdateItemModal(context,items: order['docID']);
                            style: ButtonStyle(
                              // Change the background color
                              textStyle: MaterialStateProperty.all<TextStyle>(
                                TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold), // Change the text style
                              ),
                              elevation: MaterialStateProperty.all<double>(4.0), // Change the elevation
                              shape: MaterialStateProperty.all<OutlinedBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0), // Change the border radius
                                ),
                              ),
                            ), child:Text("Accept")),



                        ],
                      ),
                      // Divider(height: 10, thickness: 1),
                      SizedBox(height: 20,),


                    ],
                  ),
                ),
              );},

          );
        },
      ),
    );
  }
}
