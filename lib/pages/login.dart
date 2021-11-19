import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:nirikshan_recon/pages/home.dart';
import 'package:nirikshan_recon/pages/signup.dart';
import 'package:nirikshan_recon/utils/api_client.dart';
import 'package:nirikshan_recon/utils/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool islogging = false;
  Future<bool> _apiCall(String username, String password) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var api = ApiClient(null, prefs.getString("base") ?? "");
      var resp = await api.login(username, password);
      return true;
    } catch (e) {
      return false;
    }
  }

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
              child: Column(
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SignupPage(),
                          ),
                        );
                      },
                      child: const Text(
                        "Don't have an account?",
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      islogging
                          ? const CircularProgressIndicator()
                          : loginButton(),
                    ],
                  ),
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
          setState(() {
            islogging = true;
          });
          var username = _usernameController.text;
          var password = _passwordController.text;
          try {
            var result = await _apiCall(username, password);
            if (result) {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (BuildContext context) => const HomeWidget(),
                ),
              );
            } else {
              setState(() {
                islogging = false;
              });
              const snackBar = SnackBar(content: Text('Login Failed'));
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            }
          } catch (e) {
            setState(() {
              islogging = false;
            });
            const snackBar = SnackBar(content: Text('Login Failed'));
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          }
        },
        child: const Text("Login"),
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
                validator: (String? value) {
                  if (value!.trim().isEmpty) {
                    return 'username is required';
                  }
                },
                controller: _usernameController,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Enter your username'),
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 24),
              child: TextFormField(
                controller: _passwordController,
                validator: (String? value) {
                  if (value!.trim().isEmpty) {
                    return 'Password is required';
                  }
                },
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Enter your password'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
