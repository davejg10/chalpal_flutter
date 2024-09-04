import 'package:chal_pal/src/global/widgets/navigation_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../../../../main.dart';
import '../../../global/constants.dart';
import '../../challenge/presentation/feed_screen.dart';
import '../controller/login_screen_controller.dart';
import '../providers.dart';

class LoginScreen extends ConsumerWidget {

  Logger logger = getLogger('login_screen.dart');
  static String route = "login";
  late String email;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final messageTextController = TextEditingController();

    ref.listen<AsyncValue>(
      loginScreenControllerProvider,
      (_, state) {
        return state.showSnackbarOnError(context, logger);
      },
    );

    AsyncValue<void> loginState = ref.watch(loginScreenControllerProvider);

    return Scaffold(
      body: ModalProgressHUD(
        inAsyncCall: loginState.isLoading,
        child: Padding(
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
              child: Padding(
                padding: EdgeInsets.all(30),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    TextField(
                      controller: messageTextController,
                      keyboardType: TextInputType.emailAddress,
                      textAlign: TextAlign.center,
                      onChanged: (value) {
                        email = value;
                      },
                      style: TextStyle(color: Colors.black, fontFamily: "DMSans-Regular.ttf", fontWeight: FontWeight.w500, fontSize: 20),
                      decoration: kInputTextDecoration.copyWith(hintText: 'Enter your email'),
                    ),
                    SizedBox(
                      height: 32.0,
                    ),
                    NavigationButton(
                      buttonText: 'Login',
                      onPressed: loginState.isLoading ? null : () async {
                        messageTextController.clear();
                        await ref.read(loginScreenControllerProvider.notifier).login(email);
                        if (!ref.read(loginScreenControllerProvider).hasError) {
                          Navigator.pushNamed(context, FeedScreen.route);
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
