import 'package:fix_fill/Controller/shop_controller.dart';
import 'package:fix_fill/constants.dart';
import 'package:fix_fill/station/shop.dart';
import 'package:fix_fill/widgets/bottom_nav_bar.dart';
import 'package:fix_fill/widgets/update_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';

import '../model/ListItemModel.dart';

import 'package:ionicons/ionicons.dart';
class ListedShop extends StatelessWidget {
  // const Listed({Key? key}) : super(key: key);

  final ListItemModel item;
final bool isFuel;

  ListedShop({required this.item,required this.isFuel});


  Widget w(){
    if(isFuel==true){

      return Text((item.quantity).toString(), // Replace with item details
        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
      );
    }
    else{
      return Text("");
    }
  }
  @override
  Widget build(BuildContext context) {

    // print(item.price);
    return GestureDetector(
        onTap: () {
          print('Tapped!');
        },
        child:Container(
          margin: EdgeInsets.all(8.0),
          padding: EdgeInsets.all(16.0),
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(

                  width: 70.0, // Set your desired width
                  height: 70.0, // Set your desired height
                  decoration: BoxDecoration(

                    borderRadius: BorderRadius.circular(15.0), // Adjust the radius here for your desired curve
                    image: DecorationImage(
                      image:
                      isFuel
                          ?AssetImage('assets/petrol.jpg'):AssetImage('assets/service.jpg'), // Your image asset
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text((item.category).toString(), // Replace with item name
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 4),
                      Text(("${item.price} \$").toString(), // Replace with item details
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                      ),
                      item.quantity==0
                          ?Text("Quantity is 0, please update",style: TextStyle(fontSize: 14, color: Colors.grey[600]))
                      :Text(("${item.quantity} qty").toString(), // Replace with item details
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                      ),

                     // w(),

                      // Add more widgets here if you need
                    ],

                  ),

                ),
                IconButton(
                  icon:const Icon(Ionicons.pencil),
                  color: Colors.blue,
                  onPressed: () {
                   // ShopController.instance.getItem(item.id);
                    _showUpdateItemModal(context,items: item.id,isFuel:isFuel);

                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> Shop(isFuel:isFuel)));

                    // (UpdateItemDialog( items: item.id));
                  },
                ),
                IconButton(
                  icon:const Icon(Ionicons.trash_bin),
                  color: Colors.red,
                  onPressed: () {
                    // setState((){
                    //   Navigator.push(context, MaterialPageRoute(builder: (context)=>BottomNavigationBarExample()));
                    //
                    // });
                    ShopController.instance.delete(item.id);
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> Shop(isFuel:isFuel)));



                  },
                ),


              ]),

        ));
  }
}
void _showUpdateItemModal(BuildContext context, {required bool isFuel, required String items}) {
  // showModalBottomSheet
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return UpdateItemDialog(items:items,isFuel:isFuel);
    },
  );
}
