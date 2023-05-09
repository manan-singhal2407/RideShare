import 'package:flutter/material.dart';

class OnboardingButton extends StatelessWidget {
  final VoidCallback onButtonClicked;

  const OnboardingButton({
    super.key,
    required this.onButtonClicked,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onButtonClicked,
      child: Align(
        alignment: Alignment.centerRight,
        child: Container(
          width: 80,
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(40),
            boxShadow: [
              BoxShadow(
                color: Colors.white.withOpacity(0.1),
                spreadRadius: 8,
                blurRadius: 8,
              ),
            ],
          ),
          child: Stack(
            children: [
              Image.asset(
                'assets/images/ic_selector.png',
                width: 80,
                height: 80,
              ),
              Positioned(
                bottom: 24,
                right: 24,
                child: Image.asset(
                  'assets/images/ic_forward.png',
                  width: 32,
                  height: 32,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
