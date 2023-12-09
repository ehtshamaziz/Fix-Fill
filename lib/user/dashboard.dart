// ignore_for_file: camel_case_types

import 'package:firebase_auth/firebase_auth.dart';
import 'package:fix_fill/Controller/notification_controller.dart';
import 'package:fix_fill/model/ListUpdateModel.dart';
import 'package:fix_fill/model/ListedStationModel.dart';
import 'package:fix_fill/user/notification_user.dart';
import 'package:fix_fill/user/user_select_location.dart';
import 'package:fix_fill/widgets//navbar.dart';
import 'package:fix_fill/widgets/notification_icon.dart';
import 'package:fix_fill/widgets/search.dart';
import 'package:fix_fill/widgets/station_listing.dart';
import 'package:fix_fill/widgets/tab_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../Controller/shop_controller.dart';
import '../model/ListItemModel.dart';
import '../widgets/listing.dart';



class dashboard extends StatefulWidget {
  const dashboard({Key? key}) : super(key: key);

  @override
  State<dashboard> createState() => _dashboardState();
}

class _dashboardState extends State<dashboard> {
  final TextEditingController _searchController = TextEditingController();


  var controller= Get.put(ShopController());

   Future<List<ListStationModel>> items =ShopController.instance.getStation();
   late LatLng selectedLocation;

  void _navigateAndPickLocation() async {
    LatLng? pickedLocation = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => UserGetScreen()),
    );

    if (pickedLocation != null) {
      print("Location existed");
      setState(() {
        selectedLocation = pickedLocation;
        items = ShopController.instance.getStation().then((stations) {
          for (var station in stations) {
            print("Station: ${station.name}, Lat: ${station.latitude}, Lng: ${station.longitude}");
            station.distance = station.distanceTo(pickedLocation);
          }
          // Sort stations by distance
          stations.sort((a, b) => a.distance!.compareTo(b.distance as num));
          print("Helppp ${stations}");
          return stations;
        });
      });
    }
  }
  // final FirebaseNotificationController notificationController = Get.find();
  @override
  Widget build(BuildContext context) {
    // notificationController.updateUser();
    final notificationController = Get.put(FirebaseNotificationController());
    return Scaffold(
      appBar: new AppBar(
        title: new Text("FIX"),
        actions: <Widget>[
          IconButton(
            icon: NotificationIcon(
              notificationCount: notificationController.notificationCount.value,
            ),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => NotificationPage()));
            },
          ),

        ],
      ),
      drawer: NavBar(),
        backgroundColor: Colors.white,
        body:CustomScrollView(
            slivers: [
        SliverToBoxAdapter( child:Container(
            padding: EdgeInsets.fromLTRB(25,5,25,25),
            child: Center(

                child: Column(
                    children: <Widget>[

                Row(
                children: <Widget>[
                      ElevatedButton(onPressed: (){

                        _navigateAndPickLocation();

                      }, child: Icon(Icons.pin_drop)),


                      Expanded(child: SearchBar(
                        hintText: "Search",
                        controller: _searchController,
                        // controller: controller,
                        padding: MaterialStateProperty.all<EdgeInsets>(
                            const EdgeInsets.symmetric(horizontal: 15)),

                        leading: const Icon(Icons.search),
                          onChanged: (value) {
                            setState(() {});
                          }
                      )),
                      ]),

                      SizedBox(height:20.h),

                      FutureBuilder<List<ListStationModel>>(
                        future: items,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return Center(child: CircularProgressIndicator());
                          } else if (snapshot.hasError) {
                            return Text("Error: ${snapshot.error}");
                          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                            return Text("No items found");
                          } else if(_searchController.text!=""){
                            String query = _searchController.text.toLowerCase();
                            List<ListStationModel> filteredStations = snapshot.data!
                                .where((station) => station.name.toLowerCase().contains(query))
                                .toList();
                            return
                              // SingleChildScrollView(
                                  Container(
                                      height: 500.h, // Adjusted height
                                      width:400.w,

                                      child: _buildStationList(filteredStations)
                                      );
    }else{
                            return
                              SingleChildScrollView(
                                  child:Container(
                                      height: 500.h, // Adjusted height
                                      width:400.w,
                                      child: ListView.builder(

                                        itemCount: snapshot.data!.length,

                                        itemBuilder: (context, index) {
                                          return
                                            ListedStation(item: snapshot.data![index]);
                                        },
                                      )));
                          }
                        },
                      ),









                    ]
                ),

              ),
            ),
          )
    ]));



  }


}
Widget _buildStationList(List<ListStationModel> stations) {
  print("Builderr");
  return ListView.builder(
    itemCount: stations.length,
    itemBuilder: (context, index) {
      final station = stations[index];
      return GestureDetector(

          onTap: () {
            print(station);
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => TabBars(id:station.id)),
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
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        Text((station.name).toString(), // Replace with item name
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        if (station.distance != null)
                          Text("${station.distance!.toStringAsFixed(2)} km away"),
                        SizedBox(height: 4),

                        // Add more widgets here if you need
                      ],

                    ),

                  ),



                ]),

          ));;
    },
  );
}