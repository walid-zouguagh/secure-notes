import 'package:flutter/material.dart';
import 'screens/auth_screen.dart';

void main() {
  // Ensure Flutter is initialized before calling DB or Auth
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Secure Notes',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        useMaterial3: true,
      ),
      home: const AuthScreen(), // Start with the Lock Screen
    );
  }
}