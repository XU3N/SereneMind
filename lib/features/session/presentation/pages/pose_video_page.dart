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
  bool _showFeedback = false;
  String _feedbackMessage = "";

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    _initVideoPlayer();
    _startControlsTimer();
  }

  void _initVideoPlayer() {
    // Get video path
    final videoPath =
        widget.videoPath ?? PoseVideos.getVideoPath(widget.poseName);

    try {
      // Initialize video controller with asset
      _controller = VideoPlayerController.asset(videoPath)
        ..initialize().then((_) {
          if (mounted) {
            setState(() {
              _isBuffering = false;
              if (_controller.value.duration != null) {
                _totalDuration =
                    _controller.value.duration.inSeconds.toDouble();
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
    } catch (e) {
      // Handle errors in video loading
      debugPrint('Error loading video: $e');
      setState(() {
        _isBuffering = false;
      });

      // Show error toast/snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to load video. Please try again later.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _videoListener() {
    if (_controller.value.isPlaying &&
        !_controlsTimer!.isActive &&
        _isControlsVisible) {
      _startControlsTimer();
    }

    if (mounted) {
      setState(() {
        if (_controller.value.isInitialized) {
          _currentPosition = _controller.value.position.inSeconds.toDouble();

          // Handle video completion
          if (_controller.value.position >= _controller.value.duration) {
            _isControlsVisible = true;
          }
        }
      });
    }
  }

  void _startControlsTimer() {
    if (_controlsTimer != null) {
      _controlsTimer!.cancel();
    }
    _controlsTimer = Timer(const Duration(seconds: 3), () {
      if (mounted && _controller.value.isPlaying) {
        setState(() {
          _isControlsVisible = false;
        });
      }
    });
  }

  // Format time as MM:SS
  String _formatTime(double seconds) {
    final int mins = (seconds / 60).floor();
    final int secs = (seconds % 60).floor();
    return '${mins.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    if (_controlsTimer != null) {
      _controlsTimer!.cancel();
    }
    _controller.removeListener(_videoListener);
    _controller.dispose();
    super.dispose();
  }

  void _toggleFullScreen() {
    setState(() {
      _isFullScreen = !_isFullScreen;

      if (_isFullScreen) {
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.landscapeLeft,
          DeviceOrientation.landscapeRight,
        ]);
      } else {
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.portraitUp,
          DeviceOrientation.landscapeLeft,
          DeviceOrientation.landscapeRight,
        ]);
      }
    });
  }

  void _togglePlayPause() {
    setState(() {
      if (_controller.value.isPlaying) {
        _controller.pause();
        _isControlsVisible = true;
        if (_controlsTimer != null) {
          _controlsTimer!.cancel();
        }
      } else {
        _controller.play();
        _startControlsTimer();
      }
    });
  }

  void _seekForward() {
    final newPosition = _currentPosition + 10;
    if (newPosition <= _totalDuration) {
      _controller.seekTo(Duration(seconds: newPosition.toInt()));
    } else {
      _controller.seekTo(_controller.value.duration);
    }
  }

  void _seekBack() {
    final newPosition = _currentPosition - 10;
    if (newPosition >= 0) {
      _controller.seekTo(Duration(seconds: newPosition.toInt()));
    } else {
      _controller.seekTo(Duration.zero);
    }
  }

  void _onSliderValueChanged(double value) {
    _controller.seekTo(Duration(seconds: value.toInt()));
  }

  void _navigateToAudioSettings() {
    // Pause video while in settings
    _controller.pause();

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AudioSettingsPage(),
      ),
    ).then((_) {
      // Resume video when returning from settings if it was playing before
      if (mounted && !_controller.value.isPlaying) {
        _togglePlayPause();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isLandscape = screenSize.width > screenSize.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            // Video player takes up the entire screen
            Positioned.fill(
              child: Center(
                child: _controller.value.isInitialized
                    ? _buildVideoWithGestures()
                    : _buildLoadingIndicator(),
              ),
            ),

            // Overlay controls
            if (_controller.value.isInitialized)
              GestureDetector(
                onTap: () {
                  setState(() {
                    _isControlsVisible = !_isControlsVisible;
                    if (_isControlsVisible) {
                      _startControlsTimer();
                    }
                  });
                },
                behavior: HitTestBehavior.translucent,
                child: Container(
                  color: Colors.transparent,
                ),
              ),

            // Controls overlay
            if (_isControlsVisible)
              Positioned.fill(
                child: _buildControlsOverlay(),
              ),

            // Feedback message overlay (for seek operations)
            if (_showFeedback)
              Center(
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    _feedbackMessage,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Poppins',
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildVideoWithGestures() {
    return GestureDetector(
      onDoubleTapDown: (details) {
        final screenWidth = MediaQuery.of(context).size.width;
        final dx = details.globalPosition.dx;

        // If tap is on left side of screen, rewind 10 seconds
        if (dx < screenWidth / 2) {
          _seekRelative(-10);
        }
        // If tap is on right side of screen, forward 10 seconds
        else {
          _seekRelative(10);
        }
      },
      child: AspectRatio(
        aspectRatio: _controller.value.aspectRatio,
        child: VideoPlayer(_controller),
      ),
    );
  }

  void _seekRelative(int seconds) {
    final newPosition = _controller.value.position + Duration(seconds: seconds);
    final videoDuration = _controller.value.duration;

    // Ensure we don't seek beyond the video duration or before the start
    if (newPosition < Duration.zero) {
      _controller.seekTo(Duration.zero);
    } else if (newPosition > videoDuration) {
      _controller.seekTo(videoDuration);
    } else {
      _controller.seekTo(newPosition);
    }

    // Show a quick feedback popup
    setState(() {
      _feedbackMessage = seconds > 0 ? "+$seconds sec" : "$seconds sec";
      _showFeedback = true;
    });

    // Hide feedback after a short delay
    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) {
        setState(() {
          _showFeedback = false;
        });
      }
    });
  }

  Widget _buildLoadingIndicator() {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Display the pose image as a background
        Positioned.fill(
          child: Image.asset(
            widget.poseImage,
            fit: BoxFit.cover,
          ),
        ),
        // Semi-transparent overlay to improve contrast with loading indicator
        Positioned.fill(
          child: Container(
            color: Colors.black.withOpacity(0.5),
          ),
        ),
        // Loading indicator and text
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
            const SizedBox(height: 20),
            const Text(
              'Loading video...',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
                fontFamily: 'Poppins',
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildControlsOverlay() {
    final theme = Theme.of(context);
    final isVideoReady = _controller.value.isInitialized;

    return AnimatedOpacity(
      opacity: _isControlsVisible ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 300),
      child: GestureDetector(
        onTap: () {
          setState(() {
            _isControlsVisible = !_isControlsVisible;
            if (_isControlsVisible) {
              _startControlsTimer();
            } else if (_controlsTimer != null) {
              _controlsTimer!.cancel();
            }
          });
        },
        child: Container(
          color: Colors.black.withOpacity(0.4),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Top bar with back button and settings
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                        size: 28,
                      ),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(
                            _isFullScreen
                                ? Icons.fullscreen_exit
                                : Icons.fullscreen,
                            color: Colors.white,
                            size: 28,
                          ),
                          onPressed: _toggleFullScreen,
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.settings,
                            color: Colors.white,
                            size: 28,
                          ),
                          onPressed: _navigateToAudioSettings,
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Center play/pause button
              IconButton(
                iconSize: 60,
                icon: Icon(
                  _controller.value.isPlaying
                      ? Icons.pause_circle_filled
                      : Icons.play_circle_filled,
                  color: Colors.white,
                ),
                onPressed: isVideoReady ? _togglePlayPause : null,
              ),

              // Bottom controls with progress slider and seek buttons
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.7),
                    ],
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Time display and progress
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _formatDuration(_controller.value.position),
                          style: const TextStyle(color: Colors.white),
                        ),
                        Text(
                          _formatDuration(_controller.value.duration),
                          style: const TextStyle(color: Colors.white),
                        ),
                      ],
                    ),

                    // Progress slider
                    SliderTheme(
                      data: SliderThemeData(
                        thumbColor: theme.colorScheme.primary,
                        activeTrackColor: theme.colorScheme.primary,
                        inactiveTrackColor: Colors.white.withOpacity(0.3),
                        thumbShape:
                            const RoundSliderThumbShape(enabledThumbRadius: 6),
                        trackHeight: 4,
                        overlayShape:
                            const RoundSliderOverlayShape(overlayRadius: 14),
                      ),
                      child: Slider(
                        value: _currentPosition.clamp(0, _totalDuration),
                        min: 0,
                        max: _totalDuration,
                        onChanged: isVideoReady
                            ? (value) {
                                _controller
                                    .seekTo(Duration(seconds: value.toInt()));
                                setState(() {
                                  _currentPosition = value;
                                });
                              }
                            : null,
                      ),
                    ),

                    // Control buttons row
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.replay_10,
                                color: Colors.white, size: 28),
                            onPressed: isVideoReady ? _seekBack : null,
                          ),
                          IconButton(
                            iconSize: 40,
                            icon: Icon(
                              _controller.value.isPlaying
                                  ? Icons.pause_circle_filled
                                  : Icons.play_circle_filled,
                              color: Colors.white,
                            ),
                            onPressed: isVideoReady ? _togglePlayPause : null,
                          ),
                          IconButton(
                            icon: const Icon(Icons.forward_10,
                                color: Colors.white, size: 28),
                            onPressed: isVideoReady ? _seekForward : null,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }
}
