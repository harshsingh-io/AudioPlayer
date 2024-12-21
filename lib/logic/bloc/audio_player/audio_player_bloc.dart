import 'package:align_player/logic/bloc/audio_player/audio_player_event.dart';
import 'package:align_player/logic/bloc/audio_player/audio_player_state.dart';
import 'package:bloc/bloc.dart';
import 'package:just_audio/just_audio.dart';

class AudioPlayerBloc extends Bloc<AudioPlayerEvent, AudioPlayerState> {
  final AudioPlayer _audioPlayer;
  AudioPlayer get audioPlayer => _audioPlayer;
  final String audioUrl;

  AudioPlayerBloc({required this.audioUrl})
      : _audioPlayer = AudioPlayer(),
        super(AudioPlayerInitial()) {
    on<InitializeAudioEvent>(_onInitialize);
    on<PlayAudioEvent>(_onPlay);
    on<PauseAudioEvent>(_onPause);
    on<UpdateProgressEvent>(_onUpdateProgress);

    // Listen to player completion
    _audioPlayer.processingStateStream.listen((state) {
      if (state == ProcessingState.completed) {
        add(PauseAudioEvent());
        _audioPlayer.seek(Duration.zero);
      }
    });

    // Listen to player state changes
    _audioPlayer.playerStateStream.listen((playerState) {
      if (playerState.processingState == ProcessingState.completed) {
        emit(AudioPlayerReady(
          isPlaying: false,
          position: Duration.zero,
          duration: _audioPlayer.duration ?? Duration.zero,
        ));
      } else if (playerState.playing) {
        emit(AudioPlayerReady(
          isPlaying: true,
          position: _audioPlayer.position,
          duration: _audioPlayer.duration ?? Duration.zero,
        ));
      }
    });

    // Listen to position updates
    _audioPlayer.positionStream.listen((position) {
      add(UpdateProgressEvent(position));
    });
  }

  Future<void> _onInitialize(
    InitializeAudioEvent event,
    Emitter<AudioPlayerState> emit,
  ) async {
    try {
      emit(AudioPlayerLoading());
      await _audioPlayer.setUrl(audioUrl);
      emit(AudioPlayerReady(
        isPlaying: false,
        position: Duration.zero,
        duration: _audioPlayer.duration ?? Duration.zero,
      ));
    } catch (e) {
      emit(AudioPlayerError('Failed to initialize audio: $e'));
    }
  }

  Future<void> _onPlay(
    PlayAudioEvent event,
    Emitter<AudioPlayerState> emit,
  ) async {
    try {
      await _audioPlayer.play();
    } catch (e) {
      emit(AudioPlayerError('Failed to play audio: $e'));
    }
  }

  Future<void> _onPause(
    PauseAudioEvent event,
    Emitter<AudioPlayerState> emit,
  ) async {
    try {
      await _audioPlayer.pause();
      if (state is AudioPlayerReady) {
        emit(AudioPlayerReady(
          isPlaying: false,
          position: _audioPlayer.position,
          duration: _audioPlayer.duration ?? Duration.zero,
        ));
      }
    } catch (e) {
      emit(AudioPlayerError('Failed to pause audio: $e'));
    }
  }

  void _onUpdateProgress(
    UpdateProgressEvent event,
    Emitter<AudioPlayerState> emit,
  ) {
    if (state is AudioPlayerReady) {
      emit(AudioPlayerReady(
        isPlaying: _audioPlayer.playing,
        position: event.position,
        duration: _audioPlayer.duration ?? Duration.zero,
      ));
    }
  }

  @override
  Future<void> close() {
    _audioPlayer.dispose();
    return super.close();
  }
}
