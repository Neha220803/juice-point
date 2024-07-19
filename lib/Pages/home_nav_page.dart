// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:juice_point/Pages/BottomNavBar/history_page.dart';
import 'package:juice_point/Pages/BottomNavBar/home_page.dart';
import 'package:juice_point/Pages/BottomNavBar/menu_page.dart';
import 'package:juice_point/Pages/BottomNavBar/new_order_page.dart';
import 'package:juice_point/Pages/SideNavBar/side_navbar.dart';
import 'package:juice_point/utils/constants.dart';

class HomeNavPage extends StatefulWidget {
  const HomeNavPage({super.key});

  @override
  State<HomeNavPage> createState() => _HomeNavPageState();
}

class _HomeNavPageState extends State<HomeNavPage> {
  late PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentPage);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: SideNavBar(),
      appBar: AppBar(
        title: Text(
          "Juice Point",
          style: GoogleFonts.pacifico(
            color: white,
            textStyle: TextStyle(fontSize: 20),
          ),
        ),
        backgroundColor: primaryColor,
        iconTheme: IconThemeData(color: white),
      ),
      body: PageView(
        controller: _pageController,
        children: <Widget>[
          HomePage(),
          MenuPage(),
          NewOrderPage(),
          OrderHistoryPage(),
        ],
        onPageChanged: (int index) {
          setState(() {
            _currentPage = index;
          });
        },
      ),
      bottomNavigationBar: ConvexAppBar(
        backgroundColor: primaryColor,
        items: <TabItem>[
          TabItem(icon: Icons.home, title: 'Home'),
          TabItem(icon: Icons.restaurant_menu_rounded, title: 'Menu'),
          TabItem(icon: Icons.receipt_long_rounded, title: 'Order'),
          TabItem(icon: Icons.history, title: 'History'),
        ],
        onTap: (int index) {
          setState(() {
            _currentPage = index;
            _pageController.animateToPage(
              index,
              duration: Duration(milliseconds: 700),
              curve: Curves.easeInOut,
            );
          });
        },
        initialActiveIndex: _currentPage,
        style: TabStyle.reactCircle,
        height: 60,
      ),
    );
  }
}
