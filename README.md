# Align Player

A Flutter-based audio player application that provides a modern interface for playing audio files with waveform visualization.

## Features

- Audio playback controls (play, pause, seek)
- Waveform visualization of audio
- Clean and modern UI design
- Background audio playback
- Cached network audio support

## Getting Started

### Prerequisites

- Java 17
- Flutter SDK (^3.5.3)
- Dart SDK
- Android Studio / Xcode (for mobile development)

### Installation

1. Clone the repository:
```bash
git clone https://github.com/harshsingh-io/AudioPlayer.git
```

2. Navigate to the project directory:
```bash
cd AudioPlayer
```

3. Install dependencies:
```bash
flutter pub get
```

4. Run the application:
```bash
flutter run
```

## Dependencies

The project uses several key dependencies:

```yaml
dependencies:
  audio_waveforms: ^1.2.0
  cached_network_image: ^3.4.1
  fftea: ^1.5.0+1
  flutter_bloc: ^8.1.6
  http: ^1.2.2
  just_audio: ^0.9.42
  path_provider: ^2.1.5
```

## Project Structure

```
lib/
  ├── app/
  │   └── audio_player_screen.dart
  ├── logic/
  │   └── bloc/
  │       └── audio_player/
  │           ├── audio_player_bloc.dart
  │           └── audio_player_event.dart
  │           └── audio_player_state.dart
  └── main.dart
```

## Architecture

The application follows the BLoC (Business Logic Component) pattern for state management, providing a clean separation of concerns between the UI and business logic.

main.dart
```dart
import 'package:align_player/app/audio_player_screen.dart';
import 'package:align_player/logic/bloc/audio_player/audio_player_bloc.dart';
import 'package:align_player/logic/bloc/audio_player/audio_player_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MP3 Player',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.black,
      ),
      home: BlocProvider(
        create: (context) => AudioPlayerBloc(
          audioUrl:
              'https://codeskulptor-demos.commondatastorage.googleapis.com/descent/background%20music.mp3',
        )..add(InitializeAudioEvent()),
        child: const AudioPlayerScreen(),
      ),
    );
  }
}
```

pubspec.yaml

```dart
name: align_player
description: "A new Flutter project."
publish_to: 'none'
version: 0.1.0

environment:
  sdk: ^3.5.3

dependencies:
  audio_waveforms: ^1.2.0
  cached_network_image: ^3.4.1
  fftea: ^1.5.0+1
  flutter:
    sdk: flutter
  flutter_bloc: ^8.1.6
  http: ^1.2.2
  just_audio: ^0.9.42
  path_provider: ^2.1.5

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^4.0.0

flutter:
  uses-material-design: true

```

