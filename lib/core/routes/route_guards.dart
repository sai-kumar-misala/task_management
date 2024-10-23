import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RouteGuards {
  static Stream<User?> authStateChanges() {
    return FirebaseAuth.instance.authStateChanges();
  }

  static String? authGuard(BuildContext context, String path) {
    final user = FirebaseAuth.instance.currentUser;
    final bool isAuthenticated = user != null;

    final publicRoutes = ['/', '/signup'];

    final protectedRoutes = ['/dashboard'];

    final isPublicRoute = publicRoutes.contains(path);
    final isProtectedRoute = protectedRoutes.contains(path);

    if (!isAuthenticated && isProtectedRoute) {
      return '/';
    }

    if (isAuthenticated && isPublicRoute && path != '/signup') {
      return '/dashboard';
    }

    return null;
  }
}
