import 'package:fix_fill/Controller/shop_controller.dart';
import 'package:fix_fill/model/ListUpdateModel.dart';
import 'package:fix_fill/station/orders.dart';
import 'package:fix_fill/widgets/bottom_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../station/shop.dart';

class UpdateStatus extends StatefulWidget {
  // const UpdateItemDialog({super.key});

  String items;
  //
  UpdateStatus({required this.items,});

  @override
  _UpdateStatusState createState() => _UpdateStatusState();
}

class _UpdateStatusState extends State<UpdateStatus> {
  String itemName = '';
  double price = 0.0;
  int quantity = 1;
  // List<String> dropdownOptions = ['Gas', 'Disel', 'Petrol',];
  final _formkey=GlobalKey<FormState>();
  final controller= Get.put(ShopController());
  static ShopController get instance => Get.find();

  TextEditingController priceController = TextEditingController(text: "");
  TextEditingController quantityController = TextEditingController(text: "");
  TextEditingController categoryController = TextEditingController(text: "");
  // late String selectedOption="Gas";

  // String selectedOption1 = 'Gas';
  String selectedOption="Pending";

  List<String> dropdownOptions = ['Pending', 'Delivered', 'In-progress',];
  String statusID="";
  String userID="";
  // String selectedOption2 = 'Tyre';
  // List<String> dropdownOptions2 = ['Tyre', 'Oil', 'Key',];
  @override
  void initState() {

    super.initState();
    ShopController.instance.getOrder(widget.items.toString()).then((shopData) {
      setState(() {
        print("dataaaaaaaaaaa ${shopData.Status}");
        userID=shopData.userID;
        print("helpp ${userID}");
        statusID=shopData.id;
        selectedOption= shopData.Status;
        // priceController = TextEditingController(text: shopData.price.toString());
        // quantityController = TextEditingController(text: shopData.quantity.toString());

      });
    });
  }

  @override
  Widget build(BuildContext context) {


    return Dialog(
      backgroundColor: Colors.white, // Set the background color to white

      child: Container(
          width: MediaQuery.of(context).size.width * 0.8, // 80% of screen width
          padding: EdgeInsets.all(50.0),
          child:Form(
            key: _formkey,
            child: Column(

              mainAxisSize: MainAxisSize.min,
              children: <Widget>[

                const Text("Update Status",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20.0)
                ),
                DropdownButton<String>(
                  // initialSelection: dropdownOptions.first,
                    value: selectedOption,
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedOption = newValue!;
                      });
                    },
                    style: const TextStyle(
                      // You can customize the text style here
                      color: Colors.black,
                      fontSize: 16.0,
                    ),
                    underline: Container(
                      // You can customize the underline (border) here
                      height: 2,
                      color: Colors.blueAccent,
                    ),
                    isExpanded: true,
                    items: dropdownOptions.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList()),


                SizedBox(height: 20),
                Row(
                  children: <Widget>[
SizedBox(width: 30,),
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(), // Close the dialog
                      child: Text('Cancel'),
                    ),
                    ElevatedButton(
                      onPressed: (){
                        if (_formkey.currentState!.validate()) {

                          ShopController.instance.updateStatus(statusID,selectedOption,userID);
                          Navigator.of(context).pop();
                          setState(() {
                            print("Ancc");
                            // initState();
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>BottomNavigationBarExample()));
                            // Shop(isFuel:true);
                            print("BBBB");
                          });

                        }
                      },

                      child: Text('Update'),
                    ),
                  ],
                ),

              ],
            ),)),
    );
  }
}
