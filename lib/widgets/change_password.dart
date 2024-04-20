import 'dart:convert';
import 'package:ccandl_media/main.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({Key? key}) : super(key: key);

  @override
  State<ChangePassword> createState() => _LoginState();
}

class _LoginState extends State<ChangePassword> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController controller1;
  late TextEditingController controller2;
  late TextEditingController controller3;

  String _password = '';
  String _repeatPassword = '';
  String _newPassword = '';
  bool hidePassword = true;
  bool darkMode = false;
  Color darkBackground = const Color(0xFF1C1C1E);
  Color darkContainerBg = Colors.grey[800]!;

  @override
  void initState() {
    super.initState();
    controller1 = TextEditingController();
    controller2 = TextEditingController();
    controller3 = TextEditingController();
    _loadDarkMode();
  }

  @override
  void dispose() {
    controller1.dispose();
    controller2.dispose();
    controller3.dispose();
    super.dispose();
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      // Überprüfen, ob die Passworte übereinstimmen
      if (controller2.text != controller3.text) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Die Passwörter stimmen nicht überein')),
        );
        return;
      }
    }
    // final bool success = await changePassword(controller1.text, controller3.text);

    // if (success) {
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     const SnackBar(content: Text('Passwort erfolgreich geändert')),
    //   );
    // } else {
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     const SnackBar(content: Text('Fehler beim Ändern des Passworts')),
    //   );
    // }
  }

  _loadDarkMode() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      darkMode = prefs.getBool('darkMode') ?? false;
    });
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
      backgroundColor: darkMode ? darkBackground : Colors.grey[100],
      appBar: AppBar(
        title: Text(
          'Change Password',
          style: TextStyle(
            fontFamily: 'Roboto',
            decoration: TextDecoration.none,
            color: darkMode ? Colors.white : darkBackground,
          ),
        ),
        centerTitle: true,
        backgroundColor: darkMode ? darkBackground : Colors.grey[100],
        elevation: darkMode ? 0 : 1, // Kein Schatten im Dark Mode
        leading: null,
      ),
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
                  decoration: BoxDecoration(
                    color: darkMode ? darkContainerBg : Colors.grey[100],
                    borderRadius: BorderRadius.circular(16.0),
                    boxShadow: darkMode
                        ? null
                        : [
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          'Change Password',
                          style: TextStyle(
                            color: darkMode ? Colors.white : Colors.black,
                            fontFamily: 'OpenSans',
                            fontSize: 30.0,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.start,
                        ),
                        const SizedBox(height: 10),
                        buildTextField('Password', controller1, true),
                        const SizedBox(height: 10.0),
                        buildTextField('Repeat password', controller2, true),
                        const SizedBox(height: 20.0),
                        buildTextField('New password', controller3, true),
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
                            'Submit',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
