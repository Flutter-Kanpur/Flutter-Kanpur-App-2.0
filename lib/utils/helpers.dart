import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Pushes a new route onto the navigation stack
void navigateTo(BuildContext context, String path, {Object? arguments}) {
  if (arguments != null) {
    context.push(path, extra: arguments);
  } else {
    context.push(path);
  }
}

/// Replaces the current route with the new route (useful for login success, splash screens, etc.)
void navigateAndReplace(
  BuildContext context,
  String path, {
  Object? arguments,
}) {
  if (arguments != null) {
    context.pushReplacement(path, extra: arguments);
  } else {
    context.pushReplacement(path);
  }
}

/// Pops all routes and pushes a new one (clears entire stack)
void navigateAndRemoveUntil(
  BuildContext context,
  String path, {
  Object? arguments,
}) {
  if (arguments != null) {
    context.go(path, extra: arguments);
  } else {
    context.go(path);
  }
}
