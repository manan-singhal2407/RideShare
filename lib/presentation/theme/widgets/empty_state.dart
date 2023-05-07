import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../color.dart';

class EmptyState extends StatelessWidget {
  final String primaryText;
  final String secondaryText;

  const EmptyState({
    super.key,
    required this.primaryText,
    required this.secondaryText,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(
            height: 40,
          ),
          Image.asset(
            "assets/images/empty_image.png",
            width: 300,
            height: 210,
          ),
          const SizedBox(
            height: 20,
          ),
          Text(
            primaryText,
            style: GoogleFonts.openSans(
              textStyle: const TextStyle(
                fontSize: 20,
                color: primaryTextColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          Text(
            secondaryText,
            style: GoogleFonts.openSans(
              textStyle: const TextStyle(
                fontSize: 15,
                color: secondaryTextColor,
                fontWeight: FontWeight.w500,
              ),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(
            height: 50,
          ),
        ],
      ),
    );
  }
}
