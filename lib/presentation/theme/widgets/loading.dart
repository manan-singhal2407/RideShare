import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../color.dart';

void showLoadingDialogBox(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return WillPopScope(
        onWillPop: () async => false,
        child: AlertDialog(
          content: Row(
            children: [
              const CircularProgressIndicator(
                color: secondaryTextColor,
              ),
              Container(
                margin: const EdgeInsets.only(left: 24, right: 16),
                child: Text(
                  'Loading...',
                  style: GoogleFonts.openSans(
                    textStyle: const TextStyle(
                      fontSize: 14,
                      color: secondaryTextColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
