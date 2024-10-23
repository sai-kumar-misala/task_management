import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RouteGuards {
  static final _auth = FirebaseAuth.instance;

  static String? authGuard(BuildContext context, String currentPath) {
    final user = _auth.currentUser;
    final isAuth = user != null;

    const authenticatedRoutes = ['/dashboard'];
    const unauthenticatedRoutes = ['/', '/signup'];

    if (isAuth && unauthenticatedRoutes.contains(currentPath)) {
      return '/dashboard';
    }

    if (!isAuth && authenticatedRoutes.contains(currentPath)) {
      return '/';
    }

    return null;
  }

  static bool isAuthenticated() => _auth.currentUser != null;

  static Stream<User?> authStateChanges() => _auth.authStateChanges();
}
