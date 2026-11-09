
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
  String _savedNote = '';

  @override
  void initState() {
    super.initState();
    _loadThemePreference();
    _loadSavedNote();
  }

  // Load saved Dark Mode preference
  Future<void> _loadThemePreference() async {
    final prefs = await SharedPreferences.getInstance();

    if (!mounted) return;

    setState(() {
      _isDarkMode = prefs.getBool('isDarkMode') ?? false;
    });
  }

  // Save Dark Mode preference
  Future<void> _updateTheme(bool newValue) async {
    setState(() {
      _isDarkMode = newValue;
    });

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', newValue);
  }

  // Phase 3: Load saved note when app starts
  Future<void> _loadSavedNote() async {
    final note = await _storage.readNote();

    if (!mounted) return;

    setState(() {
      _savedNote = note;
      _noteController.text = note;

      _statusMessage = note.isEmpty
          ? 'No notes saved yet.'
          : 'Saved note restored!';
    });
  }

  // Save note and update screen
  Future<void> _saveNote() async {
    try {
      final text = _noteController.text;

      await _storage.writeNote(text);

      if (!mounted) return;

      setState(() {
        _savedNote = text;
        _statusMessage = 'Note saved to disk!';
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _statusMessage = 'Error saving note: $e';
      });
    }
  }

  // Print saved file to console
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
      theme: _isDarkMode
          ? ThemeData.dark()
          : ThemeData.light(),
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

              const SizedBox(height: 25),

              // Phase 3: Display saved note
              const Text(
                'Saved Note:',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    _savedNote.isEmpty
                        ? 'No notes saved yet.'
                        : _savedNote,
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
