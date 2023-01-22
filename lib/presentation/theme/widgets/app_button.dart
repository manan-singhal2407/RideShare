import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../color.dart';

class PrimaryAppButton extends StatelessWidget {
  const PrimaryAppButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.width,
    this.buttonColor = Colors.green,
    this.enabled = true,
  });

  final String text;
  final VoidCallback onPressed;
  final double? width;
  final Color buttonColor;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: 48,
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: enabled
              ? MaterialStateProperty.all<Color>(buttonColor)
              : MaterialStateProperty.all<Color>(Colors.grey),
        ),
        onPressed: enabled ? onPressed : null,
        child: Text(
          text,
          style: GoogleFonts.openSans(
            textStyle: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}

class SecondaryAppButton extends StatelessWidget {
  const SecondaryAppButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.width,
  });

  final String text;
  final VoidCallback onPressed;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: 48,
      child: OutlinedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
        ),
        onPressed: onPressed,
        child: Text(
          text,
          style: GoogleFonts.openSans(
            textStyle: const TextStyle(
              fontWeight: FontWeight.bold,
              color: secondaryTextColor,
            ),
          ),
        ),
      ),
    );
  }
}
