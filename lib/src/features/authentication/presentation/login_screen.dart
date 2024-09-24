import 'package:chal_pal/src/global/widgets/navigation_button.dart';
import 'package:chal_pal/src/global/widgets/snackbars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../../../../main.dart';
import '../../../global/constants.dart';
import '../../challenge/presentation/feed_screen.dart';
import '../providers/user_provider.dart';

class LoginScreen extends ConsumerWidget {
  LoginScreen({super.key});

  Logger logger = getLogger('login_screen.dart');
  static String route = "login";
  String email = "";

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final messageTextController = TextEditingController();

    ref.listen<AsyncValue>(
      userNotifierProvider,
      (_, state) {
        return state.showSnackbarOnError(context, logger);
      },
    );

    final userNotifierState = ref.watch(userNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Login screen'),
        backgroundColor: Colors.white,
      ),
      body: ModalProgressHUD(
        inAsyncCall: userNotifierState.isLoading,
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
                      key: const Key('login_email_field'),
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
                      key: const Key('login_button'),
                      buttonText: 'Login',
                      onPressed: userNotifierState.isLoading ? null : () async {

                        if (email.trim().isEmpty) {
                          showSnackbar(context, 'The email field cannot be empty.', true);
                          return;
                        }

                        messageTextController.clear();
                        await ref.read(userNotifierProvider.notifier).loginUser(email);
                        if (!ref.read(userNotifierProvider).hasError) {
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
