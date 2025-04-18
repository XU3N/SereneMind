import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import '../../../../core/theme/theme_controller.dart';
import '../../data/constants/pose_videos.dart';
import '../services/audio_player_service.dart';
import 'audio_settings_page.dart';

class PoseVideoPage extends StatefulWidget {
  final String poseName;
  final String poseImage;
  final String? videoPath;

  const PoseVideoPage({
    super.key,
    required this.poseName,
    required this.poseImage,
    this.videoPath,
  });

  @override
  State<PoseVideoPage> createState() => _PoseVideoPageState();
}

class _PoseVideoPageState extends State<PoseVideoPage> {
  late VideoPlayerController _controller;
  bool _isFullScreen = false;
  bool _isControlsVisible = true;
  Timer? _controlsTimer;
  double _currentPosition = 0.0;
  double _totalDuration = 177.0; // Default 2:57 in seconds
  bool _isBuffering = true;

  @override
  void initState() {
    super.initState();
    _initVideoPlayer();

    // Force portrait orientation for this page
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    // Start timer to auto-hide controls
    _startControlsTimer();
  }

  void _initVideoPlayer() {
    // Get video path
    final videoPath =
        widget.videoPath ?? PoseVideos.getVideoPath(widget.poseName);

    // Initialize video controller with asset
    _controller = VideoPlayerController.asset(videoPath)
      ..initialize().then((_) {
        if (mounted) {
          setState(() {
            _isBuffering = false;
            if (_controller.value.duration != null) {
              _totalDuration = _controller.value.duration.inSeconds.toDouble();
            }
          });
          _controller.play();

          // Start playing background music if enabled
          final audioService =
              Provider.of<AudioPlayerService>(context, listen: false);
          audioService.playMusic();
        }
      })
      ..addListener(_videoListener);
  }

  void _videoListener() {
    if (mounted) {
      setState(() {
        _currentPosition = _controller.value.position.inSeconds.toDouble();
      });
    }
  }

  void _startControlsTimer() {
    _controlsTimer?.cancel();
    if (_controller.value.isPlaying) {
      _controlsTimer = Timer(const Duration(seconds: 3), () {
        if (mounted) {
          setState(() {
            _isControlsVisible = false;
          });
        }
      });
    }
  }

  // Format time as MM:SS
  String _formatTime(double seconds) {
    final int mins = (seconds / 60).floor();
    final int secs = (seconds % 60).floor();
    return '${mins.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _controlsTimer?.cancel();
    _controller.dispose();

    // Reset orientation settings
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);

    // Stop audio when leaving the page
    final audioService =
        Provider.of<AudioPlayerService>(context, listen: false);
    audioService.stopAll();

