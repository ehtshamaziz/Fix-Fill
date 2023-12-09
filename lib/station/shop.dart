// ignore_for_file: camel_case_types

import 'package:firebase_auth/firebase_auth.dart';
import 'package:fix_fill/Controller/shop_controller.dart';
import 'package:fix_fill/model/ListItemModel.dart';

import 'package:fix_fill/widgets//bottom_nav_bar.dart';
import 'package:fix_fill/widgets//list.dart';
import 'package:fix_fill/widgets//navbar.dart';
import 'package:fix_fill/user/user.dart';
import 'package:fix_fill/widgets/add_model.dart';
import 'package:fix_fill/widgets/listing.dart';
import 'package:fix_fill/widgets/listing_shop.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';



class Shop extends StatefulWidget {
  bool isFuel ;

   Shop({ required this.isFuel});

  @override
  State<Shop> createState() => _ShopState();
}

class _ShopState extends State<Shop> {
  @override
  Widget build(BuildContext context) {


   Get.put(ShopController());
print(widget.isFuel);
    final Future<List<ListItemModel>> items =ShopController.instance.getList(widget.isFuel);

    return Scaffold(
      appBar: AppBar(
          title: const Text("FIX")
      ),
      drawer: const NavBar(),

      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.fromLTRB(10, 25, 25, 25),
          child:

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[

              // Text('This is main Stations', style: TextStyle(
              //   color: Theme
              //       .of(context)
              //       .colorScheme
              //       .secondary,
              //   fontSize: 18,
              //   fontWeight: FontWeight.bold,
              // ),),

              SizedBox(height: 20),




              FutureBuilder<List<ListItemModel>>(
                future: items,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Text("Error: ${snapshot.error}");
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Text("No items found");
                  } else {
                    return
                      SingleChildScrollView(
                        child:Container(
                          height: 500.h, // Adjusted height
                          width:400.w,
                          child: ListView.builder(

                      itemCount: snapshot.data!.length,

                      itemBuilder: (context, index) {
                        return ListedShop(item: snapshot.data![index],isFuel:widget.isFuel);
                      },
                    )));
                  }
                },
              ),




            ],
            // Container( ,)


          ),


        ),



      ),


      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddItemModal(context,widget.isFuel);
          // Add your onPressed code here!
        },
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add),
      ),
    );

  }

}



void _showAddItemModal(BuildContext context, bool isFuel) {
  // showModalBottomSheet
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AddItemDialog(isFuel:isFuel);
    },
  );
}

class Item {
  final String title;
  final String description;

  Item({required this.title, required this.description,l});
}
class CustomListItem extends StatelessWidget {
  final Item item;

  CustomListItem({required this.item});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      margin: EdgeInsets.all(8),
      child: ListTile(
        contentPadding: EdgeInsets.all(10),
        title: Text(item.title, style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(item.description),
        trailing: Icon(Icons.arrow_forward_ios),
        // You can add onTap or other interactions here
      ),
    );
  }
}
// }