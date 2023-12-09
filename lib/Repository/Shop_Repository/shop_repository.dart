import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fix_fill/Controller/cart_controller.dart';
import 'package:fix_fill/Controller/notification_controller.dart';
import 'package:fix_fill/model/ListItemModel.dart';
import 'package:fix_fill/model/ListedRiderModal.dart';
import 'package:fix_fill/model/ListedStationModel.dart';
import 'package:fix_fill/model/ListedUsersModel.dart';
import 'package:fix_fill/model/notification.dart';
import 'package:fix_fill/widgets/bottom_nav_bar.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../model/ListUpdateModel.dart';

class ShopRepository extends GetxController {
  static ShopRepository get instance => Get.find();
  final _auth= FirebaseAuth.instance;
  late final Rx<User?> firebaseUser;



  Future<void> addShop(bool isFuel, double price, int quantity, String selectedOption) async {
    print(price);

    try {

      // Retrieve the current user
      User? currentUser = FirebaseAuth.instance.currentUser;

      String userUid = currentUser!.uid;

      if (currentUser != null && currentUser.email != null) {
        // Merge the email with additional shop details
        // Map<String, dynamic> shopDetails = {
        //   'ownerEmail': currentUser.email,
        //   ...additionalShopDetails // Merging additional details passed to the function
        // };
        String shopId = FirebaseFirestore.instance.collection('station').doc(userUid).collection('service').doc().id;
if(isFuel==true) {
  await FirebaseFirestore.instance.collection('station').doc(userUid)
      .collection('service').doc(shopId)
      .set({
    'fuel':isFuel,
    'category': selectedOption,
    'price': price,
    'quantity': quantity,
  });
}
else{
  await FirebaseFirestore.instance.collection('station').doc(userUid)
      .collection('service').doc(shopId)
      .set({
    'fuel':isFuel,
    'category': selectedOption,
    'price': price,
    'quantity': quantity,

  });
}
        // Assuming 'shops' is the collection where you want to store shop details
        CollectionReference shops = FirebaseFirestore.instance.collection('station');

        // Adding or updating the shop details in Firestore using the user's UID as shopId
        // await shops.doc(currentUser.uid).set(shopDetails, SetOptions(merge: true));

        // Successfully added details
        print('Shop details added/updated for user: ${currentUser.email}');
      } else {
        print('No user logged in or email not available');
      }
    } catch (e) {
      // Handle any errors here
      print('Error adding shop details: $e');
    }
  }

  Future<List<ListItemModel>> getShop() async{
    try{
      print("zzzzz");
      List<ListItemModel> items = [];
      User? currentUser = FirebaseAuth.instance.currentUser;

      String userUid = currentUser!.uid;

      var collection = FirebaseFirestore.instance.collection('station').doc(userUid).collection('service');

      var querySnapshot = await collection.get();
// if(isFuel)
      for (var queryDocumentSnapshot in querySnapshot.docs) {
        Map<String, dynamic> data = queryDocumentSnapshot.data();

        // Assuming 'imagePath' is the name of the file in Firebase Storage
        // String imagePath = await FirebaseStorage.instance
        //     .ref('path_to_images/${data['imagePath']}')
        //     .getDownloadURL();

        // Create a new ListItemModel
// print(data['price']);
//         print(queryDocumentSnapshot.id);

        ListItemModel item = ListItemModel(
          // imagePath: imagePath,
          id:queryDocumentSnapshot.id,
          fuel:data['fuel'],
          category: data['category'],
          price: data['price'],
          quantity: data['quantity'],
        );

        items.add(item);
      }
      return items;
    }
    catch(e) {
      throw e;

    }
  }

  Future<List<Service>> fetchServices(String stationId) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    // Get a reference to the 'services' subcollection
    CollectionReference servicesRef = firestore.collection('station').doc(stationId).collection('service');

    QuerySnapshot querySnapshot = await servicesRef.get();

