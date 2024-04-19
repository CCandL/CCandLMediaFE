import 'package:ccandl_media/main.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeContent extends StatefulWidget {
  const HomeContent({super.key});

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
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
      appBar: AppBar(
        title: const Text(
          'Home',
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
      body: Center(
        child: Text(
          'Home Content',
          style: TextStyle(
            fontSize: 24,
            color: darkMode ? Colors.white : Colors.black,
          ),
        ),
      ),
    );
  }
}
