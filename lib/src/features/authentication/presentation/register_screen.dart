import 'package:chal_pal/src/global/widgets/navigation_button.dart';
import 'package:chal_pal/src/global/widgets/snackbars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../../../../main.dart';
import '../../../global/constants.dart';
import '../providers/registration_provider.dart';
import 'login_screen.dart';


class RegisterScreen extends ConsumerWidget {
  RegisterScreen({super.key});

  Logger logger = getLogger('register_screen.dart');
  static String route = "register";
  String email = "";

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final messageTextController = TextEditingController();

    ref.listen<AsyncValue>(
      registrationNotifierProvider,
      (_, state) {
        return state.showSnackbarOnError(context, logger);
      },
    );

    final registrationState = ref.watch(registrationNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Register screen'),
        backgroundColor: Colors.white,
      ),
      body: ModalProgressHUD(
        inAsyncCall: registrationState.isLoading,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Center(
            child: Container(
              width: 350,
              height: 350,
              decoration: BoxDecoration(
                  color: kGreyBackgroundColor,
                  borderRadius: BorderRadius.all(Radius.elliptical(
                    40,
                    20,
                  ))),
              child: Padding(
                padding: EdgeInsets.all(30),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    TextField(
                      key: const Key('register_email_field'),
                      controller: messageTextController,
                      keyboardType: TextInputType.emailAddress,
                      textAlign: TextAlign.center,
                      onChanged: (value) {
                        email = value;
                      },
                      style: TextStyle(color: Colors.black, fontFamily: "DMSans-Regular.ttf", fontWeight: FontWeight.w500, fontSize: 20),
                      decoration: kInputTextDecoration.copyWith(hintText: 'Enter your email')),
                    SizedBox(
                      height: 32.0,
                    ),
                    NavigationButton(
                      key: const Key('register_button'),
                      buttonText: 'Register',
                      onPressed: registrationState.isLoading ? null : () async {

                        if (email.trim().isEmpty) {
                          showSnackbar(context, 'The email field cannot be empty.', true);
                          return;
                        }

                        messageTextController.clear();
                        await ref.read(registrationNotifierProvider.notifier).registerUser(email);
                        if (!ref.read(registrationNotifierProvider).hasError) {
                          Navigator.pushNamed(context, LoginScreen.route);
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
