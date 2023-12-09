import 'package:flutter/material.dart';

import '../model/ListItemModel.dart';

class Listed extends StatelessWidget {
  // const Listed({Key? key}) : super(key: key);

  final ListItemModel item;

  Listed({required this.item});


  @override
  Widget build(BuildContext context) {
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
          CircleAvatar(
          radius: 30,
          backgroundImage: AssetImage('assets/avatar.png'), // Replace with your image asset or NetworkImage
        ),
          SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Text(item.quantity as String, // Replace with item name
                //   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                // ),
                // SizedBox(height: 4),
                // Text(
                //   item.quantity as String, // Replace with item details
                //   style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                // ),
                // Add more widgets here if you need
              ],
            ),
          ),


      ]),

    ));
  }
}
