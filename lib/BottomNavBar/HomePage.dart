// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final CollectionReference _menu =
      FirebaseFirestore.instance.collection('menu');
  TextEditingController _titleController = TextEditingController();
  TextEditingController _messageController = TextEditingController();
  TextEditingController _messageController2 = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/home-bg.png'),
              fit: BoxFit.cover,
            ),
          ),
        ),
        SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 15,
              ),
              Text(
                "Pouring Happiness, one glass at a time",
                style: TextStyle(
                  color: Color(0xFFFFE8E8),
                  fontSize: 16,
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w700,
                  // height: 0.13,
                  letterSpacing: 1.81,
                ),
              ),
              SizedBox(
                height: 170,
              ),
              // Text("Juice Point"),
              Container(
                width: 217.83,
                height: 141,
                child: Stack(
                  children: [
                    Positioned(
                      left: 0,
                      top: 0,
                      child: SizedBox(
                        // width: 72.29,
                        // height: 141,
                        child: Text('J',
                            style: GoogleFonts.pacifico(
                              textStyle: TextStyle(
                                color: Color(0xFF75A47F),
                                fontSize: 82.92,
                                fontFamily: 'Pacifico',
                                fontWeight: FontWeight.w400,
                                height: 0,
                              ),
                            )),
                      ),
                    ),
                    Positioned(
                      left: 103.57,
                      top: 70.34,
                      child: SizedBox(
                        width: 114.26,
                        height: 69.53,
                        child: Text('Point',
                            style: GoogleFonts.pacifico(
                              textStyle: TextStyle(
                                color: Color(0xFF75A47F),
                                fontSize: 41.17,
                                fontFamily: 'Pacifico',
                                fontWeight: FontWeight.w400,
                                height: 0,
                              ),
                            )),
                      ),
                    ),
                    Positioned(
                      left: 65,
                      top: 13.73,
                      child: SizedBox(
                        width: 93.27,
                        height: 90.78,
                        child: Text('uice',
                            style: GoogleFonts.pacifico(
                              textStyle: TextStyle(
                                color: Color(0xFF75A47F),
                                fontSize: 53.61,
                                fontFamily: 'Pacifico',
                                fontWeight: FontWeight.w400,
                                height: 0,
                              ),
                            )),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(50, 25, 50, 0),
                child: Text(
                  "Welcome to Juice Point, a happy place where refreshing flavors and healthy vibes come together! Enjoy our vibrant, delicious juices made with love and the freshest ingredients.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFFF0E3E3),
                    fontSize: 16,
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w600,
                    // height: 0.08,
                    letterSpacing: 1.81,
                  ),
                ),
              ),
              // TextFormField(
              //   controller: _titleController,
              // ),
              // TextFormField(
              //   controller: _messageController,
              // ),
              // TextFormField(
              //   controller: _messageController2,
              // ),
              // ElevatedButton(
              //     onPressed: () {
              //       _menu.add({
              //         'category': _titleController.text,
              //         'name': _messageController.text,
              //         'cost': _messageController2.text,
              //       });
              //     },
              //     child: Text("yes"))
            ],
          ),
        )
      ],
    );
  }
}
