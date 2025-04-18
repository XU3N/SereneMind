import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/theme_controller.dart';
import '../services/audio_player_service.dart';
import 'music_selection_page.dart';

class AudioSettingsPage extends StatefulWidget {
  const AudioSettingsPage({super.key});

  @override
  State<AudioSettingsPage> createState() => _AudioSettingsPageState();
}

class _AudioSettingsPageState extends State<AudioSettingsPage> {
  bool _musicEnabled = true;
  bool _instructionEnabled = true;
  bool _lowerThirdPartyMusic = false;
  double _musicVolume = 0.7;
  double _instructionVolume = 0.8;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  void _loadSettings() {
    // In a real app, these would be loaded from shared preferences or other storage
    final audioService =
        Provider.of<AudioPlayerService>(context, listen: false);
    setState(() {
      _musicEnabled = audioService.isMusicEnabled;
      _instructionEnabled = audioService.isInstructionEnabled;
      _musicVolume = audioService.musicVolume;
      _instructionVolume = audioService.instructionVolume;
      _lowerThirdPartyMusic = audioService.lowerThirdPartyMusic;
    });
  }

  void _navigateToMusicSelection() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const MusicSelectionPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final audioService = Provider.of<AudioPlayerService>(context);
    final themeController = context.watch<ThemeController>();
    final isDarkMode = themeController.isDarkMode;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF5F5F5),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Audio Settings',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w600,
            fontFamily: 'Poppins',
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Music Section
              _buildSettingsCard(
                title: 'Music',
                child: Column(
                  children: [
                    // Music Toggle
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Music',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                            fontFamily: 'Poppins',
                          ),
                        ),
                        Switch(
                          value: _musicEnabled,
                          onChanged: (value) {
                            setState(() {
                              _musicEnabled = value;
                              audioService.isMusicEnabled = value;
                            });
                          },
                          activeColor: Colors.black,
                        ),
                      ],
                    ),
                    const Divider(),

                    // Music Volume Slider
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Row(
                        children: [
                          const Icon(Icons.volume_off, color: Colors.grey),
                          Expanded(
                            child: Slider(
                              value: _musicVolume,
                              min: 0.0,
                              max: 1.0,
                              activeColor: const Color(0xFF26A69A),
                              inactiveColor: Colors.grey.shade300,
                              onChanged: _musicEnabled
                                  ? (value) {
                                      setState(() {
                                        _musicVolume = value;
                                        audioService.setMusicVolume(value);
                                      });
                                    }
                                  : null,
                            ),
                          ),
                          const Icon(Icons.volume_up, color: Colors.grey),
                        ],
                      ),
                    ),
                    const Divider(),

                    // Music Selection
                    InkWell(
                      onTap: _musicEnabled ? _navigateToMusicSelection : null,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12.0),
                        child: Row(
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: Colors.blue.shade100,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(
                                Icons.music_note,
                                color: Color(0xFF26A69A),
                              ),
                            ),
                            const SizedBox(width: 12),
                            const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '7M Music',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black,
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                              ],
                            ),
                            const Spacer(),
                            Text(
                              'Shuffle',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey.shade600,
                                fontFamily: 'Poppins',
                              ),
                            ),
                            const Icon(
                              Icons.chevron_right,
                              color: Colors.grey,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Instruction Section
              _buildSettingsCard(
                title: 'Instruction',
                child: Column(
                  children: [
                    // Instruction Toggle
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Instruction',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                            fontFamily: 'Poppins',
                          ),
                        ),
                        Switch(
                          value: _instructionEnabled,
                          onChanged: (value) {
                            setState(() {
                              _instructionEnabled = value;
                              audioService.isInstructionEnabled = value;
                            });
                          },
                          activeColor: Colors.black,
                        ),
                      ],
                    ),
                    const Divider(),

                    // Instruction Volume Slider
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Row(
                        children: [
                          const Icon(Icons.volume_off, color: Colors.grey),
                          Expanded(
                            child: Slider(
                              value: _instructionVolume,
                              min: 0.0,
                              max: 1.0,
                              activeColor: const Color(0xFF26A69A),
                              inactiveColor: Colors.grey.shade300,
                              onChanged: _instructionEnabled
                                  ? (value) {
                                      setState(() {
                                        _instructionVolume = value;
                                        audioService
                                            .setInstructionVolume(value);
                                      });
                                    }
                                  : null,
                            ),
                          ),
                          const Icon(Icons.volume_up, color: Colors.grey),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Third Party Music Section
              _buildSettingsCard(
                title: 'Third Party Music',
                child: Column(
                  children: [
                    // Lower Third Party Music Toggle
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Lower 3rd Party Music',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                            fontFamily: 'Poppins',
                          ),
                        ),
                        Switch(
                          value: _lowerThirdPartyMusic,
                          onChanged: (value) {
                            setState(() {
                              _lowerThirdPartyMusic = value;
                              audioService.lowerThirdPartyMusic = value;
                            });
                          },
                          activeColor: Colors.black,
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              // Helper text
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  'Turn this off if you don\'t want us to lower the volume of your own music during a workout.',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                    fontFamily: 'Poppins',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSettingsCard({required String title, required Widget child}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: child,
      ),
    );
  }
}
