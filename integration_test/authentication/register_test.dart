import 'package:chal_pal/main.dart';
import 'package:chal_pal/src/features/authentication/data/user_repository.dart';
import 'package:chal_pal/src/features/authentication/presentation/login_screen.dart';
import 'package:chal_pal/src/features/authentication/presentation/register_screen.dart';
import 'package:chal_pal/src/features/authentication/presentation/welcome_screen.dart';
import 'package:chal_pal/src/global/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:http/http.dart' as http;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('register integration tests', () {

    testWidgets('register a new user that doesnt exist', (tester) async {
      String newUserEmail = "newuser@email.com";
      await tester.pumpWidget(ProviderScope(child: MyApp()));

      //WELCOME PAGE
      expect(find.byType(WelcomeScreen), findsOneWidget);

      final registerPageButton = find.byKey(const ValueKey('welcome_register'));

      // Click on register button
      await tester.tap(registerPageButton);

      // Trigger a frame
      await tester.pumpAndSettle();

      //REGISTER PAGE
      expect(find.byType(RegisterScreen), findsOneWidget);

      await tester.enterText(find.byKey(const ValueKey('register_email_field')), newUserEmail);

      final registerButton = find.byKey(const ValueKey('register_button'));

      await tester.tap(registerButton);

      await tester.pumpAndSettle();

      //LOGIN PAGE
      expect(find.byType(LoginScreen), findsOneWidget);
    });

    testWidgets('register a new user that already exists', (tester) async {
      String existingEmail = "existing@email.com";
      UserRepository userRepository = UserRepository(http.Client(), backendUri);
      await userRepository.registerUser(email: existingEmail);

      await tester.pumpWidget(ProviderScope(child: MaterialApp(home: RegisterScreen())));

      //REGISTER PAGE
      expect(find.byType(RegisterScreen), findsOneWidget);

      await tester.enterText(find.byKey(const ValueKey('register_email_field')), existingEmail);

      final registerButton = find.byKey(const ValueKey('register_button'));

      await tester.tap(registerButton);

      await tester.pumpAndSettle();

      //LOGIN PAGE
      expect(find.byType(LoginScreen), findsOneWidget);

      expect(find.byType(SnackBar), findsOneWidget);
      expect(find.text('The user with email: ${existingEmail} already exists.'), findsOneWidget);
    });

    testWidgets('register with an empty email field', (tester) async {
      await tester.pumpWidget(ProviderScope(child: MaterialApp(home: RegisterScreen())));

      //REGISTER PAGE
      expect(find.byType(RegisterScreen), findsOneWidget);

      await tester.enterText(find.byKey(const ValueKey('register_email_field')), "");

      final registerButton = find.byKey(const ValueKey('register_button'));

      await tester.tap(registerButton);

      await tester.pumpAndSettle();

      //LOGIN PAGE
      expect(find.byType(LoginScreen), findsOneWidget);

      expect(find.byType(SnackBar), findsOneWidget);
      expect(find.text('The email field cannot be empty.'), findsOneWidget);
    });

  });
}