import 'package:chal_pal/src/global/widgets/navigation_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../global/constants.dart';
import '../../authentication/presentation/welcome_screen.dart';
import '../../authentication/providers/user_provider.dart';

class FeedScreen extends ConsumerWidget {
  const FeedScreen({super.key});

  static String route = 'feed';

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    return Scaffold(
      appBar: AppBar(
        title: Text('Feed screen'),
        backgroundColor: Colors.white,
      ),
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
              Padding(padding: EdgeInsets.all(30), child: Text('Welcome to the FEEEEEED! ${ref.read(userNotifierProvider)}')),
              NavigationButton(
                key: const Key('logout_button'),
                buttonText: 'Logout',
                onPressed: () {
                  ref.read(userNotifierProvider.notifier).logoutUser();
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
