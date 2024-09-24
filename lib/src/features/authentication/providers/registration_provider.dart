import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../main.dart';
import 'providers.dart';

part 'registration_provider.g.dart';

@riverpod
class RegistrationNotifier extends _$RegistrationNotifier {
  Logger logger = getLogger('registration_provider.dart');

  @override
  FutureOr<void> build() {}

  Future<void> registerUser(String email) async {
    logger.i('Registering new User with email: ${email}');
    state = const AsyncLoading();
    final user = await AsyncValue.guard(() => ref.read(userRepositoryProvider).registerUser(email: email));
    if (user is AsyncData) {
      logger.i(('User: ${email}, successfully registered.'));
    }
    state = user;
  }
}