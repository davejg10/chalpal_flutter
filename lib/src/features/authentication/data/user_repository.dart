import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'dart:convert';

import '../../../../main.dart';
import '../domain/user.dart';
import 'user_exception.dart';

class UserRepository {

  http.Client httpClient;
  String backendUri;

  UserRepository(this.httpClient, this.backendUri);

  Logger _logger = getLogger('user_repository.dart');

  Future<User> register({required String email}) async {
    Map<String, dynamic> newUser = User.toJsonForRegistration(email);
    final response = await httpClient.post(Uri.parse(backendUri + '/users'), headers: {"Content-Type": "application/json"}, body: jsonEncode(newUser));

    switch (response.statusCode) {
      case 201:
        _logger.i('${response.statusCode} - [Reponse]: ${response.body}');
        final user = jsonDecode(response.body);
        return User.fromJson(user);
      case 409:
        _logger.e('${response.statusCode} - [Reponse]: ${response.body}');
        throw UserAlreadyExistException(response.body);
      case 400:
        _logger.e('${response.statusCode} - [Reponse]: ${response.body}');
        throw ClientNullRequestException(response.body);
      default:
        _logger.e('${response.statusCode} - [Reponse]: ${response.body}');
        throw UnknownException();
    }
  }

  Future<User> login({required String email}) async {
    final response = await httpClient.get(Uri.parse(backendUri + '/users/${email}'));

    switch (response.statusCode) {
      case 200:
        _logger.i('${response.statusCode} - [Reponse]: ${response.body}');
        final user = jsonDecode(response.body);
        return User.fromJson(user);
      case 404:
        _logger.e('${response.statusCode} - [Reponse]: ${response.body}');
        throw UserNotFoundException(response.body);
      case 400:
        _logger.e('${response.statusCode} - [Reponse]: ${response.body}');
        throw ClientNullRequestException(response.body);
      default:
        _logger.e('${response.statusCode} - [Reponse]: ${response.body}');
        throw UnknownException();
    }
  }

  // Future<List<User>> getUsers() => _getData(uri: Uri.parse('${backendUri}/users'), builder: (userList) => userList.forEach((user) => User.fromJson(user)));
  // Future<void> logout({required String email}) =>
}
