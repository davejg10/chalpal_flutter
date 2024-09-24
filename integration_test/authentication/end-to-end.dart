import 'dart:io';

import 'package:chal_pal/main.dart';
import 'package:chal_pal/src/features/authentication/domain/user.dart';
import 'package:chal_pal/src/features/authentication/presentation/login_screen.dart';
import 'package:chal_pal/src/features/authentication/presentation/register_screen.dart';
import 'package:chal_pal/src/features/authentication/presentation/welcome_screen.dart';
import 'package:chal_pal/src/features/authentication/providers/user_provider.dart';
import 'package:chal_pal/src/features/challenge/presentation/feed_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('end-to-end authentication integration tests', () {
    testWidgets('register a new user, login with that user and then logout', (
        tester) async {
      await tester.pumpWidget(ProviderScope(child: MyApp()));

      expect(find.byType(WelcomeScreen), findsOneWidget);
      final String newUserEmail = "auth@e2e.com";

      //WELCOME PAGE
      final registerPageButton = find.byKey(const ValueKey('welcome_register'));

      // Click on register button
      await tester.tap(registerPageButton);

      // Trigger a frame
      await tester.pumpAndSettle();

      //REGISTER PAGE
      expect(find.byType(RegisterScreen), findsOneWidget);

      await tester.enterText(
          find.byKey(const ValueKey('register_email_field')), newUserEmail);

      final registerButton = find.byKey(const ValueKey('register_button'));

      await tester.tap(registerButton);

      await tester.pumpAndSettle();

      //LOGIN PAGE
      expect(find.byType(LoginScreen), findsOneWidget);

      await tester.enterText(
          find.byKey(const ValueKey('login_email_field')), newUserEmail);

      final loginButton = find.byKey(const ValueKey('login_button'));

      await tester.tap(loginButton);

      await tester.pumpAndSettle();

      //FEED PAGE
      expect(find.byType(FeedScreen), findsOneWidget);

      // Riverpod state
      final feedWidget = tester.element(find.byType(FeedScreen));
      final feedContainer = ProviderScope.containerOf(feedWidget);
      expect(feedContainer.read(userNotifierProvider),
        predicate<AsyncData<User?>>((u) => u.value!.email == newUserEmail),
      );

      //LOGOUT
      final logoutButton = find.byKey(const ValueKey('logout_button'));

      await tester.tap(logoutButton);

      await tester.pumpAndSettle();
      sleep(Duration(seconds: 5));

      expect(find.byType(WelcomeScreen), findsOneWidget);
      final welcomeWidget = tester.element(find.byType(WelcomeScreen));
      final welcomeContainer = ProviderScope.containerOf(welcomeWidget);
      expect(welcomeContainer.read(userNotifierProvider), AsyncData<User?>(null));
    });

  });
}