import 'package:flutter/material.dart';
import 'profile_edit_page.dart';

class WeightEditPage extends StatefulWidget {
  final double initialWeight; // in kg
  final Function(double) onSave;

  const WeightEditPage({
    super.key,
    required this.initialWeight,
    required this.onSave,
  });

  @override
  State<WeightEditPage> createState() => _WeightEditPageState();
}

class _WeightEditPageState extends State<WeightEditPage> {
  late double _currentWeight; // in kg
  final double _minWeight = 54.0;
  final double _maxWeight = 57.0;
  String _unit = 'kg'; // or 'lb'

  @override
  void initState() {
    super.initState();
    _currentWeight = widget.initialWeight;
  }

  // Convert kg to pounds
  double get _weightInPounds => _currentWeight * 2.20462;

  // Get displayed weight based on current unit
  String get _displayedWeight {
    if (_unit == 'kg') {
      return '${_currentWeight.toStringAsFixed(1)}';
    } else {
      return '${_weightInPounds.toStringAsFixed(1)}';
    }
  }

  @override
  Widget build(BuildContext context) {
    return EditProfilePage(
      title: 'What\'s your weight?',
      onSave: () {
        widget.onSave(_currentWeight);
        Navigator.pop(context);
      },
      child: Column(
        children: [
          // Display selected weight
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                _displayedWeight,
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
              _buildUnitSelector('lb'),
              const SizedBox(width: 16),
              _buildUnitSelector('kg'),
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
                  value: _currentWeight,
                  min: _minWeight,
                  max: _maxWeight,
                  divisions: ((_maxWeight - _minWeight) * 10)
                      .toInt(), // Allow for 0.1 increments
                  onChanged: (value) {
                    setState(() {
                      _currentWeight = value;
                    });
                  },
                ),
                // Weight labels
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _unit == 'kg'
                            ? '$_minWeight'
                            : '${(_minWeight * 2.20462).toStringAsFixed(0)}',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey[700],
                        ),
                      ),
                      Text(
                        _unit == 'kg'
                            ? '${(_currentWeight).toStringAsFixed(1)}'
                            : '${(_currentWeight * 2.20462).toStringAsFixed(1)}',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey[700],
                        ),
                      ),
                      Text(
                        _unit == 'kg'
                            ? '$_maxWeight'
                            : '${(_maxWeight * 2.20462).toStringAsFixed(0)}',
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
