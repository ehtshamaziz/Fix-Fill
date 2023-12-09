import 'package:fix_fill/Controller/cart_controller.dart';
import 'package:fix_fill/Controller/shop_controller.dart';
import 'package:fix_fill/model/CartData.dart';
import 'package:fix_fill/model/ListItemModel.dart';
import 'package:fix_fill/widgets/navbar.dart';
import 'package:fix_fill/widgets/tab_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ionicons/ionicons.dart';

import '../model/ListedStationModel.dart';

class SideServices extends StatefulWidget {

  // final ListItemModel item;
  String id;
  SideServices({required this.id});

  @override
  State<SideServices> createState() => _SideServicesState();
}

class _SideServicesState extends State<SideServices> {
  final controller=Get.put(CartController());
  String itemName = '';
  double price = 0.0;
  int quantity = 1;
  int _counter = 0;
  double totalPrice=0.0;
  String id="11";
  String category="";
  TextEditingController priceController = TextEditingController(text: "");

  bool abc=false;
  TextEditingController quantityController = TextEditingController(text: "");
  TextEditingController categoryController = TextEditingController(text: "");
  final Controller= Get.put(ShopController());
// 'Petrol' is selected by defaul
  List<Service> filteredItems = [];
  // ShopController.instance.getListUser();
  @override
  void initState() {

    super.initState();
    executeLogic();

  }

  void executeLogic() {

    ShopController.instance.getListUser(widget.id,true).then((shopData) {
      setState(() {
        print("nigggaaa ${shopData}");
        filteredItems = shopData.where((item) => item.fuel == false).toList();
        // for(int i=0;i<shopData.length;i++) {
        // quantity=shopData.quantity[i];
        // print("Quantities is ==$quantity");
        //
        // }
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    print("Hellooo ${filteredItems}");

    void _incrementCounter(int quantity) {
      if(_counter<quantity){
        setState(() {
          print("abc");
          _counter++;
          // return _counter;
          print(price);
          totalPrice=price.toDouble()*_counter.toDouble();
          print(totalPrice);
          print(_counter);
        });
      }
      else{
        // return null;
        print("This service is not available now");
      }
    }

    void _decrementCounter(int quantity) {
      if(_counter>0){
        setState(() {
          totalPrice=totalPrice-price.toDouble();
          _counter--;
        });
      }

    }


    return Scaffold(

      backgroundColor: Colors.white,
      body: Container(margin: EdgeInsets.all(4.0),
          // padding: EdgeInsets.all(16.0),
          // decoration: BoxDecoration(
          //     color: Colors.white,
          //     borderRadius: BorderRadius.circular(10.0),
          //     boxShadow: [
          //       BoxShadow(
          //         color: Colors.grey.withOpacity(0.5),
          //         spreadRadius: 2,
          //         blurRadius: 2,
          //         offset: Offset(0,3),
          //       )
          //     ]
          //
          // ),
          padding: EdgeInsets.fromLTRB(25,20,25,25),
          child: Center(
            child: Column(
                children: <Widget>[
Container(
                height: 400.h,
                width: 500.w,

                child:
    ListView.builder(
    itemCount: filteredItems.length,
    itemBuilder: (context, index) {
    final item = filteredItems[index];
    return Container(
      margin: EdgeInsets.all(8.0),
      padding: EdgeInsets.all(8.0),
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

    child:Row(
        children: <Widget>[
          Container(

            width: 70.0, // Set your desired width
            height: 70.0, // Set your desired height
            decoration: BoxDecoration(

              borderRadius: BorderRadius.circular(15.0), // Adjust the radius here for your desired curve
              image: DecorationImage(
                image: AssetImage('assets/GasStation.jpg'), // Your image asset
                fit: BoxFit.cover,
              ),

            ),
          ),
          Expanded(child:

          ListTile(

            title: Text(item.category),
            subtitle: Text('\$${item.price}'),
            trailing: Text('Quantity: ${item.quantity}'),

            // Add buttons or gestures to remove or update items
          )),
          Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ElevatedButton(
                  onPressed: (){
      setState(() {
      if (item.counter > 0) {

        abc=false;
        item.counter--;}
      CartController.instance.updateItemQuantity(item.id, item.counter);
      });
      // CartController.instance.removeItem(item.id);
      // _decrementCounter(item.quantity);},
      },style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.all(4), // Adjust padding to reduce the size
                  minimumSize: Size(20, 20),  // Adjust minimum size of the button
                ),
                  child: Icon(Icons.remove),

                ),
                Text(
                  '${item.counter}',
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                ),
                // SizedBox(width: 10),
                ElevatedButton(
                  onPressed:(){
                    setState(() {
                      print(_counter);
                      print(item.quantity);
                      if(item.counter<item.quantity) {
                        print("Quantity adddeddd");
                        if (item.counter == 0) {
                          item.counter++;

                          CartController.instance.addItem(CartItem(
                            id: item.id,
                            category: item.category,
                            price: item.price,
                            quantity: item.counter,
                            shopID: widget.id, // or some selected quantity
                          ));
                        }

                        else {
                          item.counter++;
                          abc=false;
                          CartController.instance.updateItemQuantity(
                              item.id, item.counter);
                        }
                      }
                      else{
                        setState(() {
                          abc=true;

                        });
                      }
                    });
                    // _incrementCounter(item.quantity);
                    // CartController.instance.addItem(CartItem(
                    //   id: item.id,
                    //   category: item.category,
                    //   price: item.price,
                    //   quantity:  _counter,// or some selected quantity
                    // ));
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.all(4), // Adjust padding to reduce the size
                    minimumSize: Size(20, 20),  // Adjust minimum size of the button
                  ),
                  child: Icon(Icons.add),
                ),

                abc
                    ?Text("Not available",style: TextStyle(fontWeight: FontWeight.w400,color: Colors.red, fontSize: 15),):
                Container(),
              ]),

        ]));
    })),


                        SizedBox(height: 10),

                        // ElevatedButton.icon(
                        //   onPressed: () {
                        //
                        //     // CartItem product={id: id, category:"fad", price: price, quantity: quantity} as CartItem;
                        //     // ... more products
                        //     // ];
                        //
                        //     CartController.instance.addItem(CartItem(
                        //       id: id,
                        //       category: category,
                        //       price: totalPrice,
                        //       quantity:  _counter,// or some selected quantity
                        //     ));
                        //     setState(() {
                        //       totalPrice=0.0;
                        //       _counter=0;
                        //
                        //     });
                        //     // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> TabBars()),);
                        //     // Your button tap logic here
                        //   },
                        //   icon: Icon(Ionicons.cart), // The icon you want on your button
                        //   label: Text('Add'), // The text label for your button
                        //   style: ElevatedButton.styleFrom(
                        //
                        //     primary: Colors.green, // Button color
                        //     onPrimary: Colors.white, // Text color
                        //   ),
                        // ),



                      ],

                    ),
                  )

            ),









    );

  }
}
