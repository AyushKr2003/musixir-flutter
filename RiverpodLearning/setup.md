# Riverpod Setup Guide

## Required Dependencies
Add these to your `pubspec.yaml`:

```yaml
dependencies:
  flutter_riverpod: ^2.6.1    # Core Riverpod package
  riverpod_annotation: ^2.6.1 # Annotations for code generation

dev_dependencies:
  riverpod_generator: ^2.6.3  # Generates provider code
  build_runner: ^2.4.13      # Runs code generation
  riverpod_lint: ^2.6.3      # Provides Riverpod-specific lints
  custom_lint: ^0.7.0        # Required for riverpod_lint
```

## Code Generation
After adding dependencies:
1. Run this command to generate code once:
   ```bash
   dart run build_runner build
   ```
2. Or run this for continuous code generation during development:
   ```bash
   dart run build_runner watch
   ```

## Setup Tips
1. Always run code generation after:
   - Adding new providers with @riverpod annotation
   - Modifying existing provider signatures
   - Pulling new code that contains provider changes

2. Common Issues:
   - If you get conflicts, run: `dart run build_runner build --delete-conflicting-outputs`
   - Make sure all dependencies are compatible versions
   - Import 'package:riverpod_annotation/riverpod_annotation.dart' in files using @riverpod

[Back to README](README.md)
