import 'package:chal_pal/src/features/authentication/data/user_exception.dart';
import 'package:chal_pal/src/features/authentication/data/user_repository.dart';
import 'package:chal_pal/src/features/authentication/domain/user.dart';
import 'package:chal_pal/src/features/authentication/providers/providers.dart';
import 'package:chal_pal/src/features/authentication/providers/registration_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../riverpod_provider_container.dart';

//Mock the user repository class
class MockUserRepository extends Mock implements UserRepository {}

// a generic Listener class, used to keep track of state changes
class Listener<T> extends Mock {
  void call(T? previous, T next);
}

void main() {
  setUpAll(() {
    registerFallbackValue(AsyncLoading<void>());
    registerFallbackValue(AsyncError<User?>('some error', StackTrace.current));
  });

  group('(group: registerUser) -', () {

    test('registration notifiers initial state is AsyncData(void)', () {
      // Creates a container containing all of our providers
      final container = createContainer();

      // Create a listener for AsyncValue
      final listener = Listener<AsyncValue<void>>();

      // listen to the userNotifierProvider and call [listener] whenever its value changes
      container.listen(
        registrationNotifierProvider,
        listener,
        fireImmediately: true,
      ); // Calling this method on the userNotifierProvider causes the underlying UserNotifier to be initialized, since all providers are lazy-loaded.

      verify(
        // the build method returns a value immediately, so we expect AsyncData
            () => listener(null, const AsyncData<void>(null)),
      ).called(1);

      // verify that the listener is no longer called
      verifyNoMoreInteractions(listener);
    });

    test('registration notifier should set state to AsyncLoading & then AsyncData<void> when the userRepository returns a User object', () async {
      final userRepository = MockUserRepository();
      const String newUserEmail = 'existing@email.com';
      final User newUser = User(id: 1, email: newUserEmail);

      when(() => userRepository.registerUser(email: newUserEmail)).thenAnswer((_) async => newUser);

      // Creates a container containing all of our providers and additionally injects our Mock userRepository into the userRepositoryProvider.
      final container = createContainer(overrides: [
        userRepositoryProvider.overrideWithValue(userRepository)
      ]);

      // create a listener
      final listener = Listener<AsyncValue<void>>();
      // listen to the provider and call [listener] whenever its value changes
      container.listen(
        registrationNotifierProvider,
        listener,
        fireImmediately: true,
      );

      // verify initial value from the build method
      verify(() => listener(null, AsyncData<void>(null))).called(1);

      // get the notifier we're trying to test via container.read
      final registrationNotifier = container.read(registrationNotifierProvider.notifier);
      // run
      await registrationNotifier.registerUser(newUserEmail);

      // verify
      verifyInOrder([
        // transition from data to loading state
        () => listener(AsyncData<void>(null), any(that: isA<AsyncLoading>())),
        // transition from loading state to data
        () => listener(any(that: isA<AsyncLoading>()), AsyncData<void>(newUser)),
      ]);

      verifyNoMoreInteractions(listener);
      verify(() => userRepository.registerUser(email: any(named: 'email'))).called(1);
    });

    test('registration notifier should set state to AsyncLoading & then AsyncError when the userRepository throws an exception', () async {
      final userRepository = MockUserRepository();
      const String existingUserEmail = 'existing@email.com';

      when(() => userRepository.registerUser(email: existingUserEmail)).thenThrow(UserAlreadyExistException('some error'));

      // Creates a container containing all of our providers and additionally injects our Mock userRepository into the userRepositoryProvider.
      final container = createContainer(overrides: [
        userRepositoryProvider.overrideWithValue(userRepository)
      ]);

      // create a listener
      final listener = Listener<AsyncValue<void>>();
      // listen to the provider and call [listener] whenever its value changes
      container.listen(
        registrationNotifierProvider,
        listener,
        fireImmediately: true,
      );

      // verify initial value from the build method
      verify(() => listener(null, AsyncData<void>(null))).called(1);

      // get the notifier we're trying to test via container.read
      final registrationNotifier = container.read(registrationNotifierProvider.notifier);
      // run
      await registrationNotifier.registerUser(existingUserEmail);

      // verify
      verifyInOrder([
        // transition from data to loading state
            () => listener(AsyncData<void>(null), any(that: isA<AsyncLoading>())),
        // transition from loading state to error state
            () => listener(any(that: isA<AsyncLoading>()), any(that: isA<AsyncError>())),
      ]);

      verifyNoMoreInteractions(listener);
      verify(() => userRepository.registerUser(email: any(named: 'email'))).called(1);
    });

  });

}