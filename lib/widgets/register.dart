import 'package:flutter/material.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _formKey = GlobalKey<FormState>();

  String _email = '';
  String _password = '';
  String _firstName = '';
  String _lastName = '';
  bool _agreeToTerms = false;
  bool hidePassword = true;

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      if (_agreeToTerms) {
        _formKey.currentState!.save();

        // Hier können Sie die eingegebenen Daten verarbeiten oder absenden
        print('E-Mail: $_email');
        print('Passwort: $_password');
        print('First Name: $_firstName');
        print('Last Name: $_lastName');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Bitte stimmen Sie den Nutzungsbedingungen zu')),
        );
      }
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
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              buildTextField('Username', TextEditingController(), false),
              const SizedBox(height: 16.0),
              buildTextField('Password', TextEditingController(), true),
              const SizedBox(height: 16.0),
              buildTextField('E-Mail', TextEditingController(), false),
              const SizedBox(height: 16.0),
              buildTextField('First name', TextEditingController(), false),
              const SizedBox(height: 16.0),
              buildTextField('Last name', TextEditingController(), false),
              const SizedBox(height: 16.0),
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
              const SizedBox(height: 16.0),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: ElevatedButton(
                  onPressed: _submitForm,
                  child: Text('Register'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget buildTextField(String labelText, TextEditingController controller,
    bool isPasswordTextField) {
  bool hidePassword = true;

  return Padding(
    padding: const EdgeInsets.only(bottom: 35.0),
    child: TextField(
      controller: controller,
      obscureText: isPasswordTextField && hidePassword,
      decoration: InputDecoration(
        suffixIcon: isPasswordTextField
            ? IconButton(
                onPressed: () {
                  // Hier sollte man den Zustand im übergeordneten Widget aktualisieren
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
        contentPadding: const EdgeInsets.only(bottom: 3),
        labelText: labelText,
        floatingLabelBehavior: FloatingLabelBehavior.always,
        hintStyle: const TextStyle(
            fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
      ),
    ),
  );
}
