import 'package:flutter/material.dart';

import '../constants.dart';

class NavigationButton extends StatelessWidget {
  NavigationButton({super.key, required this.buttonText, required this.onPressed});

  final String buttonText;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 5.0,
      color: kBlueBackgroundColor,
      borderRadius: BorderRadius.all(Radius.elliptical(40, 20)),
      child: MaterialButton(
        onPressed: onPressed,
        minWidth: 170,
        height: 100,
        child: Text(
          buttonText,
          textAlign: TextAlign.center, // Ensure text is centered
          style: kOnBlueTextStyle.copyWith(fontSize: 20),
        ),
      ),
    );
  }
}