import 'package:flutter/material.dart';

class AppTheme {
  // 🎨 Paleta de cores principal
  static const Color primaryColor = Color(0xFF1565C0); // Azul principal
  static const Color secondaryColor = Color(0xFFFF9800); // Laranja
  static const Color backgroundColor = Color(0xFFF5F5F5); // Cinza claro
  static const Color textPrimary = Color(0xFF212121); // Texto padrão
  static const Color textSecondary = Color(0xFF757575); // Texto secundário
  static const Color cardColor = Colors.white;

  // 🌈 Esquema de cores
  static final ColorScheme colorScheme = ColorScheme.fromSeed(
    seedColor: primaryColor,
    primary: primaryColor,
    secondary: secondaryColor,
    background: backgroundColor,
    surface: cardColor,
  );

  // 🖋️ Estilos de texto
  static const TextTheme textTheme = TextTheme(
    headlineLarge: TextStyle(
      fontSize: 26,
      fontWeight: FontWeight.bold,
      color: textPrimary,
    ),
    headlineMedium: TextStyle(
      fontSize: 22,
      fontWeight: FontWeight.w600,
      color: textPrimary,
    ),
    bodyLarge: TextStyle(
      fontSize: 18,
      color: textPrimary,
    ),
    bodyMedium: TextStyle(
      fontSize: 16,
      color: textSecondary,
    ),
    labelLarge: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.bold,
      color: Colors.white,
    ),
  );

  // 🧱 Estilo de botões e inputs
  static final ElevatedButtonThemeData elevatedButtonTheme =
  ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: primaryColor,
      foregroundColor: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      elevation: 3,
    ),
  );

  static final InputDecorationTheme inputDecorationTheme = InputDecorationTheme(
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: primaryColor, width: 1.5),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: secondaryColor, width: 2),
    ),
    labelStyle: const TextStyle(color: textSecondary, fontSize: 16),
    hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
  );

  // 🪄 Tema principal
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: backgroundColor,
      cardColor: cardColor,
      textTheme: textTheme,
      elevatedButtonTheme: elevatedButtonTheme,
      inputDecorationTheme: inputDecorationTheme,
      appBarTheme: const AppBarTheme(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 2,
        centerTitle: true,
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
      ),
    );
  }
}
