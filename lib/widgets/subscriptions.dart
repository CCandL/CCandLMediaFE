import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Subscriptions extends StatefulWidget {
  const Subscriptions({super.key});

  @override
  State<Subscriptions> createState() => _SubscriptionsState();
}

class _SubscriptionsState extends State<Subscriptions> {
  Color darkBackground = Color(0xFF1C1C1E);
  bool darkMode = false;

  @override
  void initState() {
    super.initState();
    _loadDarkMode();
  }

  _loadDarkMode() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      darkMode = prefs.getBool('darkMode') ?? false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: darkMode ? darkBackground : Colors.grey[100],
      body: const Center(
        child: Text(
          'Subscriptions',
          style: TextStyle(
            fontSize: 24,
          ),
        ),
      ),
    );
  }
}
