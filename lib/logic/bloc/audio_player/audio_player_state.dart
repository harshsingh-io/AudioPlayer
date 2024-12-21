abstract class AudioPlayerState {}

class AudioPlayerInitial extends AudioPlayerState {}

class AudioPlayerLoading extends AudioPlayerState {}

class AudioPlayerReady extends AudioPlayerState {
  final bool isPlaying;
  final Duration position;
  final Duration duration;

  AudioPlayerReady({
    required this.isPlaying,
    required this.position,
    required this.duration,
  });
}

class AudioPlayerError extends AudioPlayerState {
  final String message;
  AudioPlayerError(this.message);
}
