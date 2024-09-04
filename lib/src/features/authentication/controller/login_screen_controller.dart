import 'dart:async';

import 'package:logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../main.dart';
import '../providers.dart';


part 'login_screen_controller.g.dart';

@riverpod
class LoginScreenController extends _$LoginScreenController {
  Logger logger = getLogger('login_screen_controller.dart');

  @override
  FutureOr<void> build() {}

  Future<void> login(String email) async {
    logger.i(('New Login request for user: ${email}'));
    state = const AsyncLoading();
    final user = await AsyncValue.guard(() => ref.read(userRepositoryProvider).login(email: email));
    if (user is AsyncData) {
      logger.i(('User: ${email}, sucessfully logged in'));
      ref.read(userProvider.notifier).state = user.value; // Store authenticated user in new provider
    }
    state = user;
  }
}
