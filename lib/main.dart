import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'onboarding_screen.dart';

void main() async {
  // Wajib inisialisasi binding
  WidgetsFlutterBinding.ensureInitialized();

  // Inisialisasi Firebase
  try {
    await Firebase.initializeApp();
    print("✅ Firebase Terkoneksi!");
  } catch (e) {
    print("❌ Gagal Koneksi Firebase: $e");
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MyHeadStyle',
      theme: ThemeData(primarySwatch: Colors.purple),
      home: const OnboardingScreen(),
    );
  }
}