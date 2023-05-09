import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import '../color.dart';

class TextInputField extends StatelessWidget {
  final TextEditingController textEditingController;
  final TextCapitalization textCapitalization;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final String hintText;
  final bool showSuffixIcon;
  final bool showCountryCode;
  final String countryCode;
  final TextAlign textAlign;
  final String errorText;
  final int? maxLength;
  final ValueSetter<String>? onChangedText;
  final VoidCallback? onSuffixIconClicked;
  final VoidCallback? onCountryCodeClicked;

  const TextInputField({
    super.key,
    required this.textEditingController,
    this.textCapitalization = TextCapitalization.none,
    this.keyboardType,
    this.inputFormatters,
    this.hintText = '',
    this.showSuffixIcon = false,
    this.showCountryCode = false,
    this.countryCode = '',
    this.textAlign = TextAlign.start,
    this.errorText = '',
    this.maxLength,
    this.onChangedText,
    this.onSuffixIconClicked,
    this.onCountryCodeClicked,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: textEditingController,
      textCapitalization: textCapitalization,
      maxLength: maxLength,
      textAlign: textAlign,
      onChanged: onChangedText,
      style: GoogleFonts.redHatDisplay(
        textStyle: const TextStyle(
          fontWeight: FontWeight.w600,
          color: primaryTextColor,
        ),
      ),
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      cursorColor: secondaryTextColor,
      decoration: InputDecoration(
        counterText: '',
        errorText: errorText,
        errorStyle: GoogleFonts.redHatDisplay(
          textStyle: const TextStyle(
            fontSize: 11,
            height: 0.8,
            color: errorStateColor,
            fontWeight: FontWeight.w500,
          ),
        ),
        errorMaxLines: 1,
        suffixIcon: showSuffixIcon
            ? IconButton(
                icon: const Icon(
                  Icons.paste_rounded,
                  size: 24,
                  color: secondaryTextColor,
                ),
                onPressed: onSuffixIconClicked,
              )
            : null,
        prefixIcon: showCountryCode ? GestureDetector(
          onTap: onCountryCodeClicked,
          child: Center(
            widthFactor: 0.3,
            heightFactor: 1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  width: 4,
                ),
                Text(
                  countryCode,
                  style: GoogleFonts.redHatDisplay(
                    textStyle: const TextStyle(
                      fontWeight: FontWeight.w600,
                      color: primaryTextColor,
                      fontSize: 16,
                    ),
                  ),
                ),
                const SizedBox(
                  width: 4,
                ),
                Image.asset(
                  'assets/images/ic_vertical.png',
                  width: 24,
                  height: 24,
                  color: primaryTextColor,
                ),
                const SizedBox(
                  width: 4,
                ),
              ],
            ),
          ),
        ) : null,
        hintText: hintText,
        hintStyle: GoogleFonts.redHatDisplay(
          textStyle: const TextStyle(
            color: secondaryTextColor,
            fontWeight: FontWeight.w600,
          ),
        ),
        border: OutlineInputBorder(
          borderSide: const BorderSide(
            color: secondaryTextColor,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        errorBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: secondaryTextColor,
          ),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: primaryTextColor,
          ),
        ),
        focusedErrorBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: primaryTextColor,
          ),
        ),
      ),
    );
  }
}
