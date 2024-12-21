abstract class AudioPlayerEvent {}

class InitializeAudioEvent extends AudioPlayerEvent {}

class PlayAudioEvent extends AudioPlayerEvent {}

class PauseAudioEvent extends AudioPlayerEvent {}

class UpdateProgressEvent extends AudioPlayerEvent {
  final Duration position;
  UpdateProgressEvent(this.position);
}
