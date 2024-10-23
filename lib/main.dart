import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app.dart';
import 'config/firebase_config.dart';
import 'features/session/utils/activity_observer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FirebaseConfig.initialize();
  runApp(
    ProviderScope(
      observers: [
        ActivityObserver(),
      ],
      child: const MyApp(),
    ),
  );
}
