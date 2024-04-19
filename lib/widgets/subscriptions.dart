import 'package:ccandl_media/main.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Subscriptions extends StatefulWidget {
  const Subscriptions({super.key});

  @override
  State<Subscriptions> createState() => _SubscriptionsState();
}

class _SubscriptionsState extends State<Subscriptions> {
  Color darkBackground = const Color(0xFF1C1C1E);

  @override
  void initState() {
    super.initState();
    _loadDarkMode();
  }

  bool darkMode = false;

  _loadDarkMode() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      darkMode = prefs.getBool('darkMode') ?? false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Subscriptions',
          style: TextStyle(
            fontFamily: 'Roboto',
            decoration: TextDecoration.none,
          ),
        ),
        centerTitle: true,
        backgroundColor: darkMode ? darkBackground : Colors.grey[100],
        elevation: 1,
        leading: null,
      ),
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
