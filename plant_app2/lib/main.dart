import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Firebase başlat
  await Firebase.initializeApp();

  // Supabase başlat
  await Supabase.initialize(
    url: 'https://dwulueceajzfyygxzein.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImR3dWx1ZWNlYWp6Znl5Z3h6ZWluIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjQ2NTI1NjUsImV4cCI6MjA4MDIyODU2NX0.R5Tfd62BVWZx7DAEOOGvbHJkvwo5g5_R-boLfNdbvDw',
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bitki Doktoru',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF00C853)),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}
