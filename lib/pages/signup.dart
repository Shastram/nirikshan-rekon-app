import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:nirikshan_recon/pages/login.dart';
import 'package:nirikshan_recon/utils/api_client.dart';
import 'package:nirikshan_recon/utils/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({Key? key}) : super(key: key);

  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  bool islogging = false;

  Future<bool> _apiCall(
      String username, String password, String name, String email) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var api = ApiClient(null, prefs.getString("base") ?? "");
      await api.signup(username, password, name, email);
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
                      "Sign up for Nirakshan",
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
          try {
            var resp = await _apiCall(
                _usernameController.text,
                _passwordController.text,
                _nameController.text,
                _emailController.text);
            if (resp) {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (BuildContext context) => const LoginPage(),
                ),
              );
            } else {
              const snackBar = SnackBar(content: Text('Unable to signup!'));
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            }
          } catch (e) {
            const snackBar = SnackBar(content: Text('Unable to signup!'));
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          }
        },
        child: const Text("Sign up"),
      ),
    );
  }

  Widget _form() {
    return SizedBox(
      height: 360,
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
                controller: _usernameController,
                validator: (String? value) {
                  if (value!.trim().isEmpty) {
                    return 'URL is required';
                  }
                },
                decoration: const InputDecoration(
                    border: OutlineInputBorder(), labelText: 'Username'),
              ),
            ),
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
                    border: OutlineInputBorder(), labelText: 'Password'),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 24),
              child: TextFormField(
                controller: _nameController,
                validator: (String? value) {
                  if (value!.trim().isEmpty) {
                    return 'URL is required';
                  }
                },
                decoration: const InputDecoration(
                    border: OutlineInputBorder(), labelText: 'Name'),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 24),
              child: TextFormField(
                controller: _emailController,
                validator: (String? value) {
                  if (value!.trim().isEmpty) {
                    return 'URL is required';
                  }
                },
                decoration: const InputDecoration(
                    border: OutlineInputBorder(), labelText: 'Email address'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
