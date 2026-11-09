# Persistent Notes App Journal

## Phase 1: Theme Settings with SharedPreferences

In this phase, I added the SharedPreferences package and created a Dark Mode switch for my Flutter application.

I learned how to save user preferences so they remain available even after closing and reopening the app.

The `??` operator provides a default value when no saved preference exists. In my program, it uses `false` so Dark Mode is turned off by default.

Without the `?? false`, the program would have a type error because `getBool()` returns a nullable boolean, which cannot be directly assigned to a non-nullable `bool`.

Overall, this phase helped me understand how Flutter saves settings and restores them when the application starts.

