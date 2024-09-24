import 'package:chal_pal/src/features/authentication/domain/user.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const String email = "an@email.com";

  group('(group: User model) -', () {
    test('toJson should return a json representation of user', () {
      int id = 1;
      Map<String, dynamic> newUserJson = {
        'id': id,
        'email': email,
      };
      final User newUser = User.fromJson(newUserJson);

      expect(newUser.id, id);
      expect(newUser.email, email);
    });

    test('toJsonForRegistrationJson should return a json representation of user', () {
      Map<String, dynamic> newUserJson = User.toJsonForRegistration(email);

      expect(newUserJson["email"], email);
    });
  });

}
