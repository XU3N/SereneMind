import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/theme_controller.dart';
import '../../../../core/widgets/gradient_background_scaffold.dart';
import 'pose_details_page.dart';
import '../../data/constants/pose_video_urls.dart';

class SessionPage extends StatefulWidget {
  const SessionPage({super.key});

  @override
  State<SessionPage> createState() => _SessionPageState();
}

class _SessionPageState extends State<SessionPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<String> carouselImages = [
    'assets/images/session/pose1.jpg',
    'assets/images/session/pose2.jpg',
    'assets/images/session/pose3.jpg',
  ];

  final List<(String, String)> carouselContent = [
    ('Asana Explorer', 'Find balance with peaceful standing poses'),
    ('Mindful Movement', 'Move with ease and calm your mind'),
    (
      'Strength Builder',
      'Build foundational strength with effective movements'
    ),
  ];

  final List<(int, int)> progressData = [
    (1, 11), // Current progress, Total poses
    (3, 8), // Current progress, Total poses
    (2, 5), // Current progress, Total poses
  ];

  final List<List<(String, String, bool, bool)>> posesData = [
    // Asana Explorer poses
    [
      ('Chair', 'assets/images/session/chair.png', true, true),
      ('Mountain', 'assets/images/session/mountain.png', true, false),
      (
        'Supported Triangle',
        'assets/images/session/triangle.png',
        false,
        false
      ),
      (
        'Upward Salute',
        'assets/images/session/upward_salute.png',
        false,
        false
      ),
      ('Prayer', 'assets/images/session/prayer.png', false, false),
      (
        'Swaying Palm Tree',
        'assets/images/session/palm_tree.png',
        false,
        false
      ),
    ],
    // Mindful Movement poses
    [
      ('Easy', 'assets/images/session/easy.png', true, true),
      (
        'Easy Raised Arms',
        'assets/images/session/easy_raised_arms.png',
        true,
        true
      ),
      ('Hero', 'assets/images/session/hero.png', true, false),
      (
        'Half Bound Angle',
        'assets/images/session/half_bound.png',
        false,
        false
      ),
      (
        'Supported Head To Knee',
        'assets/images/session/supported_head_to_knee.png',
        false,
        false
      ),
      ('Corpse Pose', 'assets/images/session/corpse_pose.png', false, false),
    ],
    // Strength Builder poses
    [
      (
        'Plank On The Knees',
        'assets/images/session/plank_knees.png',
        true,
        true
      ),
      (
        'Forearm Plank On The Knees',
        'assets/images/session/forearm_plank_knees.png',
        true,
        false
      ),
      (
        'Side Plank On The Knee',
        'assets/images/session/side_plank_knee.png',
        false,
        false
      ),
      (
        'Low Lunge Hands To Knee',
        'assets/images/session/low_lunge_knee.png',
        false,
        false
      ),
      ('Table Tap', 'assets/images/session/table_tap.png', false, false),
      (
        'Downward Facing Dog With Bent Knees',
        'assets/images/session/downward_facing_knees.png',
        false,
        false
      ),
    ],
  ];

  @override
  Widget build(BuildContext context) {
    final themeController = context.watch<ThemeController>();
    final isDarkMode = themeController.isDarkMode;

    return GradientBackgroundScaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back,
              color: isDarkMode ? Colors.white : Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'My Training Path',
          style: TextStyle(
            color: isDarkMode ? Colors.white : Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(isDarkMode ? Icons.light_mode : Icons.dark_mode,
                color: isDarkMode ? Colors.white : Colors.black),
            onPressed: () {
              themeController.toggleTheme();
            },
          ),
          IconButton(
            icon: Icon(Icons.share_outlined,
                color: isDarkMode ? Colors.white : Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Carousel
            AspectRatio(
              aspectRatio: 1.8,
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 16),
                child: Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    PageView.builder(
                      controller: _pageController,
                      onPageChanged: (index) {
                        setState(() {
                          _currentPage = index;
                        });
                      },
                      itemCount: carouselImages.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24.0),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                  color:
                                      const Color.fromARGB(255, 135, 106, 95),
                                  width: 5),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.asset(
                                carouselImages[index],
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),

            // Carousel indicators moved below the carousel
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  carouselImages.length,
                  (index) => Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _currentPage == index
                          ? const Color(0xFF65B741)
                          : const Color(0xFFE0E0E0),
                    ),
                  ),
                ),
              ),
            ),

            // Content Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  Text(
                    carouselContent[_currentPage].$1,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: isDarkMode ? Colors.white : Colors.black,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    carouselContent[_currentPage].$2,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: isDarkMode ? Colors.white : Color(0xFF9E9E9E),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Progress Section
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${(progressData[_currentPage].$1 / progressData[_currentPage].$2 * 100).toInt()}%',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: isDarkMode ? Colors.white : Colors.black,
                        ),
                      ),
                      Text(
                        '${progressData[_currentPage].$1}/${progressData[_currentPage].$2}',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: isDarkMode ? Colors.white : Colors.black,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  LinearProgressIndicator(
                    value: progressData[_currentPage].$1 /
                        progressData[_currentPage].$2,
                    backgroundColor: isDarkMode
                        ? const Color(0xFF303030)
                        : const Color(0xFFF5F5F5),
                    valueColor:
                        const AlwaysStoppedAnimation<Color>(Color(0xFF65B741)),
                    minHeight: 8,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  const SizedBox(height: 32),

                  // Poses Grid
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      mainAxisSpacing: 20,
                      crossAxisSpacing: 16,
                      childAspectRatio: 0.7,
                    ),
                    itemCount: 6,
                    itemBuilder: (context, index) {
                      final pose = posesData[_currentPage][index];
                      return _PoseItem(
                        title: pose.$1,
                        image: pose.$2,
                        isUnlocked: pose.$3,
                        isCompleted: pose.$4,
                      );
                    },
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ignore: unused_element
class _CarouselItem extends StatelessWidget {
  final String image;

  const _CarouselItem({required this.image});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = context.watch<ThemeController>().isDarkMode;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Image.asset(
          image,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              decoration: BoxDecoration(
                color: isDarkMode ? Colors.grey[800] : Colors.grey[200],
                borderRadius: BorderRadius.circular(24),
              ),
              child: Center(
                child: Icon(
                  Icons.image_not_supported,
                  size: 50,
                  color: isDarkMode ? Colors.grey[600] : Colors.grey,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _PoseItem extends StatelessWidget {
  final String title;
  final String image;
  final bool isUnlocked;
  final bool isCompleted;

  const _PoseItem({
    required this.title,
    required this.image,
    this.isUnlocked = false,
    this.isCompleted = false,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final itemSize = (screenWidth - 64) / 3;
    final isDarkMode = context.watch<ThemeController>().isDarkMode;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Stack(
          alignment: Alignment.topRight,
          children: [
            GestureDetector(
              onTap: isUnlocked ? () => _navigateToPoseDetails(context) : null,
              child: SizedBox(
                width: itemSize - 16,
                height: itemSize - 16,
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isCompleted
                        ? const Color(0xFFC5ADE3)
                        : isDarkMode
                            ? Color(0xFFBDBDBD)
                            : const Color(0xFFF5F5F5),
                    border: Border.all(
                      color: isCompleted
                          ? const Color(
                              0xFF7D4CDB) // Dark purple for completed items
                          : isDarkMode
                              ? Colors.white
                                  .withOpacity(0.6) // White border in dark mode
                              : Colors.white, // White border in light mode
                      width: 3,
                    ),
                    boxShadow: [
                      if (!isDarkMode)
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: ColorFiltered(
                      colorFilter: ColorFilter.matrix(isCompleted
                          ? [
                              1,
                              0,
                              0,
                              0,
                              0,
                              0,
                              1,
                              0,
                              0,
                              0,
                              0,
                              0,
                              1,
                              0,
                              0,
                              0,
                              0,
                              0,
                              1,
                              0,
                            ]
                          : isDarkMode
                              ? [
                                  0.324,
                                  0.324,
                                  0.324,
                                  0,
                                  0,
                                  0.324,
                                  0.324,
                                  0.324,
                                  0,
                                  0,
                                  0.324,
                                  0.324,
                                  0.324,
                                  0,
                                  0,
                                  0,
                                  0,
                                  0,
                                  1,
                                  0,
                                ]
                              : [
                                  0.418,
                                  0.418,
                                  0.418,
                                  0,
                                  0.8, // Lighter grey values
                                  0.418,
                                  0.418,
                                  0.418,
                                  0,
                                  0.8,
                                  0.418,
                                  0.418,
                                  0.418,
                                  0,
                                  0.8,
                                  0,
                                  0,
                                  0,
                                  1,
                                  0,
                                ]),
                      child: Image.asset(
                        image,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) {
                          return Center(
                            child: Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: isCompleted
                                    ? const Color(0xFFC5ADE3)
                                    : isDarkMode
                                        ? const Color(0xFF2A2A2A)
                                        : const Color(0xFFF5F5F5),
                              ),
                              child: Icon(
                                Icons.image_not_supported,
                                color: isDarkMode
                                    ? const Color(0xFF505050)
                                    : const Color(0xFFE0E0E0),
                                size: 24,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ),
            if (!isUnlocked)
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: isDarkMode ? Color(0xFF505050) : Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(26),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                  border: Border.all(
                    color: const Color(0xFFE0E0E0),
                    width: 1,
                  ),
                ),
                child: const Icon(
                  Icons.lock,
                  size: 16,
                  color: Color(0xFFE0E0E0),
                ),
              ),
          ],
        ),
        const SizedBox(height: 4),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Text(
            title,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: isCompleted
                  ? (isDarkMode ? Colors.white : Colors.black)
                  : const Color(0xFFBDBDBD),
            ),
          ),
        ),
      ],
    );
  }

  void _navigateToPoseDetails(BuildContext context) {
    // Base YouTube URL from pose name
    final String? youtubeUrl = PoseVideoUrls.getWatchUrl(title);

    if (title == 'Chair') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PoseDetailsPage(
            title: 'Chair',
            sanskritName: 'Utkatasana',
            image: 'assets/images/session/chair.png',
            duration: 2,
            calories: 21,
            flexibilityLevel: 1,
            strengthLevel: 2,
            balanceLevel: 2,
            relaxationLevel: 3,
            videoUrl: youtubeUrl,
            instructions: [
              'Start in Mountain Pose, standing tall with your feet together.',
              'Lower your hips back as if you\'re sitting into an imaginary chair, while raising your arms towards the sky with your elbows straight.',
              'Keep your arms parallel, with palms facing each other, and stretch your fingertips toward the ceiling.',
              'Lean your torso slightly forward to maintain balance, keeping your spine straight and your chest lifted.',
            ],
            benefits: [
              'Strengthen the muscles in the thighs, calves, and ankles, building endurance in the lower body.',
              'Engage the core muscles to improve stability and balance.',
              'Stretch the shoulders and chest as the arms extend upward, enhancing flexibility.',
              'Stimulate the heart and diaphragm, increasing heart rate and encouraging deep breathing.',
            ],
            beginnerTips: [
              'Use a block or towel for practice, squeezing it and pushing it back as you rotate your thighs inward.',
              'If needed, widen your feet for more stability.',
              'Press firmly through your feet to lift your upper body. Ensure weight is evenly distributed between the heels and the balls of your feet.',
            ],
          ),
        ),
      );
    } else {
      // For other poses, use generic data
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PoseDetailsPage(
            title: title,
            sanskritName: 'Sanskrit Name',
            image: image,
            duration: 2,
            calories: 15,
            flexibilityLevel: 2,
            strengthLevel: 2,
            balanceLevel: 2,
            relaxationLevel: 2,
            videoUrl: youtubeUrl,
            instructions: [
              'Instruction 1',
              'Instruction 2',
              'Instruction 3',
            ],
            benefits: [
              'Benefit 1',
              'Benefit 2',
              'Benefit 3',
            ],
            beginnerTips: [
              'Tip 1',
              'Tip 2',
              'Tip 3',
            ],
          ),
        ),
      );
    }
  }
}
