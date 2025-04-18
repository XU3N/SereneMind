import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import '../../data/constants/audio_tracks.dart';
import '../../data/models/audio_track.dart';

class AudioPlayerService extends ChangeNotifier {
  final AudioPlayer _musicPlayer = AudioPlayer();
  final AudioPlayer _instructionPlayer = AudioPlayer();

  bool _isMusicEnabled = true;
  bool _isInstructionEnabled = true;
  bool _shuffleEnabled = true;
  bool _lowerThirdPartyMusic = false;
  double _musicVolume = 0.7;
  double _instructionVolume = 0.8;
  String? _selectedTrackId;

  AudioPlayerService() {
    _initPlayers();
  }

  // Initialize players
  Future<void> _initPlayers() async {
    // Set initial volumes
    await _musicPlayer.setVolume(_musicVolume);
    await _instructionPlayer.setVolume(_instructionVolume);

    // Initialize with a default track if shuffle is disabled and a track is selected
    if (!_shuffleEnabled && _selectedTrackId != null) {
      final track = AudioTracks.getTrackById(_selectedTrackId!);
      if (track != null) {
        await _loadTrack(track);
      }
    }
  }

  // Load a specific track
  Future<void> _loadTrack(AudioTrack track) async {
    try {
      await _musicPlayer.setAsset(track.assetPath);
    } catch (e) {
      debugPrint('Error loading track: $e');
    }
  }

  // Play background music
  Future<void> playMusic() async {
    if (!_isMusicEnabled) return;

    try {
      if (_shuffleEnabled) {
        // Load a random track
        final allUnlockedTracks =
            AudioTracks.tracks.where((t) => !t.isLocked).toList();
        if (allUnlockedTracks.isNotEmpty) {
          allUnlockedTracks.shuffle();
          await _loadTrack(allUnlockedTracks.first);
        }
      } else if (_selectedTrackId != null) {
        // Load the selected track
        final track = AudioTracks.getTrackById(_selectedTrackId!);
        if (track != null) {
          await _loadTrack(track);
        }
      }

      // Set looping and play
      await _musicPlayer.setLoopMode(LoopMode.one);
      await _musicPlayer.play();
    } catch (e) {
      debugPrint('Error playing music: $e');
    }
  }

  // Play instruction audio
  Future<void> playInstruction(String assetPath) async {
    if (!_isInstructionEnabled) return;

    try {
      await _instructionPlayer.setAsset(assetPath);

      // If music is playing and lower third party music is enabled,
      // temporarily reduce music volume
      if (_isMusicEnabled && _musicPlayer.playing && _lowerThirdPartyMusic) {
        final originalVolume = _musicPlayer.volume;
        await _musicPlayer.setVolume(originalVolume * 0.3);

        // Listen for instruction completion to restore volume
        _instructionPlayer.playerStateStream.listen((state) {
          if (state.processingState == ProcessingState.completed) {
            _musicPlayer.setVolume(originalVolume);
          }
        });
      }

      await _instructionPlayer.play();
    } catch (e) {
      debugPrint('Error playing instruction: $e');
    }
  }

  // Stop all audio
  Future<void> stopAll() async {
    await _musicPlayer.stop();
    await _instructionPlayer.stop();
  }

  // Pause all audio
  Future<void> pauseAll() async {
    await _musicPlayer.pause();
    await _instructionPlayer.pause();
  }

  // Resume all audio
  Future<void> resumeAll() async {
    if (_isMusicEnabled) {
      await _musicPlayer.play();
    }
    if (_isInstructionEnabled && !_instructionPlayer.playerState.playing) {
      await _instructionPlayer.play();
    }
  }

  // Getters and setters
  bool get isMusicEnabled => _isMusicEnabled;
  set isMusicEnabled(bool value) {
    _isMusicEnabled = value;
    if (!value) {
      _musicPlayer.pause();
    } else {
      playMusic();
    }
    notifyListeners();
  }

  bool get isInstructionEnabled => _isInstructionEnabled;
  set isInstructionEnabled(bool value) {
    _isInstructionEnabled = value;
    if (!value) {
      _instructionPlayer.pause();
    }
    notifyListeners();
  }

  bool get shuffleEnabled => _shuffleEnabled;
  set shuffleEnabled(bool value) {
    _shuffleEnabled = value;
    // If shuffle is enabled, clear selected track
    if (value) {
      _selectedTrackId = null;
    }
    notifyListeners();
  }

  bool get lowerThirdPartyMusic => _lowerThirdPartyMusic;
  set lowerThirdPartyMusic(bool value) {
    _lowerThirdPartyMusic = value;
    notifyListeners();
  }

  double get musicVolume => _musicVolume;
  Future<void> setMusicVolume(double value) async {
    _musicVolume = value;
    await _musicPlayer.setVolume(value);
    notifyListeners();
  }

  double get instructionVolume => _instructionVolume;
  Future<void> setInstructionVolume(double value) async {
    _instructionVolume = value;
    await _instructionPlayer.setVolume(value);
    notifyListeners();
  }

  String? get selectedTrackId => _selectedTrackId;
  set selectedTrackId(String? value) {
    _selectedTrackId = value;
    if (value != null) {
      final track = AudioTracks.getTrackById(value);
      if (track != null) {
        _loadTrack(track);
        if (_isMusicEnabled) {
          _musicPlayer.play();
        }
      }
    }
    notifyListeners();
  }

  @override
  void dispose() {
    _musicPlayer.dispose();
    _instructionPlayer.dispose();
    super.dispose();
  }
}
