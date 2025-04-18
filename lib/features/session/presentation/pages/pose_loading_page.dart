import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/theme_controller.dart';
import '../../../../core/widgets/gradient_background_scaffold.dart';
import 'pose_tap_to_begin_page.dart';

class PoseLoadingPage extends StatefulWidget {
  final String poseName;
  final String poseImage;
  final String? videoPath;

  const PoseLoadingPage({
    super.key,
    required this.poseName,
    required this.poseImage,
    this.videoPath,
  });

  @override
  State<PoseLoadingPage> createState() => _PoseLoadingPageState();
}

class _PoseLoadingPageState extends State<PoseLoadingPage> {
  double _loadingProgress = 0.0;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _startLoading();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _startLoading() {
    const totalDuration = Duration(seconds: 3);
    const interval = Duration(milliseconds: 100);
    final steps = totalDuration.inMilliseconds ~/ interval.inMilliseconds;
    final incrementPerStep = 1.0 / steps;

    _timer = Timer.periodic(interval, (timer) {
      setState(() {
        if (_loadingProgress < 1.0) {
          // Add the increment but ensure it doesn't exceed 1.0 (100%)
          _loadingProgress =
              (_loadingProgress + incrementPerStep).clamp(0.0, 1.0);
        } else {
          _timer.cancel();
          _navigateToTapToBegin();
        }
      });
    });
  }

  void _navigateToTapToBegin() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => PoseTapToBeginPage(
          poseName: widget.poseName,
          poseImage: widget.poseImage,
          videoPath: widget.videoPath,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeController = context.watch<ThemeController>();
    final isDarkMode = themeController.isDarkMode;
    final progressPercentage = (_loadingProgress * 100).toInt();

    return GradientBackgroundScaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: isDarkMode ? Colors.white : Colors.black,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Circular progress indicator with percentage
            Stack(
              alignment: Alignment.center,
              children: [
                // Outer circle with progress
                SizedBox(
                  width: 200,
                  height: 200,
                  child: CircularProgressIndicator(
                    value: _loadingProgress,
                    strokeWidth: 5,
                    backgroundColor: Colors.transparent,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      const Color(0xFF26A69A),
                    ),
                  ),
                ),

                // Percentage text
                Text(
                  "$progressPercentage%",
                  style: TextStyle(
                    fontSize: 64,
                    fontWeight: FontWeight.bold,
                    color: isDarkMode ? Colors.white : Colors.black,
                    fontFamily: 'Poppins',
                  ),
                ),
              ],
            ),

            const SizedBox(height: 40),

            // Loading text
            Text(
              'Generating your Daily Routine...',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
                color: isDarkMode ? Colors.white70 : Colors.black54,
                fontFamily: 'Poppins',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
