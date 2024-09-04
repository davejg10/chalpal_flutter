import 'package:chal_pal/src/features/authentication/providers.dart';
import 'package:chal_pal/src/global/widgets/navigation_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../global/constants.dart';
import '../../authentication/presentation/welcome_screen.dart';

class FeedScreen extends ConsumerWidget {
  const FeedScreen({super.key});

  static String route = 'feed';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Center(
          child: Container(
            width: 350,
            height: 350,
            decoration: BoxDecoration(
              color: kGreyBackgroundColor,
              borderRadius: BorderRadius.all(
                Radius.elliptical(
                  40,
                  20,
                ),
              ),
            ),
            child: Column(children: [
              Padding(padding: EdgeInsets.all(30), child: Text('Welcome to the FEEEEEED! ${ref.read(userProvider)}')),
              NavigationButton(
                buttonText: 'Logout',
                onPressed: () {
                  ref.read(userProvider.notifier).state = null;
                  Navigator.pushNamed(context, WelcomeScreen.route);
                },
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
