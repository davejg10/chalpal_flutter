import 'package:chal_pal/src/features/authentication/presentation/login_screen.dart';
import 'package:chal_pal/src/features/authentication/presentation/register_screen.dart';
import 'package:chal_pal/src/features/authentication/presentation/welcome_screen.dart';
import 'package:chal_pal/src/features/challenge/presentation/feed_screen.dart';
import 'package:chal_pal/src/misc/custom_log_printer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';

void main() {
  Logger.level = Level.trace;
  runApp(ProviderScope(child: MyApp()));
}

Logger getLogger(String className) {
  return Logger(printer: CustomLogPrinter(className));
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.light().copyWith(
        appBarTheme: const AppBarTheme(
          color: Color(0xFF141A3C),
        ),
        scaffoldBackgroundColor: const Color(0xFF3B72F5),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => WelcomeScreen(),
        LoginScreen.route: (context) => LoginScreen(),
        RegisterScreen.route: (context) => RegisterScreen(),
        FeedScreen.route: (context) => FeedScreen(),
      },
    );
  }
}
