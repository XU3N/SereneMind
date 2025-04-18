/// This file contains YouTube video URLs for each pose
/// Each pose name corresponds to its video URL
class PoseVideoUrls {
  // Base URLs
  static const String youtubeEmbedBaseUrl = 'https://www.youtube.com/embed/';
  static const String youtubeWatchBaseUrl = 'https://www.youtube.com/watch?v=';

  // Yoga pose video IDs - map pose names to YouTube video IDs
  static const Map<String, String> poseVideoIds = {
    'Chair': 'nHEs2JVsJ7w', // Chair Pose (Utkatasana)
    'Mountain': 'E-ER61MO4NU', // Mountain Pose (Tadasana)
    'Supported Triangle': 'upFYBbK_hGo', // Triangle Pose (Trikonasana)
    'Upward Salute': 'IrE-1vmG8iM', // Upward Salute (Urdhva Hastasana)
    'Prayer': '7NIZ6vY52MQ', // Prayer Pose (Anjali Mudra)
    'Swaying Palm Tree': 'joBYF9-njJ8', // Palm Tree Pose variation
    'Easy': 'muCqO5nQr5Y', // Easy Pose (Sukhasana)
    'Easy Raised Arms': 'TwBY0FFXwdk', // Easy Pose with arms raised
    'Hero': 'Oum876gL3mI', // Hero Pose (Virasana)
    'Half Bound Angle':
        'tAo-_lEkvaw', // Half Bound Angle (Ardha Baddha Konasana)
    'Supported Head To Knee': 'v2ywGRAxL-M', // Head to Knee (Janu Sirsasana)
    'Corpse Pose': 'hqFGM09v4H4', // Corpse Pose (Savasana)
    'Crescent Lunge': 'yfQlLLH4vGE', // Crescent Lunge (Anjaneyasana)
    'Plank On The Knees': 'jE3xGtwpjX4', // Modified Plank
    'Forearm Plank On The Knees': 'A1WAinU9SFI', // Modified Forearm Plank
    'Side Plank On The Knee': 'ILvXBbzZnWs', // Modified Side Plank
    'Low Lunge Hands To Knee': 'tLy0ly0_WfA', // Low Lunge variation
    'Table Tap': 'kHSp5q-X5xE', // Table Tap exercise
    'Downward Facing Dog With Bent Knees':
        'SqoGfudIs9o', // Modified Downward Dog
  };

  /// Get the YouTube embed URL for a specific pose
  static String getEmbedUrl(String poseName) {
    final videoId = poseVideoIds[poseName] ?? '';
    if (videoId.isEmpty) return '';
    return '$youtubeEmbedBaseUrl$videoId';
  }

  /// Get the YouTube watch URL for a specific pose
  static String getWatchUrl(String poseName) {
    final videoId = poseVideoIds[poseName] ?? '';
    if (videoId.isEmpty) return '';
    return '$youtubeWatchBaseUrl$videoId';
  }
}
