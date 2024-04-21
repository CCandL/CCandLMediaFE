import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeContent extends StatefulWidget {
  const HomeContent({super.key});

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  bool darkMode = false;
  Color darkBackground = const Color(0xFF1C1C1E);
  Color darkContainerBg = Colors.grey[800]!;
  bool isFavorite = false;
  TextEditingController commentController = TextEditingController();
  bool hidePassword = true;

  @override
  void initState() {
    super.initState();
    _loadDarkMode();
  }

  _loadDarkMode() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? currentDarkMode = prefs.getBool('darkMode');
    if (currentDarkMode != null && currentDarkMode != darkMode) {
      setState(() {
        darkMode = currentDarkMode;
      });
    }
  }

  _showCommentBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
        ),
      ),
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.80,
        color: darkMode ? darkBackground : Colors.white,
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: 55, // Anzahl der Kommentare
                itemBuilder: (context, index) => ListTile(
                  title: Text('Comment from $index'),
                  textColor: darkMode ? Colors.white : darkBackground,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  buildTextField("Enter comment...", commentController, false),
                  IconButton(
                    icon: const Icon(Icons.send),
                    onPressed: () {
                      // Hier können Sie den Kommentar absenden
                      print('Kommentar abgesendet: ${commentController.text}');
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ),
          ],
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
          'Home',
          style: TextStyle(
            fontFamily: 'Roboto',
            decoration: TextDecoration.none,
            color: darkMode ? Colors.white : darkBackground,
          ),
        ),
        centerTitle: true,
        backgroundColor: darkMode ? darkBackground : Colors.grey[100],
        elevation: 1,
        leading: null,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 15.0),
            child: OutlinedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/search');
              },
              child: const Icon(Icons.search),
            ),
          ),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: .0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: () {
                setState(() {
                  isFavorite = !isFavorite;
                });
              },
              child: isFavorite
                  ? const Icon(
                      Icons.favorite,
                      size: 37.5,
                      color: Colors.red,
                    )
                  : const Icon(
                      Icons.favorite_border,
                      size: 37.5,
                    ),
            ),
            const SizedBox(height: 55), // Kleiner Abstand zwischen den Icons
            GestureDetector(
              onTap: () {
                _showCommentBottomSheet();
              },
              child: const Icon(
                Icons.add_comment,
                size: 37.5,
              ),
            ),
            const SizedBox(height: 55), // Kleiner Abstand zwischen den Icons
            GestureDetector(
              child: const Icon(
                Icons.save,
                size: 37.5,
              ),
            ),
            const SizedBox(height: 55), // Kleiner Abstand zwischen den Icons
            GestureDetector(
              child: const Icon(
                Icons.forward,
                size: 37.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTextField(String labelText, TextEditingController controller,
      bool isPasswordTextField) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: 570.0,
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
}
