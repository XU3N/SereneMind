import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/theme/theme_controller.dart';
import '../../../../core/widgets/gradient_background_scaffold.dart';
import '../../../session/presentation/pages/session_page.dart';
import '../../../profile/presentation/pages/profile_page.dart';
import 'dart:async';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _userName = '';
  bool _isLoading = true;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    _loadUserName();
  }

  Future<void> _loadUserName() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final user = _auth.currentUser;
      if (user != null && user.email != null) {
        final docSnapshot =
            await _firestore.collection('users').doc(user.email).get();

        if (docSnapshot.exists) {
          final userData = docSnapshot.data();
          if (userData != null && userData['name'] != null) {
            setState(() {
              _userName = userData['name'].split(' ')[0]; // Get first name only
            });
          } else {
            setState(() {
              _userName = 'Friend'; // Default if name not found
            });
          }
        } else {
          setState(() {
            _userName = 'Friend'; // Default if document doesn't exist
          });
        }
      }
    } catch (e) {
      debugPrint('Error loading user name: ${e.toString()}');
      setState(() {
        _userName = 'Friend'; // Default in case of error
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeController = context.watch<ThemeController>();
    final isDarkMode = themeController.isDarkMode;

    return GradientBackgroundScaffold(
      extendBody: true,
      bottomNavigationBar: Container(
        margin: const EdgeInsets.only(bottom: 22.0),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        decoration: BoxDecoration(
          color: isDarkMode ? Colors.black12 : const Color(0xFFFFE5DB),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _BottomNavItem(
              icon: Icons.home_filled,
              isSelected: true,
              isDarkMode: isDarkMode,
              onTap: () {},
            ),
            _BottomNavItem(
              icon: Icons.language,
              isDarkMode: isDarkMode,
              onTap: () {},
            ),
            _BottomNavItem(
              icon: Icons.shopping_bag_outlined,
              isDarkMode: isDarkMode,
              onTap: () {},
            ),
            _BottomNavItem(
              icon: Icons.person_outline,
              isDarkMode: isDarkMode,
              onTap: () {},
            ),
          ],
        ),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Bar
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _isLoading
                        ? const SizedBox(
                            width: 120,
                            child: LinearProgressIndicator(),
                          )
                        : Text(
                            'Hi $_userName!',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: isDarkMode ? Colors.white : Colors.black,
                            ),
                          ),
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(
                            isDarkMode ? Icons.light_mode : Icons.dark_mode,
                            color: isDarkMode ? Colors.white : Colors.black,
                          ),
                          onPressed: () {
                            themeController.toggleTheme();
                          },
                        ),
                        const SizedBox(width: 8),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context)
                                .push(
                              MaterialPageRoute(
                                builder: (context) => const ProfilePage(),
                              ),
                            )
                                .then((_) {
                              // Refresh user name when returning from profile page
                              _loadUserName();
                            });
                          },
                          child: const CircleAvatar(
                            radius: 20,
                            backgroundImage:
                                AssetImage('assets/images/avatars/profile.jpg'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 40),

                // Motivational Quote Carousel
                const _MotivationalCarousel(),
                const SizedBox(height: 40),

                // Category Section
                Text(
                  'Category',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
                ),
                const SizedBox(height: 24),

                // Individual Category Card
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const SessionPage(),
                      ),
                    );
                  },
                  child: _CategoryCard(
                    title: 'Individual',
                    duration: '20 mint',
                    image: 'assets/images/activities/meditation_individual.png',
                    isDarkMode: isDarkMode,
                  ),
                ),
                const SizedBox(height: 16),

                // Partner Category Card
                _CategoryCard(
                  title: 'Partner',
                  duration: '25 mint',
                  image: 'assets/images/activities/meditation_group.png',
                  isDarkMode: isDarkMode,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _MotivationalCarousel extends StatefulWidget {
  const _MotivationalCarousel();

  @override
  State<_MotivationalCarousel> createState() => _MotivationalCarouselState();
}

class _MotivationalCarouselState extends State<_MotivationalCarousel> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  late Timer _autoSlideTimer;

  final List<Map<String, dynamic>> carouselItems = [
    {
      'title': 'Increase Your Flexibility, Better Life Quality',
      'subtitle': 'Discover Balance',
      'image': 'assets/images/home/flexible.jpg',
      'gradientColors': [Colors.transparent, const Color(0x99A393EB)],
    },
    {
      'title': 'Practice Together, Grow Together',
      'subtitle': 'Partner Yoga',
      'image': 'assets/images/home/partner.jpg',
      'gradientColors': [Colors.transparent, const Color(0x99A393EB)],
    },
    {
      'title': 'Find Your Perfect Space',
      'subtitle': 'Peaceful Environment',
      'image': 'assets/images/home/yoga_room.jpg',
      'gradientColors': [Colors.transparent, const Color(0x99A393EB)],
    },
  ];

  @override
  void initState() {
    super.initState();
    // Start auto-sliding timer
    _startAutoSlideTimer();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _autoSlideTimer.cancel();
    super.dispose();
  }

  void _startAutoSlideTimer() {
    // Creates a timer that triggers every 5 seconds
    _autoSlideTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (_currentPage < carouselItems.length - 1) {
        _pageController.animateToPage(
          _currentPage + 1,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      } else {
        // If we're at the last page, go back to the first page
        _pageController.animateToPage(
          0,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Column(
      children: [
        Container(
          height: 220,
          width: screenWidth,
          padding: EdgeInsets.zero,
          margin: EdgeInsets.zero,
          child: PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemCount: carouselItems.length,
            physics: const BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              final item = carouselItems[index];
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  image: DecorationImage(
                    image: AssetImage(item['image']),
                    fit: BoxFit.cover,
                  ),
                  border: Border.all(
                    color:
                        const Color.fromARGB(255, 135, 106, 95), // Brown border
                    width: 4,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: item['gradientColors'],
                    ),
                  ),
                  child: Stack(
                    children: [
                      // Title at the bottom left
                      Positioned(
                        bottom: 55,
                        left: 20,
                        right: 20,
                        child: Text(
                          item['title'],
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.normal,
                            color: Colors.white,
                            fontFamily: 'Poppins',
                            shadows: [
                              Shadow(
                                offset: Offset(1, 1),
                                blurRadius: 3,
                                color: Color.fromARGB(180, 0, 0, 0),
                              ),
                            ],
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      // Ribbon for subtitle at the bottom
                      Positioned(
                        bottom: 15,
                        left: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xDDA393EB),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 20.0),
                            child: Text(
                              item['subtitle'],
                              style: const TextStyle(
                                fontSize: 19,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                                fontFamily: 'Poppins',
                                letterSpacing: 1.0,
                                shadows: [
                                  Shadow(
                                    offset: Offset(1, 1),
                                    blurRadius: 2,
                                    color: Color.fromARGB(150, 0, 0, 0),
                                  ),
                                ],
                              ),
                              textAlign: TextAlign.left,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            carouselItems.length,
            (index) => Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _currentPage == index
                    ? const Color(0xFFA393EB)
                    : const Color(0xFFA393EB).withOpacity(0.3),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _CategoryCard extends StatelessWidget {
  final String title;
  final String duration;
  final String image;
  final bool isDarkMode;

  const _CategoryCard({
    required this.title,
    required this.duration,
    required this.image,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.black12 : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: isDarkMode ? Colors.white24 : Colors.black12),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  duration,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                    color: isDarkMode ? Colors.white70 : Colors.black54,
                  ),
                ),
              ],
            ),
          ),
          Image.asset(
            image,
            height: 80,
            width: 120,
            fit: BoxFit.contain,
          ),
        ],
      ),
    );
  }
}

class _BottomNavItem extends StatelessWidget {
  final IconData icon;
  final bool isSelected;
  final bool isDarkMode;
  final VoidCallback onTap;

  const _BottomNavItem({
    required this.icon,
    this.isSelected = false,
    required this.isDarkMode,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Icon(
        icon,
        color: isSelected
            ? (isDarkMode ? Colors.white : Colors.black)
            : (isDarkMode ? Colors.white54 : Colors.black54),
        size: 28,
      ),
    );
  }
}
