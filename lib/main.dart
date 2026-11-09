
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'note_storage.dart';

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

  final TextEditingController _noteController =
  TextEditingController();

  final NoteStorage _storage = NoteStorage();

  String _statusMessage = 'No note saved yet.';

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

  Future<void> _saveNote() async {
    try {
      await _storage.writeNote(_noteController.text);

      if (!mounted) return;

      setState(() {
        _statusMessage = 'Note saved to disk!';
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _statusMessage = 'Error saving note: $e';
      });
    }
  }

  Future<void> _printNote() async {
    try {
      final content = await _storage.readRawContent();

      debugPrint('=== SAVED NOTE ===');
      debugPrint(content);
      debugPrint('==================');

      if (!mounted) return;

      setState(() {
        _statusMessage = 'Note printed to console!';
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _statusMessage = 'Error reading note: $e';
      });
    }
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
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
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Icon(
                Icons.note_alt,
                size: 70,
              ),

              const SizedBox(height: 20),

              const Text(
                'My Persistent Notes',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
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

              const SizedBox(height: 20),

              TextField(
                controller: _noteController,
                maxLines: 5,
                decoration: const InputDecoration(
                  labelText: 'Your Note',
                  hintText: 'Type your notes here...',
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 20),

              ElevatedButton(
                onPressed: _saveNote,
                child: const Text('Save Note'),
              ),

              const SizedBox(height: 10),

              OutlinedButton(
                onPressed: _printNote,
                child: const Text('Print File to Console'),
              ),

              const SizedBox(height: 20),

              Text(
                _statusMessage,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
