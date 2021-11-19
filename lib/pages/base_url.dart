import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:nirikshan_recon/pages/login.dart';
import 'package:nirikshan_recon/utils/api_client.dart';
import 'package:nirikshan_recon/utils/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UrlInputPage extends StatefulWidget {
  const UrlInputPage({Key? key}) : super(key: key);

  @override
  UrlInputPageState createState() => UrlInputPageState();
}

class UrlInputPageState extends State<UrlInputPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool islogging = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: greyThemeColor,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              flex: 1,
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 32, horizontal: 16),
                    child: const Text(
                      "Login into Nirakshan",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 6,
              child: Center(
                child: _form(),
              ),
            ),
            Expanded(
              flex: 1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  islogging ? const CircularProgressIndicator() : loginButton(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget loginButton() {
    return SizedBox(
      height: 45,
      width: 320,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(primary: purpleThemeColor),
        onPressed: () async {
          if (Uri.parse(_passwordController.text).isAbsolute) {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            prefs.setString('base', _passwordController.text);
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (BuildContext context) => const LoginPage(),
              ),
            );
          } else {
            const snackBar = SnackBar(content: Text('Enter Valid URL'));
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          }
        },
        child: const Text("Next"),
      ),
    );
  }

  Widget _form() {
    return SizedBox(
      height: 240,
      width: 320,
      child: Card(
        color: purpleThemeColor,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 24),
              child: TextFormField(
                controller: _passwordController,
                validator: (String? value) {
                  if (value!.trim().isEmpty) {
                    return 'URL is required';
                  }
                },
                decoration: const InputDecoration(
                    border: OutlineInputBorder(), labelText: 'Enter your URL'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
