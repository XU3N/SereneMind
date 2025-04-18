import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/theme_controller.dart';
import '../../../../core/widgets/gradient_background_scaffold.dart';
import 'pose_loading_page.dart';

class PoseDetailsPage extends StatefulWidget {
  final String title;
  final String image;
  final String sanskritName;
  final int duration; // in minutes
  final int calories;
  final String? videoUrl; // YouTube video URL

  // Difficulty ratings
  final int flexibilityLevel;
  final int strengthLevel;
  final int balanceLevel;
  final int relaxationLevel;

  // Lists of instructions, benefits, and tips
  final List<String> instructions;
  final List<String> benefits;
  final List<String> beginnerTips;

  const PoseDetailsPage({
    super.key,
    required this.title,
    required this.image,
    required this.sanskritName,
    required this.duration,
    required this.calories,
    required this.flexibilityLevel,
    required this.strengthLevel,
    required this.balanceLevel,
    required this.relaxationLevel,
    required this.instructions,
    required this.benefits,
    required this.beginnerTips,
    this.videoUrl,
  });

  @override
  State<PoseDetailsPage> createState() => _PoseDetailsPageState();
}

class _PoseDetailsPageState extends State<PoseDetailsPage> {
  // Collapsed state for expandable sections
  bool _instructionsCollapsed = false;
  bool _benefitsCollapsed = false;
  bool _tipsCollapsed = false;

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
        actions: [
          IconButton(
            icon: Icon(
              Icons.favorite_border,
              color: isDarkMode ? Colors.white : Colors.black,
            ),
            onPressed: () {
              // Add to favorites functionality
            },
          ),
          IconButton(
            icon: Icon(
              Icons.share,
              color: isDarkMode ? Colors.white : Colors.black,
            ),
            onPressed: () {
              // Share functionality
            },
          ),
        ],
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header image with play button overlay
            Stack(
              alignment: Alignment.center,
              children: [
                // Image
                AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Image.asset(
                    widget.image,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey[300],
                        child: const Center(
                          child: Icon(
                            Icons.image_not_supported,
                            size: 50,
                            color: Colors.grey,
                          ),
                        ),
                      );
                    },
                  ),
                ),

                // Play button
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.teal[600],
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.play_arrow,
                    color: Colors.white,
                    size: 32,
                  ),
                ),
              ],
            ),

            // Pose information
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title section
                  Text(
                    widget.title,
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: isDarkMode ? Colors.white : Colors.black,
                      fontFamily: 'Poppins',
                    ),
                  ),

                  Text(
                    widget.sanskritName,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: isDarkMode ? Colors.white70 : Colors.grey[700],
                      fontFamily: 'Poppins',
                    ),
                  ),

                  const SizedBox(height: 8),

                  // Duration and calories
                  Text(
                    "${widget.duration} Mins · ${widget.calories} Calories",
                    style: TextStyle(
                      fontSize: 16,
                      color: isDarkMode ? Colors.white70 : Colors.grey[800],
                      fontFamily: 'Poppins',
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Tags
                  Row(
                    children: [
                      _buildTag('Newbie', const Color(0xFF2E8B57)),
                      const SizedBox(width: 8),
                      _buildTag('Standing', const Color(0xFFE8894A)),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Skill levels in a 2×2 grid layout
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isDarkMode
                          ? const Color(0xFF1E1E1E)
                          : const Color(0xFFF5F5F5),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: isDarkMode ? Colors.white24 : Colors.black12,
                        width: 1,
                      ),
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: _buildSkillLevelRow(
                                'Flexibility',
                                widget.flexibilityLevel,
                                isDarkMode,
                              ),
                            ),
                            Container(
                              height: 36,
                              width: 1,
                              color:
                                  isDarkMode ? Colors.white70 : Colors.black26,
                            ),
                            Expanded(
                              child: _buildSkillLevelRow(
                                'Strength',
                                widget.strengthLevel,
                                isDarkMode,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          height: 1,
                          color: isDarkMode ? Colors.white70 : Colors.black26,
                          margin: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: _buildSkillLevelRow(
                                'Balance',
                                widget.balanceLevel,
                                isDarkMode,
                              ),
                            ),
                            Container(
                              height: 36,
                              width: 1,
                              color:
                                  isDarkMode ? Colors.white70 : Colors.black26,
                            ),
                            Expanded(
                              child: _buildSkillLevelRow(
                                'Relaxation',
                                widget.relaxationLevel,
                                isDarkMode,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),
                  Divider(
                    color: isDarkMode ? Colors.white70 : Colors.black12,
                    height: 1,
                  ),

                  // Instructions section
                  _buildExpandableSection(
                    title: 'Instructions',
                    isCollapsed: _instructionsCollapsed,
                    onToggle: () {
                      setState(() {
                        _instructionsCollapsed = !_instructionsCollapsed;
                      });
                    },
                    content: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: widget.instructions
                          .asMap()
                          .entries
                          .map((entry) => _buildNumberedInstruction(
                                index: entry.key + 1,
                                text: entry.value,
                                isDarkMode: isDarkMode,
                              ))
                          .toList(),
                    ),
                  ),

                  Divider(
                    color: isDarkMode ? Colors.white70 : Colors.black12,
                    height: 1,
                  ),

                  // Benefits section
                  _buildExpandableSection(
                    title: 'Benefits',
                    isCollapsed: _benefitsCollapsed,
                    onToggle: () {
                      setState(() {
                        _benefitsCollapsed = !_benefitsCollapsed;
                      });
                    },
                    content: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: widget.benefits
                          .map((benefit) => _buildBenefit(
                                text: benefit,
                                isDarkMode: isDarkMode,
                              ))
                          .toList(),
                    ),
                  ),

                  Divider(
                    color: isDarkMode ? Colors.white70 : Colors.black12,
                    height: 1,
                  ),

                  // Beginner's Tips section
                  _buildExpandableSection(
                    title: 'Beginner\'s Tips',
                    isCollapsed: _tipsCollapsed,
                    onToggle: () {
                      setState(() {
                        _tipsCollapsed = !_tipsCollapsed;
                      });
                    },
                    content: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: widget.beginnerTips
                          .asMap()
                          .entries
                          .map((entry) => _buildNumberedInstruction(
                                index: entry.key + 1,
                                text: entry.value,
                                isDarkMode: isDarkMode,
                              ))
                          .toList(),
                    ),
                  ),

                  const SizedBox(height: 60),

                  // Start Practice button
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: () {
                        // Navigate to loading page
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PoseLoadingPage(
                              poseName: widget.title,
                              poseImage: widget.image,
                              videoUrl: widget.videoUrl,
                            ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(0),
                        ),
                      ),
                      child: const Text(
                        'START PRACTICE',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.5,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to build expandable sections
  Widget _buildExpandableSection({
    required String title,
    required bool isCollapsed,
    required VoidCallback onToggle,
    required Widget content,
  }) {
    final isDarkMode = context.watch<ThemeController>().isDarkMode;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: onToggle,
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Poppins',
                    color: isDarkMode ? Colors.white : Colors.black87,
                  ),
                ),
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: isDarkMode
                        ? Colors.white.withOpacity(0.1)
                        : Colors.black.withOpacity(0.05),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    isCollapsed
                        ? Icons.keyboard_arrow_down
                        : Icons.keyboard_arrow_up,
                    size: 24,
                    color: isDarkMode ? Colors.white : Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ),
        if (!isCollapsed)
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            padding: const EdgeInsets.only(bottom: 16.0, left: 8.0, right: 8.0),
            child: content,
          ),
      ],
    );
  }

  // Helper method to build numbered instructions
  Widget _buildNumberedInstruction({
    required int index,
    required String text,
    required bool isDarkMode,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: const Color(0xFF26A69A),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF26A69A).withOpacity(0.3),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Center(
              child: Text(
                '$index',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontFamily: 'Poppins',
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 16,
                  height: 1.5,
                  color: isDarkMode ? Colors.white : Colors.black87,
                  fontFamily: 'Poppins',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Helper method to build benefits with checkmarks
  Widget _buildBenefit({
    required String text,
    required bool isDarkMode,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 4),
            decoration: BoxDecoration(
              color: const Color(0xFF26A69A),
              borderRadius: BorderRadius.circular(6),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF26A69A).withOpacity(0.3),
                  blurRadius: 3,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            padding: const EdgeInsets.all(4),
            child: const Icon(
              Icons.check,
              size: 16,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 2.0),
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 16,
                  height: 1.5,
                  color: isDarkMode ? Colors.white : Colors.black87,
                  fontFamily: 'Poppins',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Helper method to build skill level indicator (stars)
  Widget _buildSkillLevelRow(String title, int level, bool isDarkMode) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              fontFamily: 'Poppins',
              color: isDarkMode ? Colors.white : Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: List.generate(5, (index) {
              return Padding(
                padding: const EdgeInsets.only(right: 2.0),
                child: Icon(
                  index < level ? Icons.star : Icons.star_border,
                  color: index < level
                      ? const Color(0xFFFFC107)
                      : isDarkMode
                          ? Colors.white38
                          : Colors.black38,
                  size: 20,
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  // Helper method to build tags
  Widget _buildTag(String text, Color color) {
    final isDarkMode = context.watch<ThemeController>().isDarkMode;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(isDarkMode ? 0.4 : 0.3),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 14,
          color: Colors.white,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
          fontFamily: 'Poppins',
        ),
      ),
    );
  }
}
