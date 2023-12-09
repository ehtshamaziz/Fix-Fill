import 'package:fix_fill/Controller/shop_controller.dart';
import 'package:fix_fill/constants.dart';
import 'package:fix_fill/user/select_service.dart';
import 'package:fix_fill/widgets/tab_bar.dart';
import 'package:fix_fill/widgets/update_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';

import '../model/ListItemModel.dart';

import 'package:ionicons/ionicons.dart';

import '../model/ListedStationModel.dart';
class ListedStation extends StatelessWidget {
  // const Listed({Key? key}) : super(key: key);

  final ListStationModel item;

  ListedStation({required this.item});

  @override
  Widget build(BuildContext context) {
    // print(item.price);
    return GestureDetector(
        onTap: () {
          print(item);
          Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => TabBars(id:item.id)),
        );
           // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>TabBars(id:item.id)),);
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
                      image: AssetImage('assets/GasStation.jpg'), // Your image asset
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      SizedBox(height: 10),

                      Text(("${item.name}").toString(), // Replace with item name
                        style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
                      ),
                      if (item.distance != null)
                        Text("${item.distance!.toStringAsFixed(2)} km away"),

                      // Add more widgets here if you need
                    ],

                  ),

                ),



              ]),

        ));
  }
}

