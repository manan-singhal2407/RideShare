import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../color.dart';

class ErrorState extends StatelessWidget {
  const ErrorState({
    super.key,
    required this.onTryAgain,
  });

  final VoidCallback onTryAgain;

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
            "assets/images/error_image.png",
            width: 300,
            height: 210,
          ),
          const SizedBox(
            height: 12,
          ),
          Text(
            'We\'re Sorry',
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
            'We found some error while loading data',
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
            height: 20,
          ),
          OutlinedButton(
            onPressed: onTryAgain,
            child: Text(
              'Try Again',
              style: GoogleFonts.openSans(
                textStyle: const TextStyle(
                  fontSize: 15,
                  color: secondaryTextColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 50,
          ),
        ],
      ),
    );
  }
}
