import 'package:flutter/material.dart';

import 'screens/home_screen.dart';
import 'screens/login_screen.dart';
import 'screens/report_form_screen.dart';

class SemesterProjectApp extends StatelessWidget {
  const SemesterProjectApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'Signage and Document Reader with Bisaya Text-to-Speech',
    initialRoute: '/',
    routes: {
      '/': (_) => const HomeScreen(),
      '/login': (_) => const LoginScreen(),
      '/report': (_) => const ReportFormScreen(),
    },
  );
}
