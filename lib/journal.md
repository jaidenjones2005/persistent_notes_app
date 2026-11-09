# Persistent Notes App Journal

## Phase 1: Theme Settings with SharedPreferences

In this phase, I added the SharedPreferences package and created a Dark Mode switch for my Flutter application.

I learned how to save user preferences so they remain available even after closing and reopening the app.

The `??` operator provides a default value when no saved preference exists. In my program, it uses `false` so Dark Mode is turned off by default.

Without the `?? false`, the program would have a type error because `getBool()` returns a nullable boolean, which cannot be directly assigned to a non-nullable `bool`.

Overall, this phase helped me understand how Flutter saves settings and restores them when the application starts.

## Phase 2: Note File Storage & Console Inspection

In this phase, I added the path_provider package and created a NoteStorage class to handle saving and reading notes.

I learned how to use dart:io to write text to a file and read the saved contents.

Testing file storage through the console is helpful because it allows me to verify that the data is actually being saved before adding more UI features.

Separating the file operations into the NoteStorage class also keeps my main.dart organized and makes the code easier to maintain.

This phase helped me understand how Flutter can store data locally on a device.

## Phase 3: Restoring & Displaying Notes in the UI

In this phase, I updated the NoteStorage class to safely read saved notes using a try/catch block.

I learned that attempting to read a file that does not exist causes a FileSystemException. The try/catch block prevents the app from crashing by returning an empty string instead.

I also updated the app to automatically load saved notes when it starts and display them inside a Card widget.

When a user saves a new note, both the file and the displayed note are updated.

This phase helped me understand how to restore persistent data and handle file errors safely in Flutter.

