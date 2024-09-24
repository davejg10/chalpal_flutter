import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';

// Extension created for the AsyncValue type so we can easily reference Riverpod state and log a message of the error and display it as a snackbar on the screen.
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

// Used to show a generic snackbar
void showSnackbar(BuildContext context, String message, bool error) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor: error ? Colors.red : Colors.green,
      content: Text(
        message,
        style: TextStyle(fontSize: 20, fontFamily: "DMSans-Regular.ttf"),
      ),
    ),
  );
}