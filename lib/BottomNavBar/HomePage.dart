import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:juice_point/utils/responsive.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/home-bg.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Pouring Happiness, one glass at a time",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: const Color(0xFFFFE8E8),
                    fontSize: !responsive.isMobile(context)
                        ? 32
                        : MediaQuery.of(context).size.width / 22,
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.81,
                  ),
                ),

                // Conditionally render text based on device type
                if (responsive.isMobile(context))
                  SizedBox(
                    width: 217.83,
                    height: 141,
                    child: Stack(
                      children: [
                        Positioned(
                          left: 0,
                          top: 0,
                          child: SizedBox(
                            child: Text('J',
                                style: GoogleFonts.pacifico(
                                  textStyle: TextStyle(
                                    color: const Color(0xFF75A47F),
                                    fontSize:
                                        MediaQuery.of(context).size.width / 5,
                                    fontFamily: 'Pacifico',
                                    fontWeight: FontWeight.w400,
                                    height: 0,
                                  ),
                                )),
                          ),
                        ),
                        Positioned(
                          left: MediaQuery.of(context).size.width / 4,
                          top: MediaQuery.of(context).size.width / 5.8,
                          child: SizedBox(
                            child: Text('Point',
                                style: GoogleFonts.pacifico(
                                  textStyle: TextStyle(
                                    color: const Color(0xFF75A47F),
                                    fontSize:
                                        MediaQuery.of(context).size.width / 10,
                                    fontFamily: 'Pacifico',
                                    fontWeight: FontWeight.w400,
                                    height: 0,
                                  ),
                                )),
                          ),
                        ),
                        Positioned(
                          left: MediaQuery.of(context).size.width / 6.99,
                          top: MediaQuery.of(context).size.width / 30,
                          child: SizedBox(
                            child: Text('uice',
                                style: GoogleFonts.pacifico(
                                  textStyle: TextStyle(
                                    color: const Color(0xFF75A47F),
                                    fontSize:
                                        MediaQuery.of(context).size.width / 7.7,
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
                if (!responsive.isMobile(context))
                  Text('Juice Point',
                      style: GoogleFonts.pacifico(
                        textStyle: const TextStyle(
                          color: Color(0xff75A47F),
                          fontSize: 80,
                          fontFamily: 'Pacifico',
                          fontWeight: FontWeight.w400,
                        ),
                      )),
                Padding(
                  padding: const EdgeInsets.fromLTRB(50, 25, 50, 0),
                  child: Text(
                    "Welcome to Juice Point, a happy place where refreshing flavors and healthy vibes come together! Enjoy our vibrant, delicious juices made with love and the freshest ingredients.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: const Color(0xFFF0E3E3),
                      fontSize: !responsive.isMobile(context)
                          ? 30
                          : MediaQuery.of(context).size.width / 23.5,
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.81,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
