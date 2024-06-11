import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController controller1;
  late TextEditingController controller2;

  String _email = '';
  String _password = '';
  bool hidePassword = true;

  @override
  void initState() {
    super.initState();
    controller1 = TextEditingController();
    controller2 = TextEditingController();
  }

  @override
  void dispose() {
    controller1.dispose();
    controller2.dispose();
    super.dispose();
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      if (controller1.text.isNotEmpty && controller2.text.isNotEmpty) {
        _email = controller1.text;
        _password = controller2.text;

        var headers = {'Content-Type': 'application/json'};
        var request = http.Request(
          'POST',
          Uri.parse('http://localhost/app/api/v1/obj/users/0/login'),
        );
        request.body = json.encode({"username": _email, "password": _password});
        request.headers.addAll(headers);

        try {
          http.StreamedResponse response = await request.send();

          if (response.statusCode == 200) {
            String responseBody = await response.stream.bytesToString();
            Map<String, dynamic> jsonResponse = json.decode(responseBody);

            String? sessionToken = jsonResponse['data']['session_token'];

            if (sessionToken != null) {
              saveSessionToken(sessionToken);
              Navigator.pushReplacementNamed(context, '/');
            } else {
              print('Session token not found in response');
            }
          } else {
            print(response.reasonPhrase);
          }
        } catch (e) {
          print('Error: $e');
        }
      } else {
        print('Username or password cannot be empty');
      }
    }
  }

  void saveSessionToken(String sessionToken) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('session_token', sessionToken);
  }

  Widget buildTextField(String labelText, TextEditingController controller,
      bool isPasswordTextField) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: 650.0,
        ),
        child: TextField(
          controller: controller,
          obscureText: isPasswordTextField && hidePassword,
          style: const TextStyle(
            fontSize: 14.0,
          ),
          decoration: InputDecoration(
            contentPadding:
                const EdgeInsets.symmetric(vertical: 15.0, horizontal: 15.0),
            suffixIcon: isPasswordTextField
                ? IconButton(
                    onPressed: () {
                      setState(() {
                        hidePassword = !hidePassword;
                      });
                    },
                    icon: hidePassword
                        ? const Icon(
                            Icons.visibility_off,
                            color: Colors.red,
                          )
                        : const Icon(
                            Icons.visibility,
                            color: Colors.green,
                          ),
                  )
                : null,
            labelText: labelText,
            floatingLabelBehavior: FloatingLabelBehavior.always,
            hintStyle: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: null,
      body: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Form(
          key: _formKey,
          child: Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  height: 150.0,
                  width: 150.0,
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Image.asset('lib/assets/img/ccl_Logo_colored.png'),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.circular(16.0), // Abrunden des Containers
                    boxShadow: [
                      BoxShadow(
                        color:
                            Colors.grey.withOpacity(0.5), // Farbe des Schattens
                        spreadRadius: 5, // Ausbreitung des Schattens
                        blurRadius: 7, // Unschärfe des Schattens
                        offset: Offset(0, 3), // Position des Schattens
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Text(
                          'Login',
                          style: TextStyle(
                            color: Colors.black,
                            fontFamily: 'OpenSans',
                            fontSize: 30.0,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.start,
                        ),
                        const SizedBox(height: 10),
                        buildTextField('Username', controller1, false),
                        const SizedBox(height: 10.0),
                        buildTextField('Password', controller2, true),
                        const SizedBox(height: 20.0),
                        OutlinedButton(
                          onPressed: _submitForm,
                          style: OutlinedButton.styleFrom(
                            minimumSize: const Size(130, 50),
                            backgroundColor: Colors.red[400],
                            side: BorderSide(
                              color: Colors.red[400]!,
                              width: 4.0,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16.0),
                            ),
                          ),
                          child: const Text(
                            "Login",
                            style: TextStyle(
                              fontSize: 20,
                              letterSpacing: 2.2,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        TextButton(
                          style: ButtonStyle(
                            foregroundColor:
                                MaterialStateProperty.all<Color>(Colors.black),
                          ),
                          onPressed: () {
                            Navigator.pushNamed(context, '/register');
                          },
                          child: const Text('Noch kein Konto? Registrieren'),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 15),
                const Center(
                  child: Text(
                    "- OR -",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    GestureDetector(
                      onTap: () => print('Login with Apple'),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          height: 90.0,
                          width: 90.0,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black26,
                                offset: Offset(0, 2),
                                blurRadius: 6.0,
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Image.asset('lib/assets/img/apple.png'),
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => print('Login with Google'),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          height: 90.0,
                          width: 90.0,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black26,
                                offset: Offset(0, 2),
                                blurRadius: 6.0,
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Image.asset('lib/assets/img/google.png'),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                // const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
