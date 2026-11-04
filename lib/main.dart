import 'package:flutter/material.dart';
import 'pages/landing_page.dart';

void main() => runApp(const MyApp());
 
class MyApp extends StatelessWidget {
  const MyApp({super.key});
 
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Polibatam Lost & Found',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true),
      home: const LandingPage(), // halaman pertama = Landing Page
    );
  }
}