import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController usernameController;
  late TextEditingController passwordController;
  late TextEditingController emailController;
  late TextEditingController firstNameController;
  late TextEditingController lastNameController;

  @override
  void initState() {
    super.initState();
    usernameController = TextEditingController();
    passwordController = TextEditingController();
    emailController = TextEditingController();
    firstNameController = TextEditingController();
    lastNameController = TextEditingController();
  }

  String _email = '';
  String _password = '';
  String _firstName = '';
  String _lastName = '';
  String _username = '';
  bool _agreeToTerms = false;
  bool hidePassword = true;

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      if (_agreeToTerms) {
        _formKey.currentState!.save();

        print('E-Mail: $_email');
        print('Passwort: $_password');
        print('First Name: $_firstName');
        print('Last Name: $_lastName');
        print('Username: $_username');
        _registerUser();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Bitte stimmen Sie den Nutzungsbedingungen zu'),
          ),
        );
      }
    }
  }

  void _registerUser() async {
    var headers = {'Content-Type': 'application/json'};
    var request = http.Request(
        'POST', Uri.parse('http://localhost/app/api/v1/obj/users/0/register'));
    request.body = json.encode({
      "first_name": _firstName,
      "last_name": _lastName,
      "email": _email,
      "username": _username,
      "password": _password,
      "rank": "user",
      "darkmode": "1"
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
    } else {
      print(response.reasonPhrase);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text(
          'Register',
          style: TextStyle(
            fontFamily: 'Roboto',
            decoration: TextDecoration.none,
          ),
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 1,
        leading: null,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16.0),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 5,
                blurRadius: 7,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  const SizedBox(height: 7.5),
                  buildTextField('Username', usernameController, false,
                      (value) => _username = value!),
                  const SizedBox(height: 7.5),
                  buildTextField('Password', passwordController, true,
                      (value) => _password = value!),
                  const SizedBox(height: 7.5),
                  buildTextField('E-Mail', emailController, false,
                      (value) => _email = value!),
                  const SizedBox(height: 7.5),
                  buildTextField('First name', firstNameController, false,
                      (value) => _firstName = value!),
                  const SizedBox(height: 7.5),
                  buildTextField('Last name', lastNameController, false,
                      (value) => _lastName = value!),
                  const SizedBox(height: 7.5),
                  Row(
                    children: [
                      Checkbox(
                        value: _agreeToTerms,
                        onChanged: (bool? value) {
                          setState(() {
                            _agreeToTerms = value!;
                          });
                        },
                      ),
                      Text('Accept all terms and conditions'),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 10.0), // Updated padding value
                    child: OutlinedButton(
                      onPressed: _submitForm,
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size(125, 45),
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
                        "Register",
                        style: TextStyle(
                          fontSize: 20,
                          letterSpacing: 2.2,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildTextField(String labelText, TextEditingController controller,
      bool isPasswordTextField, void Function(String) onSave) {
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
          onChanged: onSave,
        ),
      ),
    );
  }
}
