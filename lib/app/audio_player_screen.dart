import 'dart:ui';

import 'package:align_player/app/widgets/audio_visualizer.dart';
import 'package:align_player/logic/bloc/audio_player/audio_player_bloc.dart';
import 'package:align_player/logic/bloc/audio_player/audio_player_event.dart';
import 'package:align_player/logic/bloc/audio_player/audio_player_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AudioPlayerScreen extends StatelessWidget {
  const AudioPlayerScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Full screen album art
          Image.asset(
            'assets/background.png',
            fit: BoxFit.cover,
            height: double.infinity,
            width: double.infinity,
          ),
          // Bottom blur card
          Align(
            alignment: Alignment.bottomCenter,
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(40),
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 100.0, sigmaY: 100.0),
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.42,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(30),
                    ),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        const Color.fromARGB(255, 47, 47, 47).withOpacity(0.4),
                        Colors.grey.withOpacity(0.5),
                        Colors.white.withOpacity(0.6),
                      ],
                    ),
                  ),
                  child: BlocBuilder<AudioPlayerBloc, AudioPlayerState>(
                    builder: (context, state) {
                      return Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const SizedBox(height: 20),
                            _buildSongInfo(),
                            const SizedBox(height: 62),
                            _buildAudioVisualizer(context, state),
                            const SizedBox(height: 15),
                            _buildDuration(state),
                            const SizedBox(height: 15),
                            _buildControls(context, state),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSongInfo() {
    return Container(
      width: double.maxFinite,
      padding: const EdgeInsets.only(left: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Instant Crush',
            style: TextStyle(
              color: Colors.white,
              fontSize: 34,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'feat. Julian Casablancas',
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAudioVisualizer(BuildContext context, AudioPlayerState state) {
    return SizedBox(
      height: 60,
      child: AudioVisualizer(
        isPlaying: state is AudioPlayerReady && state.isPlaying,
        audioPlayer: context.read<AudioPlayerBloc>().audioPlayer,
        audioUrl: context.read<AudioPlayerBloc>().audioUrl,
      ),
    );
  }

  Widget _buildDuration(AudioPlayerState state) {
    if (state is AudioPlayerReady) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            _formatDuration(state.position),
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
              fontSize: 14,
            ),
          ),
          // Text(
          //   _formatDuration(state.duration),
          //   style: TextStyle(
          //     color: Colors.white.withOpacity(0.7),
          //     fontSize: 14,
          //   ),
          // ),
        ],
      );
    }
    return const SizedBox.shrink();
  }

  Widget _buildControls(BuildContext context, AudioPlayerState state) {
    return Container(
      width: 64,
      height: 64,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color:
            const Color(0xFFEDEDED).withOpacity(0.80), // Updated opacity to 50%
        boxShadow: [
          BoxShadow(
            color:
                Colors.black.withOpacity(0.15), // Updated shadow opacity to 15%
            offset: const Offset(0, 10), // Added Y offset of 10
            blurRadius: 25, // Updated blur radius to 25
            spreadRadius: 0, // Updated spread radius to 0
          ),
        ],
      ),
      child: IconButton(
        icon: Icon(
          state is AudioPlayerReady && state.isPlaying
              ? Icons.pause
              : Icons.play_arrow,
          size: 32,
          color: const Color(0xFF525353),
        ),
        onPressed: () {
          if (state is AudioPlayerReady) {
            if (state.isPlaying) {
              context.read<AudioPlayerBloc>().add(PauseAudioEvent());
            } else {
              context.read<AudioPlayerBloc>().add(PlayAudioEvent());
            }
          }
        },
      ),
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }
}
