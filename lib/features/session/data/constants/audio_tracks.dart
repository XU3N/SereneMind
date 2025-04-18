import '../models/audio_track.dart';

class AudioTracks {
  // All available audio tracks
  static final List<AudioTrack> tracks = [
    // Ambient tracks
    const AudioTrack(
      id: 'ambient1',
      title: 'Ambient 1',
      assetPath: 'assets/audio/ambient/ambient1.mp3',
      category: 'Ambient',
    ),
    const AudioTrack(
      id: 'ambient2',
      title: 'Ambient 2',
      assetPath: 'assets/audio/ambient/ambient2.mp3',
      category: 'Ambient',
    ),
    const AudioTrack(
      id: 'ambient3',
      title: 'Ambient 3',
      assetPath: 'assets/audio/ambient/ambient3.mp3',
      category: 'Ambient',
      isLocked: true,
    ),
    const AudioTrack(
      id: 'ambient4',
      title: 'Ambient 4',
      assetPath: 'assets/audio/ambient/ambient4.mp3',
      category: 'Ambient',
      isLocked: true,
    ),

    // Calm tracks
    const AudioTrack(
      id: 'calm1',
      title: 'Calm 1',
      assetPath: 'assets/audio/calm/calm1.mp3',
      category: 'Calm',
    ),
    const AudioTrack(
      id: 'calm2',
      title: 'Calm 2',
      assetPath: 'assets/audio/calm/calm2.mp3',
      category: 'Calm',
    ),
    const AudioTrack(
      id: 'lullaby_beach',
      title: 'Lullaby Beach',
      assetPath: 'assets/audio/calm/lullaby_beach.mp3',
      category: 'Calm',
    ),

    // Meditation tracks
    const AudioTrack(
      id: 'meditation1',
      title: 'Meditation 1',
      assetPath: 'assets/audio/meditation/meditation1.mp3',
      category: 'Meditation',
      isLocked: true,
    ),
    const AudioTrack(
      id: 'meditation2',
      title: 'Meditation 2',
      assetPath: 'assets/audio/meditation/meditation2.mp3',
      category: 'Meditation',
      isLocked: true,
    ),
    const AudioTrack(
      id: 'meditation3',
      title: 'Meditation 3',
      assetPath: 'assets/audio/meditation/meditation3.mp3',
      category: 'Meditation',
      isLocked: true,
    ),
  ];

  // Get tracks by category
  static List<AudioTrack> getTracksByCategory(String category) {
    return tracks.where((track) => track.category == category).toList();
  }

  // Get all available categories
  static List<String> get categories {
    return tracks.map((track) => track.category).toSet().toList();
  }

  // Get a track by ID
  static AudioTrack? getTrackById(String id) {
    try {
      return tracks.firstWhere((track) => track.id == id);
    } catch (e) {
      return null;
    }
  }
}
