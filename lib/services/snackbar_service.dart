import 'package:flutter/material.dart';

class SnackbarService {
  static final navigatorKey = GlobalKey<NavigatorState>();
  
  static void showSnackbar({required String message}) {
    ScaffoldMessenger.of(navigatorKey.currentContext!).removeCurrentSnackBar();

    ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(SnackBar(
      content: Text('$message', textAlign: TextAlign.justify),
      behavior: SnackBarBehavior.floating,
    ));
  }
}
