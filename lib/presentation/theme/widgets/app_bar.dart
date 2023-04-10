import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../color.dart';

class SecondaryAppBar extends StatelessWidget with PreferredSizeWidget {
  const SecondaryAppBar({
    super.key,
    required this.primaryText,
  });

  final String primaryText;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        primaryText,
        style: GoogleFonts.openSans(
          textStyle: const TextStyle(
            fontSize: 18,
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      backgroundColor: blackAppBarColor,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
