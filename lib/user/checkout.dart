import 'package:fix_fill/Controller/cart_controller.dart';
import 'package:fix_fill/Controller/shop_controller.dart';
import 'package:fix_fill/user/dashboard.dart';
import 'package:fix_fill/user/map_screen.dart';
import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/response/response.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

class Checkout extends StatefulWidget {

  double total;

  String stationId;
  Checkout({required this.stationId,required this.total});

  @override
  State<Checkout> createState() => _CheckoutState();
}

class _CheckoutState extends State<Checkout> {

  final _formKey = GlobalKey<FormState>();
  String _location = '';
  String _carDetails = '';
  Map<String, dynamic>? paymentIntent;
  int finalprice=0;
  String finalfinalprice="";
  var controller =Get.put(ShopController());
  // var total;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    finalprice=(widget.total).toInt()*100;
    finalfinalprice=finalprice.toString();

    // total=(CartController.instance.totalPrice).toString();

  }
  // int finalprice=total;
  void makePayment()async{
    print("anccc");
    try{
      print("1");
      paymentIntent = await createPaymentIntent();
      var gpay=const PaymentSheetGooglePay(merchantCountryCode: "US",
          currencyCode:"US",
          testEnv: true
      );
      print("1.2");
      await Stripe.instance.initPaymentSheet(
          paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: paymentIntent!["client_secret"],
          style: ThemeMode.light,
          merchantDisplayName: "Ehtsham",
          googlePay: gpay
      ));
      print("1.3");

      displayPaymentSheet();
    }
    catch(e){
      print("FAiled: ${e}");
    }

  }

  void displayPaymentSheet()async{
    print("2");
    // widget.total;
    try{
      await Stripe.instance.presentPaymentSheet();
      print("Payment Successful");
      ShopController.instance.order(orderAddresss,_location,_carDetails,widget.total,widget.stationId,selectedLocation!);

      CartController.instance.removeStationItems(widget.stationId);
      _showSuccessModal(context,orderAddresss: orderAddresss, total: widget.total);
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>dashboard(),)
        ,);
    }
    catch(e){
      print("Failed");
    }
  }
  createPaymentIntent()async{
    try{
      Map<String, dynamic> body={
        "amount":finalfinalprice,
        "currency":"USD",
      };
      print("3");
      http.Response response= await http.post(
          Uri.parse("https://api.stripe.com/v1/payment_intents"),
          body:body,
          headers:{
            "Authorization":"Bearer sk_test_51OHpu1BUs4cwQXC7MCSDG9P57C0fGE9E9bbi7KPrnhLPmz8BNa99yfh8Ff4cl8elHDv6QIxI0LrLq9EfvgcFd2to00JDLtsd2o",
            "Content-Type":"application/x-www-form-urlencoded",

          }
      );
      return json.decode(response.body);
    }catch(e){
      throw Exception("Faileddd ${e.toString()}");

    }
  }
  LatLng? selectedLocation;
  String? orderAddresss;

  void _navigateAndPickLocation() async {
    var result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => LocationPickerScreen()),
    );

    if (result != null) {
      setState(() {
        var resultMap = result as Map;
         selectedLocation = resultMap['position'];
         orderAddresss = resultMap['address'];
      });
    }
  }
  late String servicename;
  final cartController = CartController.instance;

  @override
  Widget build(BuildContext context) {
    Iterable<Set<String>> cartItems = cartController.items.map((item) {
      return{

        servicename=item.shopID};
    });

    print("Itemsss is :${cartItems}");
    print("Location : ${selectedLocation}");
    return Scaffold(
      appBar: AppBar(
        title: Text("Checkout"),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: EdgeInsets.fromLTRB(30,10,30,10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              // TextFormField(
              //   decoration: InputDecoration(labelText: 'Location'),
              //   validator: (value) => value!.isEmpty ? 'Please enter a location' : null,
              //   onSaved: (value) => _location = value!,
              // ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Please Enter Additional Details'),
                validator: (value) => value!.isEmpty ? 'Please enter car details' : null,
                onSaved: (value) => _carDetails = value!,
              ),
              SizedBox(height: 20,),
              Text("Services:",style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold,

              ),),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  for (var item in cartController.items)
                    Text(item.category),
                  // Text(item.),
              // ListView.builder(
              //   itemCount: cartController.items.length,
              //   itemBuilder: (context, index) {
              //     return Text(cartController.items[index].category);
              //   },
              // )
                ],
              ),
              // Text("${cartItems}",style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold,
              //
              // ),),
              SizedBox(height: 20,),

              Text("Price Detail:",style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold,

              ),),
              SizedBox(height: 5,),
              Container(
                padding: EdgeInsets.fromLTRB(10.0, 20.0, 10.0, 20.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  border: Border.all(
                    color: Colors.black,
                    width: 1.0,
                  )
                ),
                child:Column(
                  children: [
                    Row(
                      children:[
                        Text("Payment Method",style: TextStyle(fontSize: 20),),
                        SizedBox(width: 40),
                        Text("Online",style: TextStyle(fontSize: 20),),


                      ]

                    ),
                    Row(
                      children: [
                        Text("Total",style: TextStyle(fontSize: 20),),
                        SizedBox(width: 150),
                        Text('${widget.total}\$',style: TextStyle(fontSize: 20),),
                      ],
                    )
                  ],
                )
              ),
              SizedBox(height: 20,),

              orderAddresss!=null
                  ? Text(orderAddresss!)
                  :Text("No location selected"),
              ElevatedButton(
                  child: Text('Get Location'),
                  onPressed: (){
                    if (_formKey.currentState!.validate()) {
                      _navigateAndPickLocation();
                    }
                    // Navigator.push(context, MaterialPageRoute(builder: (context)=>LocationPickerScreen(),)
                    //   ,);
                    // navigator?.pushReplacement(context, MaterialPageRoute(builder: (context)=>signup(),);
                  }
              ),
              ElevatedButton(
                child: Text('Submit'),
                onPressed: (){

                  print("ancccfdfsa");
                  if(orderAddresss!=null){
                    print("anccc");

                    makePayment();

                  }
                }
              ),


            ],
          ),
        ),
      ),
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      // final checkoutInfo = CheckoutInfo(location: _location, carDetails: _carDetails);
      // Process checkout information
      // For example, navigate to a confirmation screen or make an API call
    }
  }
}
void _showSuccessModal(BuildContext context, {required String? orderAddresss, required double total, }) {
  // showModalBottomSheet
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
          backgroundColor: Colors.white, // Set the background color to white

          child: Container(
          width: MediaQuery.of(context).size.width * 0.8, // 80% of screen width
      padding: EdgeInsets.all(50.0),
      child: Column(
      children: <Widget>[
        Container(height: 300,
        width: 300,
        child: Image.network(

          'https://media.giphy.com/media/3orntPDQO9sdQAZ4vT/giphy.gif',
          // Add other properties as needed
        ),
        )
        ,
        Text("Congratulations!! Your Order has been Recievied.",style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, ),),
        SizedBox(height: 10,),

        Text("Your Order will be delivered to: ${orderAddresss}"),

      ],
      )));
    },
  );
}
