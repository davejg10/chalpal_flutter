sealed class APIException implements Exception {
  APIException(this.message);

  final String message;

  @override
  String toString() {
    return this.message;
  }
}

class UserNotFoundException extends APIException {
  UserNotFoundException(String error) : super(error);
}

class UserAlreadyExistException extends APIException {
  UserAlreadyExistException(String error) : super(error);
}

class ClientNullRequestException extends APIException {
  ClientNullRequestException(String error) : super(error);
}

class UnknownException extends APIException {
  UnknownException() : super('An unexpected error occurred during authentication :(');
}
