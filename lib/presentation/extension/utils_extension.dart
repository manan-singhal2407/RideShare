import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void showScaffoldMessenger(
  BuildContext context,
  String text,
  Color backgroundColor,
) async {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        text,
        style: GoogleFonts.openSans(
          textStyle: const TextStyle(
            color: Colors.white,
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      backgroundColor: backgroundColor,
    ),
  );
}