    print(querySnapshot.docs);
    // Map over the documents and convert each to a 'Service' object
    List<Service> services = querySnapshot.docs.map((doc) {
      return Service.fromSnapshot(doc); // Use fromSnapshot to include the ID
    }).toList();
print("Helpppp${services}");
    return services;
  }


  Future<ListItemModel> getShopUser(String ShopId) async{
    try{
      print("zzzzz");
      List<ListItemModel> items = [];
      User? currentUser = FirebaseAuth.instance.currentUser;

      String userUid = currentUser!.uid;

      var collection =await FirebaseFirestore.instance.collection('station').doc(ShopId).collection('service').doc("mxR4NXqd7bs9NQ7xdmM5");
      // var querySnapshot = await collection.get();
// if(isFuel)
      print(collection);
      var querySnapshot = await collection.get();

      // for (var queryDocumentSnapshot in querySnapshot.docs) {
        var data = querySnapshot.data() as Map<String, dynamic>; // Corrected line

        // Proceed to create ListItemModel instances
        ListItemModel item = ListItemModel(
          id: querySnapshot.id,
          fuel: data['fuel'],
          category: data['category'],
          price: data['price'],
          quantity: data['quantity'],
        );

          // items.add(item);
        // }
        return item;

    }
    catch(e) {
      throw e;

    }
  }

  Future<void> deleteShop(String shopId) async {
    try {
      // Assuming 'shopId' is the document ID of the shop you want to delete
      // and 'users' is your main collection with subcollection 'shops'
      String userUid = FirebaseAuth.instance.currentUser!.uid;
      await FirebaseFirestore.instance.collection('station').doc(userUid).collection('service').doc(shopId).delete();

      print("Shop with ID $shopId deleted successfully.");
    } catch (e) {
      print("Error deleting shop: $e");
    }
  }
  Future<ListUpdateModel> getServiceToUpdate(bool isFuel, String shopId) async {
    print(shopId);
    // Assuming you have the user's UID and the shop's ID
    String userUid = FirebaseAuth.instance.currentUser!.uid;
    DocumentSnapshot doc = await FirebaseFirestore.instance.collection('station').doc(userUid).collection('service').doc(shopId).get();

    if (doc.exists) {
      return ListUpdateModel.fromFirestore(doc);
    } else {
      // Handle the scenario where the document does not exist
      throw Exception('Document does not exist');
    }
  }

  Future<OrderModel> getOrderToUpdate( String shopId) async {
    print(shopId);
    // Assuming you have the user's UID and the shop's ID
    String userUid = FirebaseAuth.instance.currentUser!.uid;
    DocumentSnapshot doc = await FirebaseFirestore.instance.collection('orders').doc(shopId).get();

    print("hELOLOO ${doc.id}");
    if (doc.exists) {
      return OrderModel.fromFirestore(doc);
    } else {
      // Handle the scenario where the document does not exist
      throw Exception('Document does not exist');
    }
  }

  Future<void> updateService(bool fuel, String shopId, double newPrice, int newQuantity, String newCategory) async {
    try {
      // Assuming 'users' is your main collection with subcollection 'shops'
      String userUid = FirebaseAuth.instance.currentUser!.uid;

      // Prepare the new data
      Map<String, dynamic> updatedData = {
        'fuel':fuel,
        'price': newPrice,
        'quantity': newQuantity,
        'category': newCategory,
      };

      // Update the document in Firestore
      await FirebaseFirestore.instance.collection('station').doc(userUid).collection('service').doc(shopId).update(updatedData);

      print("Shop updated successfully.");
    } catch (e) {
      print("Error updating shop: $e");
    }
  }

  Future<String>getStationName(String statoinID) async {

    var collection=await FirebaseFirestore.instance.collection('station').doc(statoinID);
    var querySnapshot = await collection.get();
    var data = querySnapshot.data() as Map<String, dynamic>;
    return data['name'];
  }
  Future<void> updateStatus(String statusID, String Status, String userID) async {
    try {
      // final notificationController = Get.find<NotificationController>();

      // Assuming 'users' is your main collection with subcollection 'shops'
      String userrUid = FirebaseAuth.instance.currentUser!.uid;

      // Prepare the new data
      Map<String, dynamic> updatedData = {
        'Status':Status
      };

       var notification=NotificationModel(
        id: userID,
        title: "Order Status Updated",
        description: "Your order ${statusID} status changed to ${Status}.",
        dateTime: DateTime.now(),
      );
      // notificationController.addNotification(notification);
      print("Notification id will be ${userID}");

      CollectionReference users = FirebaseFirestore.instance.collection('users');
      DocumentReference userDoc = users.doc(userID);

      await userDoc.collection('notifications').add({
        'id':notification.id,
        'title': notification.title,
        'description': notification.description,
        'dateTime': notification.dateTime,
        // Add any other fields you need
      });
      // await FirebaseFirestore.instance.collection('users').doc(userrUid).add(updateNotification);
      // Update the document in Firestore
      await FirebaseFirestore.instance.collection('orders').doc(statusID).update(updatedData);

      print("Shop updated successfully.");
    } catch (e) {
      print("Error updating shop: $e");
    }
  }
  Future<List<NotificationModel>> fetchUserNotificationss() async {
    String userId = FirebaseAuth.instance.currentUser!.uid;
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    QuerySnapshot querySnapshot = await users.doc(userId).collection('notifications').get();

    return querySnapshot.docs.map((doc) {
      return NotificationModel(
        id: doc.id,
        title: doc['title'],
        description: doc['description'],
        dateTime: (doc['dateTime'] as Timestamp).toDate(),
        // Map other fields as required
      );
    }).toList();
  }





  Future<List<ListStationModel>> getStation() async {
    List<ListStationModel> items = [];

    var collection = FirebaseFirestore.instance.collection('station');
    var querySnapshot = await collection.get();

    for (var queryDocumentSnapshot in querySnapshot.docs) {
      Map<String, dynamic> data = queryDocumentSnapshot.data();

      // Check if 'location' exists and is a GeoPoint
      if (data['location'] != null && data['location'] is GeoPoint) {
        GeoPoint location = data['location'] as GeoPoint;
        print("Station Name: ${data['name']}, Location: $location");

        ListStationModel item = ListStationModel(
          latitude: location.latitude,
          longitude: location.longitude,
          id: queryDocumentSnapshot.id,
          name: data['name'],
          // services: data['service'],
        );

        items.add(item);
      } else {
        print("Location not found or not a GeoPoint for Station: ${data['name']}");
        // Handle the case where location is null or not a GeoPoint
        // For example, skip this station or use default location values
      }
    }

    return items;
  }

  Future<List<ListRiderModel>> getRiders() async {
    List<ListRiderModel> items = [];


    var collection = FirebaseFirestore.instance.collection('rider');

    var querySnapshot = await collection.get();

    for (var queryDocumentSnapshot in querySnapshot.docs) {
      Map<String, dynamic> data = queryDocumentSnapshot.data();

      // GeoPoint location = data['location'];
      print(data['name']);
      ListRiderModel item = ListRiderModel(
        // latitude: location.latitude,
        // longitude: location.longitude,
        id:queryDocumentSnapshot.id,
        name:data['name'],
        status:data['status']
        // services: data['service'],
      );

      items.add(item);
    }
    return items;
  }

  Future<List<ListUserModel>> getAdminUsers() async {
    List<ListUserModel> items = [];


    var collection = FirebaseFirestore.instance.collection('users');

    var querySnapshot = await collection.get();

    for (var queryDocumentSnapshot in querySnapshot.docs) {
      Map<String, dynamic> data = queryDocumentSnapshot.data();

      // GeoPoint location = data['location'];
      print(data['name']);
      ListUserModel item = ListUserModel(
        // latitude: location.latitude,
        // longitude: location.longitude,
        id:queryDocumentSnapshot.id,
        name:data['name'],
        // services: data['service'],
      );

      items.add(item);
    }
    return items;
  }


  void saveLocationToFirestore(LatLng location) async {
    String userUid = FirebaseAuth.instance.currentUser!.uid; // Get current user ID
    await FirebaseFirestore.instance.collection('orders').doc(userUid).set({
      'latitude': location.latitude,
      'longitude': location.longitude,
    });
  }
  void saveOrderDetailsToFirebase(String? orderAddresss, String location, String carDetails, double finalprice, String ShopID, LatLng selectedLocation) async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    final cartController = CartController.instance; // Assuming you have a singleton instance

    if (currentUser != null) {
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      WriteBatch batch = firestore.batch();

      try {
        // Create a list of items from the cart
        List<Map<String, dynamic>> cartItems = cartController.items.map((item) {
          // Reduce quantity in Firestore
          DocumentReference serviceRef = firestore.collection('station').doc(ShopID).collection('service').doc(item.id);
          batch.update(serviceRef, {
            'quantity': FieldValue.increment(-item.quantity) // Reduce the quantity
          });

          return {
            'itemId': item.id, // or any unique identifier of the item
            'name': item.category,
            'quantity': item.quantity,
            'price': item.price,
            // Add other item details you need
          };
        }).toList();

        // Create an order object with all details
        Map<String, dynamic> orderData = {
          'userId': currentUser.uid,
          'Address': orderAddresss,
          'carDetails': carDetails,
          'items': cartItems, // List of cart items
          'totalPrice': finalprice, // Total price
          'timestamp': FieldValue.serverTimestamp(),
          'Status': "Pending",
          'ShopID': ShopID,
          'location': GeoPoint(selectedLocation.latitude, selectedLocation.longitude),
          'RiderStatus': "Not Accepted",
          'AcceptedBy': "None",
        };

        // Save the order to Firestore
        DocumentReference orderRef = firestore.collection('orders').doc();
        batch.set(orderRef, orderData);

        // Commit the batch
        await batch.commit();
        print("Order and item quantity updates saved to Firestore for user ${currentUser.uid}");
      } catch (e) {
        print("Error saving order to Firestore: $e");
      }
    } else {
      print("No user logged in");
    }
  }


  Future<List<Map<String, dynamic>>> fetchUserOrders() async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    List<Map<String, dynamic>> stationOrders = [];

    if (currentUser != null) {
      try {
        QuerySnapshot querySnapshot = await FirebaseFirestore.instance
            .collection('orders')
            .where('userId', isEqualTo: currentUser.uid)
            .get();

        stationOrders = querySnapshot.docs
            .map((doc) => doc.data() as Map<String, dynamic>)
            .toList();
      } catch (e) {
        print("Error fetching orders: $e");
      }
    }
    return stationOrders;
  }

  Future<List<Map<String, dynamic>>> fetchAllOrders() async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    List<Map<String, dynamic>> stationOrders = [];

    if (currentUser != null) {
      try {
        QuerySnapshot querySnapshot = await FirebaseFirestore.instance
            .collection('orders')
            .where('RiderStatus', isEqualTo: "Not Accepted")
            .get();

        stationOrders = querySnapshot.docs
            .map((doc) {
          Map<String, dynamic> orderData = doc.data() as Map<String, dynamic>;
          orderData['docID'] = doc.id;
          return orderData;
        })
            .toList();


        } catch (e) {
        print("Error fetching orders: $e");
      }
    }
    return stationOrders;
  }

  Future<List<Map<String, dynamic>>> fetchRiderMyOrders() async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    List<Map<String, dynamic>> stationOrders = [];
    String riderId = FirebaseAuth.instance.currentUser!.uid; // Current rider's ID

    if (currentUser != null) {
      try {
        QuerySnapshot querySnapshot = await FirebaseFirestore.instance
            .collection('orders')
            .where('AcceptedBy', isEqualTo: riderId) // Fetch only orders accepted by this rider
            .where('RiderStatus', isEqualTo: 'Accepted')
            .get();

        stationOrders = querySnapshot.docs
            .map((doc) {
          Map<String, dynamic> orderData = doc.data() as Map<String, dynamic>;
          orderData['docID'] = doc.id;
          return orderData;
        })
            .toList();


      } catch (e) {
        print("Error fetching orders: $e");
      }
    }
    return stationOrders;
  }



  Future<List<Map<String, dynamic>>> fetchStationOrders() async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    List<Map<String, dynamic>> userOrders = [];

    if (currentUser != null) {
      try {
        QuerySnapshot querySnapshot = await FirebaseFirestore.instance
            .collection('orders')
            .where('ShopID', isEqualTo: currentUser.uid)
            .get();

        userOrders = querySnapshot.docs.map((doc){
          Map<String, dynamic> orderData= doc.data() as Map<String, dynamic>;
          orderData['docID']=doc.id;
          return orderData;

        }).toList();
      } catch (e) {
        print("Error fetching orders: $e");
      }
    }
    return userOrders;
  }

  void saveShopLocation(LatLng location, String stationId) async {
    await FirebaseFirestore.instance.collection('station').doc(stationId).update({
      'location': GeoPoint(location.latitude, location.longitude),
    });
    // After saving, navigate to the main screen
    Get.offAll(() => const BottomNavigationBarExample());
  }

  Future<bool> isAnyOrderAccepted(String riderId) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('orders')
        .where('acceptedBy', isEqualTo: riderId) // Fetch only orders accepted by this rider
        .where('riderStatus', isEqualTo: 'accepted')
        .limit(1) // We only need to check if at least one such document exists
        .get();

    return querySnapshot.docs.isNotEmpty;
  }
  void ChangeOrderStatus( String docID) async {
    String riderId = FirebaseAuth.instance.currentUser!.uid; // Get the current rider's ID

    print(docID);
    // Assuming you have the user's UID and the shop's ID
    bool acceptedOrderExists = await isAnyOrderAccepted(riderId);
    if (acceptedOrderExists) {
      print("An order has already been accepted.");
      return ; // Exit the function if an accepted order exists
    }else{

        await FirebaseFirestore.instance
            .collection('orders')
            .doc(docID)
            .update({
          'RiderStatus': 'Accepted',
          'AcceptedBy': riderId, // Add the rider's ID to the order
        });

        // Optionally navigate to a screen showing the accepted order or refresh the list



    }
    // String userUid = FirebaseAuth.instance.currentUser!.uid;


  }
  Future<GeoPoint> fetchStationLocation(String stationId) async {
    DocumentSnapshot stationSnapshot =
    await FirebaseFirestore.instance.collection('station').doc(stationId).get();

    if (stationSnapshot.exists) {
      print("GOOOOOOOD");
      var data = stationSnapshot.data();
      if (data is Map<String, dynamic> && data.containsKey('location')) {
        GeoPoint location = data['location'];
        return location;
      } else {
        throw Exception('Station found but does not have a location');
      }
    } else {
      throw Exception('Station not found');
    }
  }

  Future<List<LatLng>> fetchRoute(LatLng start, LatLng end) async {
    String url = 'https://maps.googleapis.com/maps/api/directions/json?origin=${start.latitude},${start.longitude}&destination=${end.latitude},${end.longitude}&key=AIzaSyDrK0-9Eq_8P12xKMEMt3QA_rO_w_mmrCg';

    var response = await http.get(Uri.parse(url));
    Map data = jsonDecode(response.body);

    List<LatLng> polylinePoints = [];
    if (data["routes"] != null && data["routes"].isNotEmpty) {
      // Decode the polyline points
      String encodedPoly = data["routes"][0]["overview_polyline"]["points"];
      polylinePoints = decodePoly(encodedPoly);
    }
    return polylinePoints;
  }

  List<LatLng> decodePoly(String encoded) {
    List<LatLng> poly = [];
    int index = 0, len = encoded.length;
    int lat = 0, lng = 0;

    while (index < len) {
      int b, shift = 0, result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lat += dlat;

      shift = 0;
      result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lng += dlng;

      LatLng p = LatLng((lat / 1E5).toDouble(), (lng / 1E5).toDouble());
      poly.add(p);
    }
    return poly;
  }




}

