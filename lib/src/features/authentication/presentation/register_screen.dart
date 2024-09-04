import 'package:chal_pal/src/global/widgets/navigation_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../../../../main.dart';
import '../../../global/constants.dart';
import '../controller/registration_screen_controller.dart';
import '../providers.dart';
import 'login_screen.dart';


class RegisterScreen extends ConsumerWidget {
  Logger logger = getLogger('register_screen.dart');

  static String route = "register";
  late String email;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final messageTextController = TextEditingController();

    ref.listen<AsyncValue>(
      registrationScreenControllerProvider,
      (_, state) {
        return state.showSnackbarOnError(context, logger);
      },
    );

    final AsyncValue<void> registerState = ref.watch(registrationScreenControllerProvider);

    return Scaffold(
      body: ModalProgressHUD(
        inAsyncCall: registerState.isLoading,
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
                      buttonText: 'Register',
                      onPressed: registerState.isLoading ? null : () async {
                        messageTextController.clear();
                        await ref.read(registrationScreenControllerProvider.notifier).register(email);
                        if (!registerState.hasError) {
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
