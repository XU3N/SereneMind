import 'package:flutter/material.dart';
import 'profile_edit_page.dart';

class HeightEditPage extends StatefulWidget {
  final int initialHeight; // in cm
  final Function(int) onSave;

  const HeightEditPage({
    super.key,
    required this.initialHeight,
    required this.onSave,
  });

  @override
  State<HeightEditPage> createState() => _HeightEditPageState();
}

class _HeightEditPageState extends State<HeightEditPage> {
  late double _currentHeight; // in cm
  final double _minHeight = 160;
  final double _maxHeight = 190;
  String _unit = 'cm'; // or 'in'

  @override
  void initState() {
    super.initState();
    _currentHeight = widget.initialHeight.toDouble();
  }

  // Convert cm to inches
  double get _heightInInches => _currentHeight / 2.54;

  // Get displayed height based on current unit
  String get _displayedHeight {
    if (_unit == 'cm') {
      return '${_currentHeight.round()}';
    } else {
      return '${_heightInInches.toStringAsFixed(1)}';
    }
  }

  @override
  Widget build(BuildContext context) {
    return EditProfilePage(
      title: 'What\'s your height?',
      onSave: () {
        widget.onSave(_currentHeight.round());
        Navigator.pop(context);
      },
      child: Column(
        children: [
          // Display selected height
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                _displayedHeight,
                style: const TextStyle(
                  fontSize: 96,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontFamily: 'Poppins',
                ),
              ),
              Text(
                _unit,
                style: const TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.normal,
                  color: Colors.black,
                  fontFamily: 'Poppins',
                ),
              ),
            ],
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

          // Unit selector
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildUnitSelector('in'),
              const SizedBox(width: 16),
              _buildUnitSelector('cm'),
            ],
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
                  value: _currentHeight,
                  min: _minHeight,
                  max: _maxHeight,
                  divisions: (_maxHeight - _minHeight).toInt(),
                  onChanged: (value) {
                    setState(() {
                      _currentHeight = value;
                    });
                  },
                ),
                // Height labels
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _unit == 'cm'
                            ? '${_minHeight.toInt()}'
                            : '${(_minHeight / 2.54).toStringAsFixed(0)}',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey[700],
                        ),
                      ),
                      Text(
                        _unit == 'cm'
                            ? '${(_minHeight + (_maxHeight - _minHeight) / 2).toInt()}'
                            : '${((_minHeight + (_maxHeight - _minHeight) / 2) / 2.54).toStringAsFixed(0)}',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey[700],
                        ),
                      ),
                      Text(
                        _unit == 'cm'
                            ? '${_maxHeight.toInt()}'
                            : '${(_maxHeight / 2.54).toStringAsFixed(0)}',
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

  Widget _buildUnitSelector(String unit) {
    final isSelected = _unit == unit;

    return GestureDetector(
      onTap: () {
        setState(() {
          _unit = unit;
        });
      },
      child: Container(
        width: 80,
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.grey[200],
          borderRadius: BorderRadius.circular(24),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Center(
          child: Text(
            unit,
            style: TextStyle(
              fontSize: 16,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              color: Colors.black,
            ),
          ),
        ),
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
