import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/theme_controller.dart';
import '../../../../core/widgets/gradient_background_scaffold.dart';
import '../../data/constants/pose_videos.dart';
import 'pose_video_page.dart';

class PoseTapToBeginPage extends StatelessWidget {
  final String poseName;
  final String poseImage;
  final String? videoPath;

  const PoseTapToBeginPage({
    super.key,
    required this.poseName,
    required this.poseImage,
    this.videoPath,
  });

  void _navigateToPoseVideo(BuildContext context) {
    // Get video path for this pose
    final path = videoPath ?? PoseVideos.getVideoPath(poseName);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => PoseVideoPage(
          poseName: poseName,
          poseImage: poseImage,
          videoPath: path,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeController = context.watch<ThemeController>();
    final isDarkMode = themeController.isDarkMode;

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
      child: GestureDetector(
        onTap: () => _navigateToPoseVideo(context),
        behavior: HitTestBehavior.opaque,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Tap to Begin',
                style: TextStyle(
                  fontSize: 42,
                  fontWeight: FontWeight.bold,
                  color: isDarkMode ? Colors.white : Colors.black,
                  fontFamily: 'Poppins',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
