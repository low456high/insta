import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Widget buttncontainer(
    {context, height, width, color, title, titlecolor, isborder}) {
  return Container(
    height: height,
    width: width,
    decoration: isborder == true
        ? BoxDecoration(
            border: Border.all(color: color),
            borderRadius: BorderRadius.circular(6),
          )
        : BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(6),
          ),
    child: Center(
      child: Text(
        title,
        style:
            GoogleFonts.ubuntu(color: titlecolor, fontWeight: FontWeight.bold),
      ),
    ),
  );
}
