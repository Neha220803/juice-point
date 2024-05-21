// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:juice_point/BottomNavBar/HistoryPage.dart';
import 'package:juice_point/BottomNavBar/HomePage.dart';
import 'package:juice_point/BottomNavBar/MenuPage.dart';
import 'package:juice_point/BottomNavBar/NewOrderPage.dart';
import 'package:juice_point/SideNavBar/SideNav.dart';

class HomeNavPage extends StatefulWidget {
  const HomeNavPage({Key? key});

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
      //extendBodyBehindAppBar: true,
      // extendBody: true,
      drawer: SideNavBar(),
      appBar: AppBar(
        title: Text(
          "Juice Point",
          style: GoogleFonts.pacifico(
            color: Colors.white,
          ),
        ),
        backgroundColor: Color(0xff75A47F),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: PageView(
        controller: _pageController,
        children: <Widget>[
          HomePage(),
          MenuPage(),
          NewOrderPage(),
          HistoryPage(),
        ],
        onPageChanged: (int index) {
          setState(() {
            _currentPage = index;
          });
        },
      ),
      bottomNavigationBar: ConvexAppBar(
        backgroundColor: Color(0xff75A47F),
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
