import 'dart:ui';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ccandl_media/widgets/edit_profile_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

const Color darkBackground = Color(0xFF1C1C1E);
const Color lightGray = Color(0xFFB0B0B3);

class _SettingsPageState extends State<SettingsPage> {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  bool newsNotification = true;
  bool accountingNotification = true;
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

  _saveDarkMode(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('darkMode', value);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      theme: darkMode ? ThemeData.dark() : ThemeData.light(),
      home: Scaffold(
        backgroundColor: darkMode ? darkBackground : Colors.grey[100],
        appBar: AppBar(
          title: const Text(
            'Settings',
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
        body: Container(
          padding: const EdgeInsets.only(left: 16, top: 16),
          child: ListView(
            children: [
              const SizedBox(
                height: 20,
              ),
              const Row(
                children: [
                  Icon(
                    Icons.person,
                    color: Colors.green,
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Text(
                    "Account",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  )
                ],
              ),
              const Divider(
                height: 15,
                thickness: 2,
              ),
              const SizedBox(
                height: 10,
              ),
              Padding(
                  padding: const EdgeInsets.only(bottom: 15.0),
                  child: buildAccountOptionRow(context, "Change Password",
                      route: MaterialPageRoute(
                          builder: (context) => const EditProfilePage()))),
              Padding(
                  padding: const EdgeInsets.only(bottom: 15.0),
                  child: buildAccountOptionRow(context, "Account Settings",
                      route: MaterialPageRoute(
                          builder: (context) => const EditProfilePage()))),
              Padding(
                  padding: const EdgeInsets.only(bottom: 15.0),
                  child: buildAccountOptionRow(context, "Language",
                      route: MaterialPageRoute(
                          builder: (context) => const EditProfilePage()))),
              Padding(
                  padding: const EdgeInsets.only(bottom: 15.0),
                  child: buildAccountOptionRow(context, "Privacy and security",
                      route: MaterialPageRoute(
                          builder: (context) => const EditProfilePage()))),
              const SizedBox(
                height: 20,
              ),
              const Row(
                children: [
                  Icon(
                    Icons.volume_up_outlined,
                    color: Colors.green,
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Text(
                    "Notifications",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  )
                ],
              ),
              const Divider(
                height: 15,
                thickness: 2,
              ),
              const SizedBox(
                height: 10,
              ),
              Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10.0),
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10.0),
                          child: buildNotificationOptionRow(
                            "News notification",
                            newsNotification,
                            (bool newValue) {
                              setState(() {
                                newsNotification = newValue;
                              });
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10.0),
                          child: buildNotificationOptionRow(
                            "Accounting",
                            accountingNotification,
                            (bool newValue) {
                              setState(() {
                                accountingNotification = newValue;
                              });
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10.0),
                          child: buildNotificationOptionRowisDarkMode(
                            darkMode,
                            (bool newValue) {
                              setState(() {
                                darkMode = newValue;
                              });
                            },
                            darkMode,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 25,
              ),
              Center(
                child: OutlinedButton(
                  onPressed: () {
                    _logout(context);
                  },
                  style: OutlinedButton.styleFrom(
                    backgroundColor: Colors.red[600],
                    side: BorderSide(
                      color: Colors.red[600]!,
                      width: 2.0,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  child: const Text(
                    "LOGOUT",
                    style: TextStyle(
                      fontSize: 14,
                      letterSpacing: 2.2,
                      color: Colors.white,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _logout(BuildContext context) async {
    // SharedPreferences-Instanz abrufen und alle Daten löschen
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    // Zur Login-Seite Navigieren
    Navigator.pushReplacementNamed(context, '/login');
  }

  Widget buildNotificationOptionRow(
      String title, bool isActive, ValueChanged<bool> onChanged) {
    return ListTile(
      title: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w500,
          color: Colors.grey[600],
        ),
      ),
      trailing: CupertinoSwitch(
        value: isActive,
        onChanged: onChanged,
        activeColor: Colors.green,
      ),
    );
  }

  Widget buildNotificationOptionRowisDarkMode(
      bool isActive, ValueChanged<bool> onChanged, bool isDarkMode) {
    return ListTile(
      title: darkMode
          ? Text(
              'Dark Mode',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.grey[400],
              ),
            )
          : Text(
              'White Mode',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.grey[600],
              ),
            ),
      trailing: CupertinoSwitch(
        value: isActive,
        onChanged: (value) {
          setState(() {
            darkMode = value;
          });
          _saveDarkMode(value);
        },
        activeColor: const Color(0xFF17203A),
      ),
    );
  }

  InkWell buildAccountOptionRow(BuildContext context, String title,
      {PageRoute? route}) {
    return InkWell(
      onTap: () {
        if (route != null) {
          navigatorKey.currentState?.push(route);
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: .0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.grey[600],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              color: Colors.grey,
            )
          ],
        ),
      ),
    );
  }
}
