import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../main.dart';
import '../providers.dart';

part 'registration_screen_controller.g.dart';

@riverpod
class RegistrationScreenController extends _$RegistrationScreenController {
  Logger logger = getLogger('registration_screen_controller.dart');

  @override
  FutureOr<void> build() {}

  Future<void> register(String email) async {
    logger.i('Registering new User with email: ${email}');
    state = const AsyncLoading();
    final user = await AsyncValue.guard(() => ref.read(userRepositoryProvider).register(email: email));
    if (user is AsyncData) {
      logger.i(('User: ${email}, successfully registered.'));
    }
    state = user;
  }
}