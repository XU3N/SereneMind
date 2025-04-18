import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/constants/audio_tracks.dart';
import '../../data/models/audio_track.dart';
import '../services/audio_player_service.dart';

class MusicSelectionPage extends StatefulWidget {
  const MusicSelectionPage({super.key});

  @override
  State<MusicSelectionPage> createState() => _MusicSelectionPageState();
}

class _MusicSelectionPageState extends State<MusicSelectionPage> {
  bool _shuffleEnabled = true;
  String? _selectedTrackId;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  void _loadSettings() {
    final audioService =
        Provider.of<AudioPlayerService>(context, listen: false);
    setState(() {
      _shuffleEnabled = audioService.shuffleEnabled;
      _selectedTrackId = audioService.selectedTrackId;
    });
  }

  void _toggleShuffle() {
    final audioService =
        Provider.of<AudioPlayerService>(context, listen: false);
    setState(() {
      _shuffleEnabled = !_shuffleEnabled;
      if (_shuffleEnabled) {
        _selectedTrackId = null;
      }
      audioService.shuffleEnabled = _shuffleEnabled;
      if (_selectedTrackId != null) {
        audioService.selectedTrackId = _selectedTrackId;
      }
    });
  }

  void _selectTrack(String trackId) {
    final audioService =
        Provider.of<AudioPlayerService>(context, listen: false);
    setState(() {
      _selectedTrackId = trackId;
      _shuffleEnabled = false;
      audioService.shuffleEnabled = false;
      audioService.selectedTrackId = trackId;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF5F5F5),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Music',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w600,
            fontFamily: 'Poppins',
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Shuffle Option
              _buildMusicOptionCard(
                title: 'Shuffle',
                isSelected: _shuffleEnabled,
                onTap: _toggleShuffle,
                showCheckmark: true,
              ),

              const SizedBox(height: 8),

              // Description text
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Text(
                  'Shuffle through all songs randomly',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                    fontFamily: 'Poppins',
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Ambient Tracks
              _buildCategoryTracks('Ambient'),

              // Calm Tracks
              _buildCategoryTracks('Calm'),

              // Meditation Tracks
              _buildCategoryTracks('Meditation'),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryTracks(String category) {
    final tracks = AudioTracks.getTracksByCategory(category);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final track in tracks)
          _buildMusicOptionCard(
            title: track.title,
            isSelected: _selectedTrackId == track.id,
            isLocked: track.isLocked,
            onTap: track.isLocked ? null : () => _selectTrack(track.id),
          ),
      ],
    );
  }

  Widget _buildMusicOptionCard({
    required String title,
    required bool isSelected,
    bool isLocked = false,
    VoidCallback? onTap,
    bool showCheckmark = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isSelected ? const Color(0xFF26A69A) : Colors.transparent,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Row(
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                    color: isLocked ? Colors.grey : Colors.black,
                    fontFamily: 'Poppins',
                  ),
                ),
                const Spacer(),
                if (isLocked)
                  const Icon(
                    Icons.lock,
                    color: Colors.grey,
                    size: 20,
                  )
                else if (isSelected && showCheckmark)
                  const Icon(
                    Icons.check,
                    color: Color(0xFF26A69A),
                    size: 20,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
