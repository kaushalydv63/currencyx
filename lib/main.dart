import 'package:flutter/material.dart';
import 'splash_screen.dart';

void main() {
  runApp(const CurrencyXApp());
}

class CurrencyXApp extends StatelessWidget {
  const CurrencyXApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CurrencyX',

      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
        ),
      ),

      home: const SplashScreen(),
    );
  }
}