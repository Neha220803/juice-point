import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:juice_point/Components/custom_font_text.dart';
import 'package:juice_point/Components/custom_text.dart';
import 'package:juice_point/utils/constants.dart';
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
                CustomText(
                  value: "Pouring Happiness, one glass at a time",
                  textAlign: TextAlign.center,
                  color: secondaryColor,
                  size: !responsive.isMobile(context)
                      ? 32
                      : MediaQuery.of(context).size.width / 22,
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w700,
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
                              child: CustomFontText(
                            value: "J",
                            size: MediaQuery.of(context).size.width / 5,
                            color: primaryColor,
                            fontWeight: FontWeight.w400,
                          )),
                        ),
                        Positioned(
                          left: MediaQuery.of(context).size.width / 4,
                          top: MediaQuery.of(context).size.width / 5.8,
                          child: SizedBox(
                              child: CustomFontText(
                            value: "Point",
                            size: MediaQuery.of(context).size.width / 10,
                            color: primaryColor,
                            fontWeight: FontWeight.w400,
                          )),
                        ),
                        Positioned(
                          left: MediaQuery.of(context).size.width / 6.99,
                          top: MediaQuery.of(context).size.width / 30,
                          child: SizedBox(
                            child: Text('uice',
                                style: GoogleFonts.pacifico(
                                  textStyle: TextStyle(
                                    color: primaryColor,
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
                  const CustomFontText(
                    value: "Juice Point",
                    size: 80,
                    color: primaryColor,
                    fontWeight: FontWeight.w400,
                  ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(50, 25, 50, 0),
                  child: CustomText(
                    value:
                        "Welcome to Juice Point, a happy place where refreshing flavors and healthy vibes come together! Enjoy our vibrant, delicious juices made with love and the freshest ingredients.",
                    textAlign: TextAlign.center,
                    size: !responsive.isMobile(context)
                        ? 30
                        : MediaQuery.of(context).size.width / 23.5,
                    color: secondaryColor,
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.81,
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
