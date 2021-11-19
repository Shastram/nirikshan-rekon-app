import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nirikshan_recon/pages/base_url.dart';
import 'package:nirikshan_recon/pages/home.dart';
import 'package:nirikshan_recon/pages/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.getInstance().then((prefs) {
    runApp(MyApp(prefs: prefs));
  });
}

class MyApp extends StatelessWidget {
  final SharedPreferences prefs;
  const MyApp({required this.prefs});

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
      home: buildApp(),
    );
  }

  Widget buildApp() {
    var check = prefs.getBool('loggedIn') ?? false;
    if (check) {
      return const HomeWidget();
    } else {
      return const UrlInputPage();
    }
  }
}
