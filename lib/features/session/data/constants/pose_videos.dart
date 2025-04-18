/// Mapping of pose names to their video file paths
class PoseVideos {
  static const Map<String, String> poseVideoPaths = {
    'Chair': 'assets/videos/chair_pose.mp4',
    'Mountain': 'assets/videos/mountain_pose.mp4',
    'Supported Triangle': 'assets/videos/triangle_pose.mp4',
    'Upward Salute': 'assets/videos/upward_salute.mp4',
    'Prayer': 'assets/videos/prayer_pose.mp4',
    'Swaying Palm Tree': 'assets/videos/palm_tree_pose.mp4',
    'Easy': 'assets/videos/easy_pose.mp4',
    'Easy Raised Arms': 'assets/videos/easy_raised_arms.mp4',
    'Hero': 'assets/videos/hero_pose.mp4',
    'Half Bound Angle': 'assets/videos/half_bound_angle.mp4',
    'Supported Head To Knee': 'assets/videos/head_to_knee_pose.mp4',
    'Corpse Pose': 'assets/videos/corpse_pose.mp4',
    'Crescent Lunge': 'assets/videos/crescent_lunge.mp4',
    'Plank On The Knees': 'assets/videos/plank_on_knees.mp4',
    'Forearm Plank On The Knees': 'assets/videos/forearm_plank_on_knees.mp4',
    'Side Plank On The Knee': 'assets/videos/side_plank_on_knee.mp4',
    'Low Lunge Hands To Knee': 'assets/videos/low_lunge_hands_to_knee.mp4',
    'Table Tap': 'assets/videos/table_tap.mp4',
    'Downward Facing Dog With Bent Knees':
        'assets/videos/downward_dog_bent_knees.mp4',
  };

  /// Get the video path for a specific pose
  static String getVideoPath(String poseName) {
    return poseVideoPaths[poseName] ?? 'assets/videos/default_pose.mp4';
  }
}
