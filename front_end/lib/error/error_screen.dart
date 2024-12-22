import 'dart:async';

import 'package:flutter/material.dart';
import 'package:http/http.dart';

class ErrorScreen extends StatelessWidget {
  const ErrorScreen(this.error, {super.key});

  final Exception error;

  String getErrorMessage(Exception error) {
    if (error is ClientException) {
      return 'Network error occurred. Please check your connection.';
    } else if (error is TimeoutException) {
      return 'Request timed out. Please try again.';
    } else if (error is FormatException) {
      return 'An error occurred while parsing data. Please try again.';
    } else {
      return 'An unexpected error occurred. Please try again.';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(getErrorMessage(error),
            
            textAlign: TextAlign.center,
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(true);
             
              },
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}