    super.dispose();
  }

  void _toggleFullScreen() {
    setState(() {
      _isFullScreen = !_isFullScreen;
    });

    if (_isFullScreen) {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
    } else {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
    }
  }

  void _togglePlayPause() {
    _controller.value.isPlaying ? _controller.pause() : _controller.play();

    // Also pause/resume audio
    final audioService =
        Provider.of<AudioPlayerService>(context, listen: false);
    if (_controller.value.isPlaying) {
      audioService.pauseAll();
    } else {
      audioService.resumeAll();
    }

    setState(() {
      // Always show controls when toggling play/pause
      _isControlsVisible = true;
    });
    _startControlsTimer();
  }

  void _seekBack() {
    final newPosition = (_currentPosition - 10).clamp(0, _totalDuration);
    _controller.seekTo(Duration(seconds: newPosition.toInt()));
  }

  void _seekForward() {
    final newPosition = (_currentPosition + 10).clamp(0, _totalDuration);
    _controller.seekTo(Duration(seconds: newPosition.toInt()));
  }

  void _onSliderValueChanged(double value) {
    _controller.seekTo(Duration(seconds: value.toInt()));
  }

  void _navigateToAudioSettings() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AudioSettingsPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: GestureDetector(
        onTap: () {
          setState(() {
            _isControlsVisible = !_isControlsVisible;
            if (_isControlsVisible) {
              _startControlsTimer();
            }
          });
        },
        behavior: HitTestBehavior.translucent,
        child: Stack(
          children: [
            // Video player
            Center(
              child: _isBuffering
                  ? const CircularProgressIndicator(
                      color: Color(0xFF26A69A),
                    )
                  : AspectRatio(
                      aspectRatio: _controller.value.aspectRatio,
                      child: VideoPlayer(_controller),
                    ),
            ),

            // Controls overlay (visible when _isControlsVisible is true)
            if (_isControlsVisible)
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.white.withOpacity(0.7),
                        Colors.transparent,
                        Colors.transparent,
                        Colors.white.withOpacity(0.7),
                      ],
                      stops: const [0.0, 0.2, 0.8, 1.0],
                    ),
                  ),
                  child: Column(
                    children: [
                      // Top bar with back button and pose name
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 40, 16, 0),
                        child: Row(
                          children: [
                            // Back button
                            IconButton(
                              icon: const Icon(Icons.arrow_back,
                                  color: Colors.black),
                              onPressed: () => Navigator.pop(context),
                            ),

                            // Pose name
                            Text(
                              widget.poseName,
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                fontFamily: 'Poppins',
                              ),
                            ),

                            const Spacer(),

                            // Short/Long toggle
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.5),
                                border: Border.all(color: Colors.black12),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Row(
                                children: [
                                  Icon(
                                    Icons.person_outline,
                                    color: Colors.black,
                                    size: 18,
                                  ),
                                  SizedBox(width: 4),
                                  Text(
                                    'Short',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      const Spacer(),

                      // Bottom controls
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          children: [
                            // Progress bar
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8),
                              child: ProgressBar(
                                progress:
                                    Duration(seconds: _currentPosition.toInt()),
                                total:
                                    Duration(seconds: _totalDuration.toInt()),
                                buffered: _controller.value.buffered.isNotEmpty
                                    ? _controller.value.buffered.last.end
                                    : Duration.zero,
                                progressBarColor: const Color(0xFF26A69A),
                                baseBarColor: Colors.grey.shade300,
                                bufferedBarColor:
                                    Colors.grey.shade400.withOpacity(0.4),
                                thumbColor: const Color(0xFF26A69A),
                                barHeight: 4.0,
                                thumbRadius: 6.0,
                                timeLabelTextStyle: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                  fontFamily: 'Poppins',
                                ),
                                onSeek: (duration) {
                                  _controller.seekTo(duration);
                                },
                              ),
                            ),

                            const SizedBox(height: 16),

                            // Playback controls
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                // Settings button
                                IconButton(
                                  icon: const Icon(Icons.settings,
                                      color: Colors.black),
                                  onPressed: _navigateToAudioSettings,
                                  iconSize: 28,
                                ),

                                // Skip back 10 seconds
                                IconButton(
                                  icon: const Icon(Icons.replay_10,
                                      color: Colors.black),
                                  onPressed: _seekBack,
                                  iconSize: 36,
                                ),

                                // Play/Pause
                                Container(
                                  height: 60,
                                  width: 60,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                    border: Border.all(color: Colors.black26),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.2),
                                        blurRadius: 8,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: IconButton(
                                    icon: Icon(
                                      _controller.value.isPlaying
                                          ? Icons.pause
                                          : Icons.play_arrow,
                                      color: Colors.black,
                                      size: 36,
                                    ),
                                    onPressed: _togglePlayPause,
                                  ),
                                ),

                                // Skip forward 10 seconds
                                IconButton(
                                  icon: const Icon(Icons.forward_10,
                                      color: Colors.black),
                                  onPressed: _seekForward,
                                  iconSize: 36,
                                ),

                                // Fullscreen button
                                IconButton(
                                  icon: const Icon(Icons.fullscreen,
                                      color: Colors.black),
                                  onPressed: _toggleFullScreen,
                                  iconSize: 28,
                                ),
                              ],
                            ),

                            const SizedBox(height: 30),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

            // Buffering indicator
            if (_controller.value.isBuffering)
              const Center(
                child: CircularProgressIndicator(
                  color: Color(0xFF26A69A),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
