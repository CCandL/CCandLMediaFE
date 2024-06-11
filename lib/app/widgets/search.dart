import 'package:anim_search_bar/anim_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  bool darkMode = false;
  Color darkBackground = const Color(0xFF1C1C1E);
  Color darkContainerBg = Colors.grey[800]!;
  TextEditingController textController = TextEditingController();

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

  _onSubmitted(String value) {
    // Hier können Sie den eingereichten Suchwert verwenden
    print('Suche eingereicht: $value');
    // Zum Beispiel: Sie könnten eine API-Anfrage starten oder die Suchergebnisse aktualisieren
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: darkMode ? darkBackground : Colors.grey[100],
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: darkMode ? darkBackground : Colors.grey[100],
        elevation: 1,
        leading: null,
        actions: [
          Container(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(300),
              child: SizedBox(
                width: 550,
                child: AnimSearchBar(
                  width: 400,
                  textController: textController,
                  onSuffixTap: () {
                    setState(() {
                      textController.clear();
                    });
                  },
                  onSubmitted: _onSubmitted,
                  helpText: "Search Text...",
                  autoFocus: true,
                  closeSearchOnSuffixTap: true,
                  animationDurationInMilli: 1000,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Container(),
    );
  }
}
