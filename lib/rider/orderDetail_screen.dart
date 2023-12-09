import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fix_fill/Controller/shop_controller.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class OrderDetailScreen extends StatefulWidget {

  Map<String, dynamic> order;
  OrderDetailScreen({required this.order});

  @override
  State<OrderDetailScreen> createState() => _OrderDetailScreenState();
}

// Future<List<ListStationModel>> items =;
class _OrderDetailScreenState extends State<OrderDetailScreen> {
  Set<Polyline> _polylines = {};
  Set<Marker> _markers = {};
  late GeoPoint orderLocation;
  late GeoPoint stationLocation;
  late String stationId = "";
  late String orderAddress = '';
  late String stationAddress = '';

  @override
  void initState() {
    super.initState();
    stationId = widget.order["ShopID"];
    orderLocation = GeoPoint(
        widget.order["location"].latitude, widget.order["location"].longitude);
    // Assuming stationLocation is fetched separately or available in order
    ShopController.instance.getStationlocation(stationId).then((item) {
      // GeoPoint stationLocation = item;
      stationLocation = item;
      _showRoute();
      getAddressFromLatLng(orderLocation.latitude, orderLocation.longitude)
          .then((address) {
        setState(() {
          orderAddress = address;
          print(orderAddress);
        });
      });

      getAddressFromLatLng(stationLocation.latitude, stationLocation.longitude)
          .then((address) {
        setState(() {
          stationAddress = address;
          print(stationAddress);
        });
      });
    });

    /* Fetch or get station location */;
  }

  Future<String> getAddressFromLatLng(double latitude, double longitude) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
          latitude, longitude);
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        return "${place.street}, ${place.locality}, ${place.country}";
      }
      return "Unknown location please see Map";
    } catch (e) {
      print("Error fetching address: $e");
      return "Error fetching address";
    }
  }

  LatLng convertGeoPointToLatLng(GeoPoint geoPoint) {
    return LatLng(geoPoint.latitude, geoPoint.longitude);
  }


  void _showRoute() {
    print("BADDD");
    LatLng startLatLng = convertGeoPointToLatLng(orderLocation);
    LatLng endLatLng = convertGeoPointToLatLng(stationLocation);
    ShopController.instance.fetchRoute(startLatLng, endLatLng).then((route) {
      setState(() {
        _polylines.add(
          Polyline(
            polylineId: PolylineId('route'),
            visible: true,
            points: route,
            color: Colors.blue,
          ),
        );
        _markers.add(Marker(
          markerId: MarkerId('orderLocation'),
          position: startLatLng,
        ));
        _markers.add(Marker(
          markerId: MarkerId('stationLocation'),
          position: endLatLng,
        ));
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    GeoPoint orderLocation = widget.order["location"];

    return FutureBuilder<GeoPoint>(
      future: ShopController.instance.getStationlocation(stationId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text(
              "Error fetching station location: ${snapshot.error}"));
        }

        GeoPoint stationLocation = snapshot.data!;

        return Scaffold(
          appBar: AppBar(
            title: Text('Order Details'),
             // Choose a theme color for your app
          ),
          body: SingleChildScrollView( // Allows the content to be scrollable
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  _buildInfoCard("Status", widget.order["Status"],
                      Icons.check_circle_outline, Colors.green),
                  _buildInfoCard("Total Price",
                      "₹${widget.order["totalPrice"].toString()}",
                      Icons.attach_money, Colors.orange),
                  _buildInfoCard(
                      "Order Location", orderAddress, Icons.location_on,
                      Colors.red),
                  _buildInfoCard("Station Location", stationAddress,
                      Icons.store_mall_directory, Colors.blue),
                  SizedBox(height: 20),
                  Text("Map View", style: TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold)),
                  SizedBox(height: 10),
                  _buildMap(orderLocation, stationLocation),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildInfoCard(String title, String value, IconData icon,
      Color iconColor) {
    return Card(
      elevation: 4,
      margin: EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: Icon(icon, color: iconColor),
        title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(value),
      ),
    );
  }

  Widget _buildMap(GeoPoint orderLocation, GeoPoint stationLocation) {
    Set<Marker> markers = {
      Marker(
        markerId: MarkerId('orderLocation'),
        position: LatLng(orderLocation.latitude, orderLocation.longitude),
        infoWindow: InfoWindow(title: 'Order Location'),
      ),
      Marker(
        markerId: MarkerId('stationLocation'),
        position: LatLng(stationLocation.latitude, stationLocation.longitude),
        infoWindow: InfoWindow(title: 'Station Location'),
      ),
    };

    return SizedBox(
      height: 250, // Adjust size as needed
      child: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(orderLocation.latitude, orderLocation.longitude),
          zoom: 12,
        ),
        polylines: _polylines,
        markers: markers,
      ),
    );
  }
}

