import 'dart:async';
import 'package:fix_fill/Controller/shop_controller.dart';
import 'package:fix_fill/model/ListedStationModel.dart';
import 'package:fix_fill/widgets/navbar.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class AdminMap extends StatefulWidget {
  const AdminMap({super.key});

  @override
  State<AdminMap> createState() => _AdminMapState();
}
Future<List<ListStationModel>> items =ShopController.instance.getStation();


class _AdminMapState extends State<AdminMap>  {
  Completer<GoogleMapController> _controller = Completer();
  static LatLng _center = const LatLng(45.521563, -122.677433);
  final Future<List<ListStationModel>> items = ShopController.instance.getStation();
  final Set<Marker> _markers = {};


  // ============================================

  Location location = new Location();

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  void _getCurrentLocation() async {
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
    print("object");


    _locationData = await location.getLocation();
    _center = LatLng(_locationData.latitude!, _locationData.longitude!);
    print("Locationnnnnn: ${_center}");
    if (_controller.isCompleted) {
      final GoogleMapController mapController = await _controller.future;
      mapController.animateCamera(CameraUpdate.newLatLng(_center));
    }

    setState(() {});
  }


  // ============================================
  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("FIX")),
      drawer: NavBar(),
      body:
              FutureBuilder<List<ListStationModel>>(
                future: items,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text("Error: ${snapshot.error}");
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Text("No stations found");
                  } else {
                    _buildMarkers(snapshot.data!);
                    return _buildGoogleMap();
                  }
                },
              )
    );


  }

  void _buildMarkers(List<ListStationModel> stations) {
    _markers.clear();
    for (var station in stations) {
      _markers.add(
        Marker(
          markerId: MarkerId(station.name),
          position: LatLng(station.latitude, station.longitude),
          infoWindow: InfoWindow(title: station.name),
        ),
      );
    }
  }

  Widget _buildGoogleMap() {
    return Container(
      height: 500, // Adjust the height as needed
      child: GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(

          // Set initial position, maybe center of all stations or a default location
          target: _center,
          zoom: 12,
        ),
        markers: _markers,

      ),
    );
  }
}
