import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:http/http.dart' as http;

import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'data/user_repository.dart';
import 'domain/user.dart';

// The localhost Java backend
String backendUri = 'http://10.0.2.2:8080';

final userRepositoryProvider = Provider<UserRepository>((ref) {
  return UserRepository(http.Client(), backendUri);
});

// // This will store the user once they have been successfully logged in
final userProvider = StateProvider<User?>((ref) => null);

// Extension created for the AsyncValue type so we can easily log a message of the error and display it as a snackbar on the screen.
extension AsyncValueUI on AsyncValue {

  void showSnackbarOnError(BuildContext context, Logger logger) {
    if (!isLoading && hasError) {
      logger.e(error);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text(
            error.toString(),
            style: TextStyle(fontSize: 20, fontFamily: "DMSans-Regular.ttf"),
          ),
        ),
      );
    }
  }
}
