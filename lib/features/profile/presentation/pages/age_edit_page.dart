import 'package:flutter/material.dart';
import 'profile_edit_page.dart';

class AgeEditPage extends StatefulWidget {
  final int initialAge;
  final Function(int) onSave;

  const AgeEditPage({
    super.key,
    required this.initialAge,
    required this.onSave,
  });

  @override
  State<AgeEditPage> createState() => _AgeEditPageState();
}

class _AgeEditPageState extends State<AgeEditPage> {
  late double _currentAge;
  final double _minAge = 10;
  final double _maxAge = 30;

  @override
  void initState() {
    super.initState();
    _currentAge = widget.initialAge.toDouble();
  }

  @override
  Widget build(BuildContext context) {
    return EditProfilePage(
      title: 'What\'s your age?',
      onSave: () {
        widget.onSave(_currentAge.round());
        Navigator.pop(context);
      },
      child: Column(
        children: [
          // Display selected age
          Center(
            child: Text(
              '${_currentAge.round()}',
              style: const TextStyle(
                fontSize: 96,
                fontWeight: FontWeight.bold,
                color: Colors.black,
                fontFamily: 'Poppins',
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Privacy message
          Container(
            width: double.infinity,
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
              'Your privacy matters. We only use this information to calculate your BMR and personalize the experience',
              style: TextStyle(
                fontSize: 16,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.normal,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
          ),

          const SizedBox(height: 32),

          // Slider
          SliderTheme(
            data: SliderThemeData(
              thumbColor: Colors.black,
              activeTrackColor: Colors.black,
              inactiveTrackColor: Colors.grey[300],
              trackHeight: 2.0,
              thumbShape: _CustomSliderThumbShape(),
              overlayColor: Colors.black.withOpacity(0.1),
              tickMarkShape:
                  const RoundSliderTickMarkShape(tickMarkRadius: 1.0),
              activeTickMarkColor: Colors.black,
              inactiveTickMarkColor: Colors.grey[400],
            ),
            child: Column(
              children: [
                Slider(
                  value: _currentAge,
                  min: _minAge,
                  max: _maxAge,
                  divisions: (_maxAge - _minAge).toInt(),
                  onChanged: (value) {
                    setState(() {
                      _currentAge = value;
                    });
                  },
                ),
                // Age labels
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${_minAge.toInt()}',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey[700],
                        ),
                      ),
                      Text(
                        '${_currentAge.round()}',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey[700],
                        ),
                      ),
                      Text(
                        '${_maxAge.toInt()}',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey[700],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CustomSliderThumbShape extends SliderComponentShape {
  static const double _thumbRadius = 10.0;
  static const double _thumbBorderWidth = 2.0;

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return const Size.fromRadius(_thumbRadius + _thumbBorderWidth);
  }

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    required bool isDiscrete,
    required TextPainter labelPainter,
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required TextDirection textDirection,
    required double value,
    required double textScaleFactor,
    required Size sizeWithOverflow,
  }) {
    final Canvas canvas = context.canvas;

    // Draw the black triangle
    final Path path = Path()
      ..moveTo(center.dx, center.dy - 12)
      ..lineTo(center.dx - 8, center.dy)
      ..lineTo(center.dx + 8, center.dy)
      ..close();

    final Paint fillPaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.fill;

    canvas.drawPath(path, fillPaint);
  }
}
