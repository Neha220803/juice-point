import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomFontText extends StatelessWidget {
  final String value;
  final double size;
  final FontWeight? fontWeight;
  final Color? color;


  const CustomFontText({
    super.key,
    required this.value,
    required this.size,
    this.fontWeight,
    this.color,

  });

  @override
  Widget build(BuildContext context) {
    return Text(value,
        style: GoogleFonts.pacifico(
          textStyle: TextStyle(
            color: color,
            fontSize: size,
            fontFamily: 'Pacifico',
            fontWeight: fontWeight,
            
          ),
        )

        //  TextStyle(
        //   // letterSpacing: 1,
        //   fontSize: size ?? 14,
        //   color: color ?? black,
        //   fontWeight: fontWeight,
        // ),
        );
  }
}
