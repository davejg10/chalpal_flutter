import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:chal_pal/src/global/widgets/navigation_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../global/constants.dart';
import 'login_screen.dart';
import 'register_screen.dart';

class WelcomeScreen extends ConsumerWidget {
  const WelcomeScreen({super.key});

  static String route = "/";

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex: 4,
              child: Container(
                child: Column(
                  children: [
                    Text(
                      'ChalPal',
                      style: kOnBlueTextStyle,
                    ),
                    SizedBox(
                      height: 100,
                    ),
                    Container(
                      child: DefaultTextStyle(
                          style: kOnBlueTextStyle.copyWith(fontSize: 60),
                          child: AnimatedTextKit(pause: Duration(milliseconds: 250), animatedTexts: [RotateAnimatedText('CHALLENGE'), RotateAnimatedText('YOUR'), RotateAnimatedText('PALS')])),
                    )
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(
                decoration: BoxDecoration(color: kGreyBackgroundColor, borderRadius: BorderRadius.only(topLeft: Radius.circular(30.0), topRight: Radius.circular(30.0))),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Flexible(child: NavigationButton(key: const Key('welcome_register'), buttonText: 'Register', onPressed: () => Navigator.pushNamed(context, RegisterScreen.route))),
                    Flexible(child: NavigationButton(key: const Key('welcome_login'), buttonText: 'Login', onPressed: () => Navigator.pushNamed(context, LoginScreen.route))),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}