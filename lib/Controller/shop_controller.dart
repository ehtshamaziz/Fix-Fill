import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fix_fill/Repository/Shop_Repository/shop_repository.dart';
import 'package:fix_fill/model/ListItemModel.dart';
import 'package:fix_fill/model/ListedRiderModal.dart';
import 'package:fix_fill/model/ListedUsersModel.dart';
import 'package:fix_fill/model/notification.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../model/ListUpdateModel.dart';
import '../model/ListedStationModel.dart';


class ShopController extends GetxController{
  // final stationName= TextEditingController();
  // final price= TextEditingController();
  // final quantity= TextEditingController();
  // final SideService service = SideService();

  // List<Service> get items => service.items;
  static ShopController get instance => Get.find();



   void add(bool isFuel,double price, int quantity, String selectedOption) async{
     print("abccc");
    ShopRepository.instance.addShop(isFuel,price,quantity,selectedOption);

  }
  void updateList(bool fuel, String id,double price, int quantity, String selectedOption) async{
    print("update");
    ShopRepository.instance.updateService(fuel,id,price,quantity,selectedOption);

  }

  Future<String>getStationName(String StationID) async => ShopRepository.instance.getStationName(StationID);
  void updateStatus( String id, String selectedOption, String userID) async{
    print("update");
    ShopRepository.instance.updateStatus(id,selectedOption,userID);

  }
  Future<List<ListItemModel>> getList(bool isFuel) async{
    print("abccc");
    List<ListItemModel> allItems = await ShopRepository.instance.getShop();
    return allItems.where((item) => item.fuel == isFuel).toList();
  }


  Future<dynamic> getListUser(String id,bool isFuel) async{
    print("abccc");
    List<Service> allItems = await ShopRepository.instance.fetchServices(id);
    return allItems;

    // return allItems.where((item) => item.fuel == isFuel).toList();
  }

  void delete( String shopId)async{
     ShopRepository.instance.deleteShop(shopId);
  }
  Future<ListUpdateModel> getItem(bool isFuel, String items) async{
    return ShopRepository.instance.getServiceToUpdate(isFuel,items);
  }
  Future<OrderModel> getOrder(String items) async{
    return ShopRepository.instance.getOrderToUpdate(items);
  }
  void ChangeOrderStatus(String docID){
    ShopRepository.instance.ChangeOrderStatus(docID);
  }
  Future<List<NotificationModel>>fetchUserNotifications() async{
     return ShopRepository.instance.fetchUserNotificationss();
  }
  Future<List<ListStationModel>> getStation() async{
    return ShopRepository.instance.getStation();
  }
  Future<List<ListRiderModel>> getRiders() async{
    return ShopRepository.instance.getRiders();
  }
  Future<List<ListUserModel>> getAdminUsers() async{
    return ShopRepository.instance.getAdminUsers();
  }




  void order(String? orderAddresss,String location,String Cardetail, double finalprice, String stationId, LatLng selectedLocation){
    ShopRepository.instance.saveOrderDetailsToFirebase(orderAddresss,location,Cardetail,finalprice,stationId, selectedLocation);

  }
void savelocation(LatLng location){
     ShopRepository.instance.saveLocationToFirestore(location);
}
  Future<GeoPoint> getStationlocation(String stationID) async{
    return ShopRepository.instance.fetchStationLocation(stationID);
  }

  Future<List<LatLng>> fetchRoute(LatLng start, LatLng end) async{
     return ShopRepository.instance.fetchRoute(start,end);
  }

  Future<List<Map<String, dynamic>>> UserOrders() async {
    return await ShopRepository.instance.fetchUserOrders();
  }
  Future<List<Map<String, dynamic>>> AllOrders() async {
    return await ShopRepository.instance.fetchAllOrders();
  }

  Future<List<Map<String, dynamic>>> fetchRiderMyOrders() async {
    return await ShopRepository.instance.fetchRiderMyOrders();
  }


  Future<List<Map<String, dynamic>>> StationOrders() async {
    return await ShopRepository.instance.fetchStationOrders();
  }
void shopSavelocation(LatLng location, String stationId){
     ShopRepository.instance.saveShopLocation(location,stationId);
}
}