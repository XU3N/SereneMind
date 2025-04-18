import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/theme/theme_controller.dart';
import '../../../../core/widgets/gradient_background_scaffold.dart';
import '../../../auth/presentation/pages/sign_in_page.dart';
import '../../../auth/data/repositories/firebase_auth_repository.dart';

import 'name_edit_page.dart';
import 'gender_edit_page.dart';
import 'age_edit_page.dart';
import 'height_edit_page.dart';
import 'weight_edit_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // Initialize with default values
  String _name = 'Sarah Johnson';
  String _gender = 'Female';
  int _age = 21;
  double _height = 172; // in cm
  double _weight = 55.7; // in kg
  bool _isLoading = true;

  // Firebase auth repository
  final _authRepository = FirebaseAuthRepository();
  // Firestore instance
  final _firestore = FirebaseFirestore.instance;
  late String _userEmail;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  // Load user data from Firestore
  Future<void> _loadUserData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final user = _authRepository.getCurrentUser();
      if (user != null && user.email != null) {
        _userEmail = user.email!;

        // Fetch user data from Firestore
        final docSnapshot =
            await _firestore.collection('users').doc(_userEmail).get();

        if (docSnapshot.exists) {
          final userData = docSnapshot.data();
          if (userData != null) {
            setState(() {
              _name = userData['name'] ?? _name;
              _gender = userData['gender'] ?? _gender;
              _age = userData['age'] ?? _age;
              _height = (userData['height'] ?? _height).toDouble();
              _weight = (userData['weight'] ?? _weight).toDouble();
            });
          }
        } else {
          // If document doesn't exist, create it with default values
          await _saveUserData();
        }
      }
    } catch (e) {
      debugPrint('Error loading user data: ${e.toString()}');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to load profile data: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Save user data to Firestore
  Future<void> _saveUserData() async {
    try {
      final user = _authRepository.getCurrentUser();
      if (user != null && user.email != null) {
        await _firestore.collection('users').doc(user.email).set({
          'name': _name,
          'gender': _gender,
          'age': _age,
          'height': _height,
          'weight': _weight,
          'email': user.email,
          'updatedAt': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));
      }
    } catch (e) {
      debugPrint('Error saving user data: ${e.toString()}');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to save profile data: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // Sign out the user
  Future<void> _signOut() async {
    try {
      await _authRepository.signOut();
      if (mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => const SignInPage(),
          ),
          (route) => false,
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error signing out: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // Navigate to name edit page
  void _navigateToNameEdit() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NameEditPage(
          initialName: _name,
          onSave: (String newName) async {
            setState(() {
              _name = newName;
            });
            await _saveUserData();
          },
        ),
      ),
    );
  }

  // Navigate to gender edit page
  void _navigateToGenderEdit() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GenderEditPage(
          initialGender: _gender,
          onSave: (String newGender) async {
            setState(() {
              _gender = newGender;
            });
            await _saveUserData();
          },
        ),
      ),
    );
  }

  // Navigate to age edit page
  void _navigateToAgeEdit() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AgeEditPage(
          initialAge: _age,
          onSave: (int newAge) async {
            setState(() {
              _age = newAge;
            });
            await _saveUserData();
          },
        ),
      ),
    );
  }

  // Navigate to height edit page
  void _navigateToHeightEdit() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HeightEditPage(
          initialHeight: _height.toInt(),
          onSave: (int newHeight) async {
            setState(() {
              _height = newHeight.toDouble();
            });
            await _saveUserData();
          },
        ),
      ),
    );
  }

  // Navigate to weight edit page
  void _navigateToWeightEdit() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => WeightEditPage(
          initialWeight: _weight,
          onSave: (double newWeight) async {
            setState(() {
              _weight = newWeight;
            });
            await _saveUserData();
          },
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
        title: Text(
          'Profile',
          style: TextStyle(
            color: isDarkMode ? Colors.white : Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      child: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              child: Column(
                children: [
                  // User Information Card
                  _buildProfileCard(
                    context,
                    isDarkMode,
                    [
                      _buildProfileItem(
                        context,
                        'Name',
                        _name,
                        isDarkMode,
                        onTap: _navigateToNameEdit,
                      ),
                      _buildProfileItem(
                        context,
                        'Gender',
                        _gender,
                        isDarkMode,
                        onTap: _navigateToGenderEdit,
                      ),
                      _buildProfileItem(
                        context,
                        'Age',
                        '$_age years',
                        isDarkMode,
                        onTap: _navigateToAgeEdit,
                      ),
                      _buildProfileItem(
                        context,
                        'Height',
                        '${_height.toStringAsFixed(0)} cm',
                        isDarkMode,
                        onTap: _navigateToHeightEdit,
                      ),
                      _buildProfileItem(
                        context,
                        'Weight',
                        '${_weight.toStringAsFixed(1)} kg',
                        isDarkMode,
                        onTap: _navigateToWeightEdit,
                        isLast: true,
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Manage Shortcuts Card
                  _buildProfileCard(
                    context,
                    isDarkMode,
                    [
                      _buildProfileItem(
                        context,
                        'Manage Shortcuts',
                        '',
                        isDarkMode,
                        onTap: () {/* Navigate to shortcuts management */},
                        isLast: true,
                        showChevron: true,
                      ),
                    ],
                  ),

                  const SizedBox(height: 30),

                  // Sign Out Button
                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.symmetric(vertical: 20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: TextButton(
                      onPressed: _signOut,
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: const Text(
                        'Sign Out',
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: 'Poppins',
                          color: Colors.blue,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),

                  // Remove Personal Data Button
                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.symmetric(vertical: 20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: TextButton(
                      onPressed: () {
                        // Show confirmation dialog before deleting data
                        _showDeleteConfirmationDialog(context, isDarkMode);
                      },
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: const Text(
                        'Remove Personal Data',
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: 'Poppins',
                          color: Color(0xFFE57373), // Light red color
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildProfileCard(
      BuildContext context, bool isDarkMode, List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: children,
      ),
    );
  }

  Widget _buildProfileItem(
    BuildContext context,
    String title,
    String value,
    bool isDarkMode, {
    VoidCallback? onTap,
    bool isLast = false,
    bool showChevron = false,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          border: isLast
              ? null
              : Border(
                  bottom: BorderSide(
                    color: Colors.grey.withOpacity(0.2),
                    width: 1,
                  ),
                ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
            Row(
              children: [
                if (value.isNotEmpty)
                  Text(
                    value,
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w400,
                      color: Colors.grey[500],
                    ),
                  ),
                const SizedBox(width: 4),
                Icon(
                  Icons.chevron_right,
                  color: Colors.grey[400],
                  size: 20,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showDeleteConfirmationDialog(
      BuildContext context, bool isDarkMode) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Remove Personal Data'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                    'Are you sure you want to remove all your personal data? This action cannot be undone.'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text(
                'Remove',
                style: TextStyle(color: Color(0xFFE57373)),
              ),
              onPressed: () async {
                // Delete user data
                try {
                  final user = _authRepository.getCurrentUser();
                  if (user != null && user.email != null) {
                    await _firestore
                        .collection('users')
                        .doc(user.email)
                        .delete();

                    if (mounted) {
                      setState(() {
                        _name = 'Sarah Johnson';
                        _gender = 'Female';
                        _age = 21;
                        _height = 172;
                        _weight = 55.7;
                      });

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Personal data removed successfully'),
                          backgroundColor: Colors.green,
                        ),
                      );
                    }
                  }
                } catch (e) {
                  debugPrint('Error deleting user data: ${e.toString()}');
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Failed to remove data: ${e.toString()}'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                }

                if (mounted) {
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }
}
