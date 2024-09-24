import 'package:chal_pal/src/features/authentication/data/user_exception.dart';
import 'package:chal_pal/src/features/authentication/data/user_repository.dart';
import 'package:chal_pal/src/features/authentication/domain/user.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';

// Generate a MockClient using the Mocktail package.
class MockClient extends Mock implements http.Client {}
// Generate fake uri return for http.get & http.post methods
class MockUri extends Mock implements Uri {}
void main() {

  // This is required if using mocktail; https://pub.dev/packages/mocktail#how-it-works
  setUpAll(() {
    registerFallbackValue(MockUri());
  });

  group('loginUser', () {
    final client = MockClient();
    String newUserEmail = "existinguser@email.com";
    UserRepository userRepository = UserRepository(client, 'somebackendurl');

    test("loginUser should return User when response code is 200", () async {

      when(() => client.get(any())
      ).thenAnswer((_) async => http.Response('{ "id": 1, "email": "${newUserEmail}" }', 200));

      expect(await userRepository.loginUser(email: newUserEmail), isA<User>());
    });

    test("loginUser should throw UserNotFoundException when response code is 404", () async {
      when(() => client.get(any())
      ).thenAnswer((_) async => http.Response('', 404));

      expect(() => userRepository.loginUser(email: newUserEmail), throwsA(isA<UserNotFoundException>()));
    });
    test("loginUser should throw ClientNullRequestException when response code is 400", () async {
      when(() => client.get(any())
      ).thenAnswer((_) async => http.Response('', 400));

      expect(() => userRepository.loginUser(email: newUserEmail), throwsA(isA<ClientNullRequestException>()));
    });
    test("loginUser should throw UnknownException when response code is not 400,404,200", () async {
      when(() => client.get(any())
      ).thenAnswer((_) async => http.Response('', 299));

      expect(() => userRepository.loginUser(email: newUserEmail), throwsA(predicate((e) => e is UnknownException && e.message == 'An unexpected error occurred during authentication :(')));
    });
  });

  group('registerUser', () {
    final client = MockClient();
    String newUserEmail = "existinguser@email.com";
    UserRepository userRepository = UserRepository(client, 'somebackendurl');

    test("registerUser should return User when response code is 201", () async {

      when(() => client.post(
        any(),
        headers: any(named: 'headers'),
        body: any(named: 'body'))
      ).thenAnswer((_) async => http.Response('{ "id": 1, "email": "${newUserEmail}" }', 201));

      expect(await userRepository.registerUser(email: newUserEmail), isA<User>());
    });

    test("registerUser should throw UserAlreadyExistException when response code is 409", () async {
      when(() => client.post(
          any(),
          headers: any(named: 'headers'),
          body: any(named: 'body'))
      ).thenAnswer((_) async => http.Response('', 409));

      expect(() => userRepository.registerUser(email: newUserEmail), throwsA(isA<UserAlreadyExistException>()));
    });
    test("registerUser should throw ClientNullRequestException when response code is 400", () async {
      when(() => client.post(
          any(),
          headers: any(named: 'headers'),
          body: any(named: 'body'))
      ).thenAnswer((_) async => http.Response('', 400));

      expect(() => userRepository.registerUser(email: newUserEmail), throwsA(isA<ClientNullRequestException>()));
    });
    test("registerUser should throw UnknownException when response code is not 400,409,201", () async {
      when(() => client.post(
          any(),
          headers: any(named: 'headers'),
          body: any(named: 'body'))
      ).thenAnswer((_) async => http.Response('', 299));

      expect(() => userRepository.registerUser(email: newUserEmail), throwsA(predicate((e) => e is UnknownException && e.message == 'An unexpected error occurred during authentication :(')));
    });

  });
}
