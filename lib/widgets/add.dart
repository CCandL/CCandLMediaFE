import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Add extends StatefulWidget {
  const Add({super.key});

  @override
  State<Add> createState() => _AddState();
}

class _AddState extends State<Add> {
  Color darkBackground = const Color(0xFF1C1C1E);
  bool darkmode = false;

  @override
  void initState() {
    super.initState();
    _loadDarkMode();
  }

  _loadDarkMode() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      darkmode = prefs.getBool('darkMode') ?? false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: darkmode ? darkBackground : Colors.grey[100],
      body: const Center(
        child: Text(
          'Add',
          style: TextStyle(
            fontSize: 24,
          ),
        ),
      ),
    );
  }
}
