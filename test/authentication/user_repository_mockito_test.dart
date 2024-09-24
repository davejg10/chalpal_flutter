import 'package:chal_pal/src/features/authentication/data/user_exception.dart';
import 'package:chal_pal/src/features/authentication/data/user_repository.dart';
import 'package:chal_pal/src/features/authentication/domain/user.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;

import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';

// Generate a MockClient using the Mockito package.
@GenerateMocks([http.Client])
//Import generated mocks
import 'user_repository_mockito_test.mocks.dart';

void main() {

  group('(group: loginUser) -', () {
    final client = MockClient();
    String newUserEmail = "existinguser@email.com";
    UserRepository userRepository = UserRepository(client, 'somebackendurl');

    test("should return User when response code is 200", () async {

      when(client.get(any)
      ).thenAnswer((_) async => http.Response('{ "id": 1, "email": "${newUserEmail}" }', 200));

      expect(await userRepository.loginUser(email: newUserEmail), isA<User>());
    });

    test("should throw UserNotFoundException when response code is 404", () async {
      when(client.get(any)
      ).thenAnswer((_) async => http.Response('', 404));

      expect(() => userRepository.loginUser(email: newUserEmail), throwsA(isA<UserNotFoundException>()));
    });
    test("should throw ClientNullRequestException when response code is 400", () async {
      when(client.get(any)
      ).thenAnswer((_) async => http.Response('', 400));

      expect(() => userRepository.loginUser(email: newUserEmail), throwsA(isA<ClientNullRequestException>()));
    });
    test("should throw UnknownException when response code is not 400,404,200", () async {
      when(client.get(any)
      ).thenAnswer((_) async => http.Response('', 299));

      expect(() => userRepository.loginUser(email: newUserEmail), throwsA(predicate((e) => e is UnknownException && e.message == 'An unexpected error occurred during authentication :(')));
    });
  });

  group('(group: registerUser) - ', () {
    final client = MockClient();
    String newUserEmail = "existinguser@email.com";
    UserRepository userRepository = UserRepository(client, 'somebackendurl');

    test("should return User when response code is 201", () async {

      when(client.post(
        any,
        headers: anyNamed('headers'),
        body: anyNamed('body'),
      )).thenAnswer((_) async => http.Response('{ "id": 1, "email": "${newUserEmail}" }', 201));

      expect(await userRepository.registerUser(email: newUserEmail), isA<User>());
    });

    test("should throw UserAlreadyExistException when response code is 409", () async {
      when(client.post(
        any,
        headers: anyNamed('headers'),
        body: anyNamed('body'),
      )).thenAnswer((_) async => http.Response('', 409));

      expect(() => userRepository.registerUser(email: newUserEmail), throwsA(isA<UserAlreadyExistException>()));
    });
    test("should throw ClientNullRequestException when response code is 400", () async {
      when(client.post(
        any,
        headers: anyNamed('headers'),
        body: anyNamed('body'),
      )).thenAnswer((_) async => http.Response('', 400));

      expect(() => userRepository.registerUser(email: newUserEmail), throwsA(isA<ClientNullRequestException>()));
    });
    test("should throw UnknownException when response code is not 400,409,201", () async {
      when(client.post(
        any,
        headers: anyNamed('headers'),
        body: anyNamed('body'),
      )).thenAnswer((_) async => http.Response('', 299));

      expect(() => userRepository.registerUser(email: newUserEmail), throwsA(predicate((e) => e is UnknownException && e.message == 'An unexpected error occurred during authentication :(')));
    });

  });
}
