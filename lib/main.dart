import 'package:ccandl_media/widgets/home.dart';
import 'package:ccandl_media/widgets/subscriptions.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ccandl_media/widgets/src.dart';
import 'package:ccandl_media/widgets/add.dart';
import 'package:ccandl_media/widgets/settings.dart';
import 'package:ccandl_media/widgets/register.dart';
import 'package:ccandl_media/widgets/login.dart';

void main() {
  runApp(MyApp());
}

const Color bottomNavBgColor = Color(0xFF17203A);
bool darkMode = false;
Color darkBackground = const Color(0xFF1C1C1E);
Color darkContainerBg = Colors.grey[800]!;

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
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
    return MaterialApp(
      theme: ThemeData(brightness: Brightness.light),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        appBarTheme: darkMode
            ? AppBarTheme(backgroundColor: Colors.grey[900])
            : AppBarTheme(backgroundColor: Colors.grey[100]),
      ),
      themeMode: darkMode ? ThemeMode.dark : ThemeMode.light,
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => LoginCheck(),
        '/login': (context) => Login(),
        '/settings': (context) => SettingsPage(),
        '/add': (context) => Add(),
        '/home': (context) => Home(),
        '/register': (context) => Register(),
      },
    );
  }
}

class LoginCheck extends StatefulWidget {
  @override
  _LoginCheckState createState() => _LoginCheckState();
}

class _LoginCheckState extends State<LoginCheck> {
  bool isLoggedIn = false; // Set to false by default

  @override
  void initState() {
    super.initState();
    checkLoginStatus();
  }

  void checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? sessionToken = prefs.getString('session_token');

    if (sessionToken != null && sessionToken.isNotEmpty) {
      setState(() {
        isLoggedIn = true;
      });
    } else {
      setState(() {
        isLoggedIn = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return isLoggedIn ? Home() : const Login();
  }
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 1;
  final PageController _pageController = PageController(initialPage: 1);

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOutQuart,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        children: const <Widget>[
          HomeContent(),
          Add(),
          Subscriptions(),
          SettingsPage()
        ],
      ),
      bottomNavigationBar: Container(
        padding:
            const EdgeInsets.fromLTRB(24, 12, 24, 12), // Reduziert das Padding
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(24)),
          boxShadow: [
            BoxShadow(
              color: bottomNavBgColor.withOpacity(0.3),
              offset: const Offset(0, 20),
              blurRadius: 20,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            currentIndex: _selectedIndex,
            onTap: _onItemTapped,
            backgroundColor: bottomNavBgColor,
            selectedItemColor: Colors.amber[800],
            unselectedItemColor: Colors.white,
            iconSize: 28,
            selectedFontSize: 12,
            unselectedFontSize: 12,
            selectedLabelStyle: const TextStyle(height: 0.8),
            unselectedLabelStyle: const TextStyle(height: 0.8),
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.add),
                label: 'Add',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.subscriptions),
                label: 'Subscriptions',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.settings),
                label: 'Settings',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
