import 'package:flutter/material.dart';
import 'profile_edit_page.dart';

class GenderEditPage extends StatefulWidget {
  final String initialGender;
  final Function(String) onSave;

  const GenderEditPage({
    super.key,
    required this.initialGender,
    required this.onSave,
  });

  @override
  State<GenderEditPage> createState() => _GenderEditPageState();
}

class _GenderEditPageState extends State<GenderEditPage> {
  late String _selectedGender;

  @override
  void initState() {
    super.initState();
    _selectedGender = widget.initialGender;
  }

  @override
  Widget build(BuildContext context) {
    return EditProfilePage(
      title: 'What\'s your gender?',
      onSave: () {
        widget.onSave(_selectedGender);
        Navigator.pop(context);
      },
      child: Column(
        children: [
          // Gender options
          _buildGenderOption('Male', '♂️'),
          const SizedBox(height: 16),
          _buildGenderOption('Female', '♀️'),
          const SizedBox(height: 16),
          _buildGenderOption('Non-binary', '⚧️'),
        ],
      ),
    );
  }

  Widget _buildGenderOption(String gender, String icon) {
    final isSelected = _selectedGender == gender;

    return InkWell(
      onTap: () {
        setState(() {
          _selectedGender = gender;
        });
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? Colors.purple.shade200 : Colors.grey.shade200,
            width: 1,
          ),
          boxShadow: [
            if (isSelected)
              BoxShadow(
                color: Colors.purple.shade100.withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
          ],
        ),
        child: Row(
          children: [
            Text(
              icon,
              style: const TextStyle(
                fontSize: 24,
              ),
            ),
            const SizedBox(width: 16),
            Text(
              gender,
              style: const TextStyle(
                fontSize: 16,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
            const Spacer(),
            if (isSelected)
              Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.purple.shade400,
                ),
                child: const Center(
                  child: Icon(
                    Icons.check,
                    size: 14,
                    color: Colors.white,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
