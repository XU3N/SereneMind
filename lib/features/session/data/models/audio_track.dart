import 'package:just_audio/just_audio.dart';

class AudioTrack {
  final String id;
  final String title;
  final String assetPath;
  final String category;
  final bool isLocked;

  const AudioTrack({
    required this.id,
    required this.title,
    required this.assetPath,
    required this.category,
    this.isLocked = false,
  });

  // Convert to AudioSource for just_audio
  AudioSource toAudioSource() {
    return AudioSource.asset(
      assetPath,
      tag: MediaItem(
        id: id,
        title: title,
      ),
    );
  }
}

// Media item for metadata
class MediaItem {
  final String id;
  final String title;

  const MediaItem({
    required this.id,
    required this.title,
  });
}

// Audio categories
enum AudioCategory {
  ambient,
  calm,
  meditation,
}

extension AudioCategoryExtension on AudioCategory {
  String get name {
    switch (this) {
      case AudioCategory.ambient:
        return 'Ambient';
      case AudioCategory.calm:
        return 'Calm';
      case AudioCategory.meditation:
        return 'Meditation';
    }
  }
}
