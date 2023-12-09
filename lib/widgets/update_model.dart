import 'package:fix_fill/Controller/shop_controller.dart';
import 'package:fix_fill/model/ListUpdateModel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../station/shop.dart';

class UpdateItemDialog extends StatefulWidget {
  // const UpdateItemDialog({super.key});

  String items;
  bool isFuel;
  //
  UpdateItemDialog({required this.items, required this.isFuel});

  @override
  _UpdateItemDialogState createState() => _UpdateItemDialogState();
}

class _UpdateItemDialogState extends State<UpdateItemDialog> {
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

  String selectedOption1 = 'Gas';
  List<String> dropdownOptions1 = ['Gas', 'Disel', 'Petrol',];

  String selectedOption2 = 'Tyre';
  List<String> dropdownOptions2 = ['Tyre', 'Oil', 'Key',];
  @override
  void initState() {

    super.initState();
    ShopController.instance.getItem(widget.isFuel,widget.items.toString()).then((shopData) {
      setState(() {
        priceController = TextEditingController(text: shopData.price.toString());
        quantityController = TextEditingController(text: shopData.quantity.toString());
        widget.isFuel? selectedOption1:selectedOption2 = shopData.category.toString();
      });
    });
  }
  Widget w() {
    if(widget.isFuel){
    return TextFormField(
      controller: quantityController,
      decoration: InputDecoration(labelText: 'Add Quantity'),
      keyboardType: TextInputType.number,
      onChanged: (value) {
        quantity = int.tryParse(value) ?? 1;
      },
    );}
    else{
      return Text("");
    }
  }
  @override
  Widget build(BuildContext context) {

    String abc= widget.isFuel? selectedOption1:selectedOption2;
    List<String> xyz=widget.isFuel? dropdownOptions1:dropdownOptions2;
    // ShopController.instance.getItem(item.id);

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
                const Text("Update Fuel",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20.0)
                ),
                DropdownButton<String>(
                  // initialSelection: dropdownOptions.first,
                    value: abc,
                    onChanged: (String? newValue) {
                      setState(() {
                        abc = newValue!;
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
                    items: xyz.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList()),
                TextFormField(
                  controller: priceController,
                    decoration: const InputDecoration(labelText: 'Add Price'),
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    onChanged: (value) {
                      price = double.tryParse(value) ?? 0.0;
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your name';
                      }
                      else{
                        return null;
                      }

                    }
                ),
                TextFormField(
                  controller: quantityController,
                  decoration: InputDecoration(labelText: 'Add Quantity'),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    quantity = int.tryParse(value) ?? 1;
                  },
                ),
                // w(),

                SizedBox(height: 20),
                Row(

                  children: [
                    SizedBox(width: 20),

                    TextButton(

                      onPressed: () => Navigator.of(context).pop(), // Close the dialog
                      child: Text('Cancel'),
                    ),
                    ElevatedButton(
                      onPressed: (){
                        if (_formkey.currentState!.validate()) {
                          // FirebaseAuth.instance.signInWithEmailAndPassword(
                          // email: controller.email.text.trim(),
                          // password: controller.password.text.trim(),
                          // selectedOption:selectedOption);
                          // }
                          // }

// bool isFuel=true;
                          ShopController.instance.updateList(widget.isFuel,widget.items,
                            double.parse(priceController.text),
                            int.parse(quantityController.text),
                            widget.isFuel? selectedOption1:selectedOption2
                            ,);
                          Navigator.of(context).pop();
                          // setState(() {
                          //   Shop(isFuel:isFuel);
                          // });

                        }
                      },
                      // onPressed: () {
                      //   // Logic to handle 'Add' action
                      // },
                      child: Text('Update'),
                    ),

                  ],
                )

              ],
            ),)),
    );
  }
}
