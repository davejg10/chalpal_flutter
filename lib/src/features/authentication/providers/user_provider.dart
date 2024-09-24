import 'dart:async';

import 'package:logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../main.dart';
import '../domain/user.dart';
import 'providers.dart';

part 'user_provider.g.dart';

@Riverpod(keepAlive: true)
class UserNotifier extends _$UserNotifier {
  Logger logger = getLogger('user_provider.dart');

  @override
  AsyncValue<User?> build() {
    return const AsyncData(null);
  }

  Future<void> loginUser(String email) async {
    logger.i(('New Login request for user: ${email}'));
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => ref.read(userRepositoryProvider).loginUser(email: email));
    if (state is AsyncData) {
      logger.i(('User: ${email}, sucessfully logged in'));
    }
  }

  Future<void> logoutUser() async {
    if(state.value != null) {
      logger.i(('New logout request for user: ${state.value!.email}'));
      state = AsyncData(null);
    } else {
      logger.i('Logout requested for unsigned user');
    }
  }
}
