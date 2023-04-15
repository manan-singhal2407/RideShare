import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

String googleMapsApiKey = 'AIzaSyDschydseXpu7lOGtBorLzIzWl-rEr2a24';

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

String getCurrencyFormattedNumber(double value) {
  return NumberFormat.currency(
    symbol: '\u{20B9}',
    locale: 'HI',
    decimalDigits: 0,
  ).format(value);
}

String getNonCurrencyFormattedNumber(double value) {
  return NumberFormat.currency(
    symbol: '',
    locale: 'HI',
    decimalDigits: 0,
  ).format(value);
}
