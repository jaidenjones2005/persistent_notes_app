
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const PersistentNotesApp());
}

class PersistentNotesApp extends StatefulWidget {
  const PersistentNotesApp({super.key});

  @override
  State<PersistentNotesApp> createState() =>
      _PersistentNotesAppState();
}

class _PersistentNotesAppState extends State<PersistentNotesApp> {
  bool _isDarkMode = false;

  @override
  void initState() {
    super.initState();
    _loadThemePreference();
  }

  Future<void> _loadThemePreference() async {
    final prefs = await SharedPreferences.getInstance();

    if (!mounted) return;

    setState(() {
      _isDarkMode = prefs.getBool('isDarkMode') ?? false;
    });
  }

  Future<void> _updateTheme(bool newValue) async {
    setState(() {
      _isDarkMode = newValue;
    });

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', newValue);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Persistent Notes App',
      theme: _isDarkMode ? ThemeData.dark() : ThemeData.light(),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Persistent Notes App'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.note_alt,
                size: 80,
              ),
              const SizedBox(height: 20),
              const Text(
                'Welcome to Persistent Notes!',
                style: TextStyle(fontSize: 22),
              ),
              const SizedBox(height: 20),
              SwitchListTile(
                title: const Text('Dark Mode'),
                subtitle: const Text(
                  'Save your theme preference',
                ),
                value: _isDarkMode,
                onChanged: _updateTheme,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
