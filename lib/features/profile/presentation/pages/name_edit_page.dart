import 'package:flutter/material.dart';
import 'profile_edit_page.dart';

class NameEditPage extends StatefulWidget {
  final String initialName;
  final Function(String) onSave;

  const NameEditPage({
    super.key,
    required this.initialName,
    required this.onSave,
  });

  @override
  State<NameEditPage> createState() => _NameEditPageState();
}

class _NameEditPageState extends State<NameEditPage> {
  late TextEditingController _nameController;
  final _nameFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialName);
    // Auto focus the text field
    Future.delayed(Duration.zero, () {
      _nameFocusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _nameFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return EditProfilePage(
      title: 'What should we call you?',
      onSave: () {
        widget.onSave(_nameController.text.trim());
        Navigator.pop(context);
      },
      child: Column(
        children: [
          // Large text input
          TextField(
            controller: _nameController,
            focusNode: _nameFocusNode,
            style: const TextStyle(
              fontSize: 48,
              fontWeight: FontWeight.bold,
              color: Colors.black,
              fontFamily: 'Poppins',
            ),
            decoration: const InputDecoration(
              border: InputBorder.none,
              hintText: 'Your name',
              hintStyle: TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                color: Colors.black26,
              ),
            ),
          ),

          // Purple divider
          Container(
            height: 2,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.transparent,
                  Colors.purple.shade400,
                  Colors.transparent
                ],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                stops: const [0.0, 0.5, 1.0],
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Explanation text
          Container(
            padding: const EdgeInsets.all(16),
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
            child: const Text(
              'Your name makes it personal. Don\'t worry, it\'s just between us',
              style: TextStyle(
                fontSize: 16,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.normal,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
