# MyProgram – Project File Generator

This tool was written specifically for **our company's project** to speed up development.  
It automatically generates **BLoC, Repository, and DataSource** files with proper folder structure and naming conventions.

---

## 🚀 Features
- Generate all necessary files (Bloc, Repository, DataSource) with a single command.
- Automatically creates folders if they don’t exist.
- Provides boilerplate code with correct `part` imports.
- Easy to install and run as a CLI command.

---

## 📂 Project Structure

When you run:

```bash
tmgen Profile

lib/
  features/
    profile/
      bloc/
        profile_bloc.dart
        profile_event.dart
        profile_state.dart
      repository/
        profile_repository.dart
      datasource/
        profile_datasource.dart

