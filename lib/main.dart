import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nirikshan_recon/pages/home.dart';
import 'package:nirikshan_recon/pages/login.dart';
import 'package:nirikshan_recon/utils/colors.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nirikshan Recon',
      theme: ThemeData(
        textTheme: GoogleFonts.jetBrainsMonoTextTheme(
          Theme.of(context).textTheme.apply(
                bodyColor: Colors.white,
                displayColor: Colors.white,
              ),
        ),
        brightness: Brightness.dark,
        primarySwatch: Colors.grey,
      ),
      home: const LoginPage(),
    );
  }
}
