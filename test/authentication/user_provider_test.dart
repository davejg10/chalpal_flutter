import 'package:chal_pal/src/features/authentication/data/user_exception.dart';
import 'package:chal_pal/src/features/authentication/data/user_repository.dart';
import 'package:chal_pal/src/features/authentication/domain/user.dart';
import 'package:chal_pal/src/features/authentication/providers/providers.dart';
import 'package:chal_pal/src/features/authentication/providers/user_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../riverpod_provider_container.dart';

// This test code is taken from
//https://codewithandrea.com/articles/unit-test-async-notifier-riverpod/

//Mock the user repository class
class MockUserRepository extends Mock implements UserRepository {}

// a generic Listener class, used to keep track of state changes
class Listener<T> extends Mock {
  void call(T? previous, T next);
}

void main() {

  setUpAll(() {
    registerFallbackValue(AsyncError<User?>('some error', StackTrace.current));
  });

  group('loginUser', () {

    test('userNotifier initial state is AsyncData(null)', () {
      // Creates a container containing all of our providers
      final container = createContainer();

      // Create a listener for AsyncValue
      final listener = Listener<AsyncValue<User?>>();

      // listen to the userNotifierProvider and call [listener] whenever its value changes
      container.listen(
        userNotifierProvider,
        listener,
        fireImmediately: true,
      ); // Calling this method on the userNotifierProvider causes the underlying UserNotifier to be initialized, since all providers are lazy-loaded.

      verify(
        // the build method returns a value immediately, so we expect AsyncData
        () => listener(null, const AsyncData<User?>(null)),
      ).called(1);

      // verify that the listener is no longer called
      verifyNoMoreInteractions(listener);
    });

    test('loginUser should set state to AsyncLoading & then AsyncData<User> when the userRepository returns a User object', () async {
      final userRepository = MockUserRepository();
      const String existingUserEmail = 'existing@email.com';
      final User existingUser = User(id: 1, email: existingUserEmail);

      when(() => userRepository.loginUser(email: existingUserEmail)).thenAnswer((_) async => existingUser);

      // Creates a container containing all of our providers and additionally injects our Mock userRepository into the userRepositoryProvider.
      final container = createContainer(overrides: [
        userRepositoryProvider.overrideWithValue(userRepository)
      ]);

      // create a listener
      final listener = Listener<AsyncValue<User?>>();
      // listen to the provider and call [listener] whenever its value changes
      container.listen(
        userNotifierProvider,
        listener,
        fireImmediately: true,
      );

      // verify initial value from the build method
      verify(() => listener(null, AsyncData<User?>(null))).called(1);
      // get the notifier we're trying to test via container.read
      final userNotifier = container.read(userNotifierProvider.notifier);
      // run
      await userNotifier.loginUser(existingUserEmail);

      // verify
      verifyInOrder([
        // transition from data to loading state
        () => listener(AsyncData<User?>(null), AsyncLoading<User?>()),
        // transition from loading state to data
        () => listener(AsyncLoading<User?>(), AsyncData<User?>(existingUser)),
      ]);

      verifyNoMoreInteractions(listener);
      verify(() => userRepository.loginUser(email: any(named: 'email'))).called(1);
    });

    test('loginUser should set state to AsyncLoading & then AsyncError<User > when the userRepository throws an exception', () async {
      final userRepository = MockUserRepository();
      const String invalidUserEmail = 'invalid@email.com';

      when(() => userRepository.loginUser(email: invalidUserEmail)).thenThrow(UserNotFoundException('some error'));

      // Creates a container containing all of our providers and additionally injects our Mock userRepository into the userRepositoryProvider.
      final container = createContainer(overrides: [
        userRepositoryProvider.overrideWithValue(userRepository)
      ]);

      // create a listener
      final listener = Listener<AsyncValue<User?>>();
      // listen to the provider and call [listener] whenever its value changes
      container.listen(
        userNotifierProvider,
        listener,
        fireImmediately: true,
      );

      // verify initial value from the build method
      verify(() => listener(null, AsyncData<User?>(null))).called(1);
      // get the notifier we're trying to test via container.read
      final userNotifier = container.read(userNotifierProvider.notifier);
      // run
      await userNotifier.loginUser(invalidUserEmail);

      // verify
      verifyInOrder([
        // transition from data to loading state
        () => listener(AsyncData<User?>(null), AsyncLoading<User?>()),
        // transition from loading state to error state
        () => listener(AsyncLoading<User?>(), any(that: isA<AsyncError>())),
      ]);

      verifyNoMoreInteractions(listener);
      verify(() => userRepository.loginUser(email: any(named: 'email'))).called(1);
    });

  });

  group('logoutUser', () {

    test('logoutUser should set state to AsyncData(null) when the state currently contains a User object', () async {
      final container = createContainer();
      final User loggedInUser = User(id:1, email: 'loggedin@user.com');

      // Manually edit the state to setup a logged in user
      final userNotifier = container.read(userNotifierProvider.notifier);
      userNotifier.state = AsyncData(loggedInUser);

      // create a listener
      final listener = Listener<AsyncValue<User?>>();
      // listen to the provider and call [listener] whenever its value changes
      container.listen(
        userNotifierProvider,
        listener,
        fireImmediately: true,
      );

      // because we manually manipulated state the state will go from null to AsynData(User) on build() method of notifier
      // This also allows us to ensure that the state is in a state of being logged in.
      verify(() => listener(null, AsyncData<User?>(loggedInUser))).called(1);

      // run
      await userNotifier.logoutUser();

      verify(
        // transition from logged in state to logged out state
        () => listener(AsyncData<User?>(loggedInUser), AsyncData<User?>(null)),
      ).called(1);

      verifyNoMoreInteractions(listener);
    });

    test('logoutUser should not change state when there is no User stored in state', () async {
      final container = createContainer();

      // create a listener
      final listener = Listener<AsyncValue<User?>>();
      // listen to the provider and call [listener] whenever its value changes
      container.listen(
        userNotifierProvider,
        listener,
        fireImmediately: true,
      );

      // because we manually manipulated state the state will go from null to AsynData(User) on build() method of notifier
      // This also allows us to ensure that the state is in a state of being logged in.
      verify(() => listener(null, AsyncData<User?>(null))).called(1);

      final userNotifier = container.read(userNotifierProvider.notifier);

      // run
      await userNotifier.logoutUser();

      verifyNoMoreInteractions(listener);
    });

  });

}