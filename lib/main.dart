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
