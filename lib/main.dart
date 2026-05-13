import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'theme.dart';
import 'screens/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await dotenv.load(fileName: ".env");
  } catch (e) {
    print("Warning: Could not load .env file. $e");
  }

  try {
    // Requires google-services.json for android or GoogleService-Info.plist for iOS.
    // If these are not present, this will throw an exception, which we catch
    // to allow the UI to run with mock data.
    await Firebase.initializeApp();
  } catch (e) {
    print("Warning: Firebase initialization failed. $e");
    print("UI will run using mock data fallbacks.");
  }

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '42_D Classroom AI',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: const LoginScreen(),
    );
  }
}
