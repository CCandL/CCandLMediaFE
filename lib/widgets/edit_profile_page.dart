import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  bool hidePassword = true;
  Color darkBackground = Color(0xFF1C1C1E);
  Color lightGray = Color(0xFFB0B0B3);
  bool darkMode = false;
  final ImagePicker _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    bool darkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: darkMode ? Colors.grey[850] : Colors.grey[100],
      appBar: AppBar(
        title: const Text(
          'Edit Profile',
          style: TextStyle(
            fontFamily: 'Roboto',
            decoration: TextDecoration.none,
            // color: darkMode ? Colors.white : Colors.black,
          ),
        ),
        centerTitle: true,
        backgroundColor: darkMode ? Colors.grey[900] : Colors.white,
        elevation: 1,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Color.fromARGB(255, 226, 106, 152),
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Container(
        padding: const EdgeInsets.only(left: 16, top: 20, right: 16),
        child: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProfilePictureZoom(
                  imagePath: 'lib/assets/img/google.png',
                ),
              ),
            );
          },
          child: ListView(
            children: [
              const SizedBox(
                height: 10,
              ),
              Center(
                child: Stack(
                  children: [
                    Container(
                      width: 130,
                      height: 130,
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 4,
                          color: darkMode ? Colors.white : Colors.grey[200]!,
                        ),
                        boxShadow: [
                          BoxShadow(
                            spreadRadius: 2,
                            blurRadius: 10,
                            color: Colors.black.withOpacity(0.1),
                            offset: const Offset(1, 10),
                          ),
                        ],
                        shape: BoxShape.circle,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Container(
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage('lib/assets/img/google.png'),
                              fit: BoxFit.contain,
                            ),
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: () async {
                          final PermissionStatus cameraPermissionStatus =
                              await Permission.camera.request();
                          final PermissionStatus galleryPermissionStatus =
                              await Permission.photos.request();

                          if (cameraPermissionStatus.isGranted &&
                              galleryPermissionStatus.isGranted) {
                            showModalBottomSheet(
                              context: context,
                              builder: (BuildContext context) {
                                return SafeArea(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      ListTile(
                                        leading: Icon(Icons.photo_library),
                                        title: Text('Foto auswählen',
                                            style: TextStyle(
                                              color: darkMode
                                                  ? Colors.white
                                                  : Colors.black,
                                            )),
                                        onTap: () async {
                                          Navigator.pop(context);
                                          final XFile? image =
                                              await _picker.pickImage(
                                                  source: ImageSource.gallery);
                                          if (image != null) {
                                            // Hier kannst du den Code hinzufügen, um das ausgewählte Bild zu speichern oder anzuzeigen
                                          }
                                        },
                                      ),
                                      ListTile(
                                        leading: Icon(Icons.camera_alt),
                                        title: Text('Kamera öffnen',
                                            style: TextStyle(
                                              color: darkMode
                                                  ? Colors.white
                                                  : Colors.black,
                                            )),
                                        onTap: () async {
                                          Navigator.pop(context);
                                          final XFile? image =
                                              await _picker.pickImage(
                                                  source: ImageSource.camera);
                                          if (image != null) {
                                            // Hier kannst du den Code hinzufügen, um das aufgenommene Bild zu speichern oder anzuzeigen
                                          }
                                        },
                                      ),
                                    ],
                                  ),
                                );
                              },
                            );
                          } else {
                            // Hier kannst du den Code hinzufügen, um den Benutzer über die fehlenden Berechtigungen zu informieren
                          }
                        },
                        child: Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              width: 4,
                              color:
                                  darkMode ? Colors.white : Colors.grey[200]!,
                            ),
                            color: Colors.pink,
                          ),
                          child: const Icon(
                            Icons.edit,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              buildTextField("Username", "_Max_", false, darkMode),
              buildTextField("First name", "Max", false, darkMode),
              buildTextField("Last name", "Mustermann", false, darkMode),
              buildTextField("E-mail", "max@mustermann.de", false, darkMode),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  OutlinedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
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
                      "CANCEL",
                      style: TextStyle(
                        fontSize: 14,
                        letterSpacing: 2.2,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  OutlinedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    style: OutlinedButton.styleFrom(
                      backgroundColor: Colors.green[600],
                      side: BorderSide(
                        color: Colors.green[600]!,
                        width: 2.0,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    child: const Text(
                      "SAVE",
                      style: TextStyle(
                        fontSize: 14,
                        letterSpacing: 2.2,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTextField(String labelText, String initialText,
      bool isPasswordTextField, bool darkMode) {
    TextEditingController controller = TextEditingController(text: initialText);

    return Padding(
      padding: const EdgeInsets.only(bottom: 35.0),
      child: TextField(
        controller: controller,
        obscureText: isPasswordTextField ? hidePassword : false,
        style: TextStyle(color: darkMode ? Colors.white : Colors.black),
        decoration: InputDecoration(
          suffixIcon: isPasswordTextField
              ? IconButton(
                  onPressed: () {
                    setState(() {
                      hidePassword = !hidePassword;
                    });
                  },
                  icon: hidePassword
                      ? const Icon(
                          CupertinoIcons.eye_slash_fill,
                          color: Colors.red,
                        )
                      : const Icon(
                          CupertinoIcons.eye_fill,
                          color: Colors.green,
                        ),
                )
              : null,
          contentPadding: const EdgeInsets.only(bottom: 3),
          labelText: labelText,
          floatingLabelBehavior: FloatingLabelBehavior.always,
          hintStyle: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: darkMode ? Colors.white : Colors.black),
        ),
      ),
    );
  }
}

class ProfilePictureZoom extends StatelessWidget {
  final String imagePath;

  ProfilePictureZoom({required this.imagePath});

  @override
  Widget build(BuildContext context) {
    bool darkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0.7),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.close,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 200, maxHeight: 200),
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(imagePath),
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }
}
