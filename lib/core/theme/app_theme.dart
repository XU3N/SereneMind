import 'package:flutter/material.dart';

class AppTheme {
  // Colors
  static const Color primaryColor = Color(0xFF65B741);
  static const Color secondaryColor = Color(0xFFC5ADE3);
  static const Color buttonColor = Color(0xFF1B4965);
  static const Color buttonTextColor = Colors.white;

  // Gradient Colors
  static const Color backgroundGradientStart = Color(0xFF0A2472);
  static const Color backgroundGradientMidDark = Color(0xFF1B4965);
  static const Color backgroundGradientMid = Color(0xFF2E6B8D);
  static const Color backgroundGradientMidLight = Color(0xFF5FA8B5);
  static const Color backgroundGradientEnd = Color(0xFFBEE9E8);

  // Dark Theme Gradient
  static const LinearGradient darkThemeGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      backgroundGradientStart,
      backgroundGradientMidDark,
      backgroundGradientEnd,
    ],
  );

  // Light Theme
  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    primaryColor: primaryColor,
    textTheme: const TextTheme(
      headlineLarge: TextStyle(
        fontSize: 48,
        fontWeight: FontWeight.w800,
        color: Colors.white,
        fontFamily: 'Poppins',
      ),
      headlineMedium: TextStyle(
        fontSize: 36,
        fontWeight: FontWeight.w800,
        color: Colors.white,
        fontFamily: 'Poppins',
      ),
      headlineSmall: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w800,
        color: Colors.white,
        fontFamily: 'Poppins',
      ),
      bodyLarge: TextStyle(
        fontSize: 18,
        color: Colors.white,
        fontFamily: 'Poppins',
      ),
      bodyMedium: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w800,
        color: Colors.white,
        fontFamily: 'Poppins',
      ),
      bodySmall: TextStyle(
        fontSize: 14,
        color: Colors.white,
        fontFamily: 'Poppins',
      ),
    ),
  );

  // Dark Theme
  static final ThemeData darkTheme = ThemeData.dark().copyWith(
    useMaterial3: true,
    primaryColor: primaryColor,
    textTheme: const TextTheme(
      headlineLarge: TextStyle(
        fontSize: 48,
        fontWeight: FontWeight.w800,
        color: Colors.white,
        fontFamily: 'Poppins',
      ),
      headlineMedium: TextStyle(
        fontSize: 36,
        fontWeight: FontWeight.w800,
        color: Colors.white,
        fontFamily: 'Poppins',
      ),
      headlineSmall: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w800,
        color: Colors.white,
        fontFamily: 'Poppins',
      ),
      bodyLarge: TextStyle(
        fontSize: 18,
        color: Colors.white,
        fontFamily: 'Poppins',
      ),
      bodyMedium: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w800,
        color: Colors.white,
        fontFamily: 'Poppins',
      ),
      bodySmall: TextStyle(
        fontSize: 14,
        color: Colors.white,
        fontFamily: 'Poppins',
      ),
    ),
    scaffoldBackgroundColor: Colors.transparent,
    canvasColor: Colors.transparent,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
    ),
    extensions: [
      const CustomThemeExtension(
        scaffoldGradient: darkThemeGradient,
      ),
    ],
  );
}

// Custom Theme Extension to handle gradient background
class CustomThemeExtension extends ThemeExtension<CustomThemeExtension> {
  final LinearGradient? scaffoldGradient;

  const CustomThemeExtension({
    this.scaffoldGradient,
  });

  @override
  ThemeExtension<CustomThemeExtension> copyWith({
    LinearGradient? scaffoldGradient,
  }) {
    return CustomThemeExtension(
      scaffoldGradient: scaffoldGradient ?? this.scaffoldGradient,
    );
  }

  @override
  ThemeExtension<CustomThemeExtension> lerp(
    covariant ThemeExtension<CustomThemeExtension>? other,
    double t,
  ) {
    if (other is! CustomThemeExtension) {
      return this;
    }
    return CustomThemeExtension(
      scaffoldGradient:
          LinearGradient.lerp(scaffoldGradient, other.scaffoldGradient, t),
    );
  }
}
