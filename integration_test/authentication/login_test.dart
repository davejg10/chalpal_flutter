import 'package:chal_pal/main.dart';
import 'package:chal_pal/src/features/authentication/data/user_repository.dart';
import 'package:chal_pal/src/features/authentication/domain/user.dart';
import 'package:chal_pal/src/features/authentication/presentation/login_screen.dart';
import 'package:chal_pal/src/features/authentication/presentation/welcome_screen.dart';
import 'package:chal_pal/src/features/authentication/providers/user_provider.dart';
import 'package:chal_pal/src/features/challenge/presentation/feed_screen.dart';
import 'package:chal_pal/src/global/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:http/http.dart' as http;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('login integration tests', () {

    testWidgets('login with a user that exists', (tester) async {
      String newUserEmail = "newuser@logintest.com";
      UserRepository userRepository = UserRepository(http.Client(), backendUri);
      await userRepository.registerUser(email: newUserEmail);

      await tester.pumpWidget(ProviderScope(child: MyApp()));

      //WELCOME PAGE
      expect(find.byType(WelcomeScreen), findsOneWidget);

      final loginPageButton = find.byKey(const ValueKey('welcome_login'));

      // Click on login button
      await tester.tap(loginPageButton);

      // Trigger a frame
      await tester.pumpAndSettle();

      //LOGIN PAGE
      expect(find.byType(LoginScreen), findsOneWidget);

      await tester.enterText(find.byKey(const ValueKey('login_email_field')), newUserEmail);

      final loginButton = find.byKey(const ValueKey('login_button'));

      await tester.tap(loginButton);

      await tester.pumpAndSettle();

      //FEED PAGE
      expect(find.byType(FeedScreen), findsOneWidget);

      //Riverpod state
      final feedWidget = tester.element(find.byType(FeedScreen));
      final container = ProviderScope.containerOf(feedWidget);

      // This allows us to ignore the id field which could be anything due to integration tests.
      expect(container.read(userNotifierProvider),
        predicate<AsyncData<User?>>((u) => u.value!.email == newUserEmail),
      );
    });

    testWidgets('login with a user that doesnt exist', (tester) async {
      String invalidEmail = "random@email.com";

      await tester.pumpWidget(ProviderScope(child: MaterialApp(home: LoginScreen())));

      //LOGIN PAGE
      expect(find.byType(LoginScreen), findsOneWidget);

      await tester.enterText(find.byKey(const ValueKey('login_email_field')), invalidEmail);

      final loginButton = find.byKey(const ValueKey('login_button'));

      await tester.tap(loginButton);

      await tester.pumpAndSettle();

      expect(find.byType(LoginScreen), findsOneWidget);

      expect(find.byType(SnackBar), findsOneWidget);
      expect(find.text('The user with email: ${invalidEmail} does not exist.'), findsOneWidget);

      //Riverpod state
      final loginWidget = tester.element(find.byType(LoginScreen));
      final container = ProviderScope.containerOf(loginWidget);

      expect(container.read(userNotifierProvider),
        predicate<AsyncError<User?>>((u) => u.error!.toString() == 'The user with email: ${invalidEmail} does not exist.'),
      );
    });

    testWidgets('login with an empty email field', (tester) async {
      await tester.pumpWidget(ProviderScope(child: MaterialApp(home: LoginScreen())));

      //LOGIN PAGE
      expect(find.byType(LoginScreen), findsOneWidget);

      await tester.enterText(find.byKey(const ValueKey('login_email_field')), "");

      final loginButton = find.byKey(const ValueKey('login_button'));

      await tester.tap(loginButton);

      await tester.pumpAndSettle();

      expect(find.byType(LoginScreen), findsOneWidget);

      expect(find.byType(SnackBar), findsOneWidget);
      expect(find.text('The email field cannot be empty.'), findsOneWidget);
    });

  });
}