import 'package:fix_fill/Controller/shop_controller.dart';
import 'package:fix_fill/user/select_service.dart';
import 'package:fix_fill/widgets/navbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ionicons/ionicons.dart';

import '../user/SelectServices.dart';

class TabBars extends StatefulWidget {
  String id;

  TabBars({required this.id});

  // AddItemDialog({super.key,required this.isFuel});

  @override
  _TabBarsState createState() => _TabBarsState();
}

class _TabBarsState extends State<TabBars> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('FIX'),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(icon: Icon(Ionicons.water), text: 'Fuel'),
            Tab(icon: Icon(Ionicons.settings), text: 'Service'),
          ],
        ),
      ),
      drawer: NavBar(),

      body: TabBarView(
        controller: _tabController,
        children: [
        SelectService(id:widget.id),
          SideServices(id:widget.id),
        ],
      ),
    );
  }
}