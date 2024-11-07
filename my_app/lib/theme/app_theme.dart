import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppTheme {
  static const Color primaryColor = Color(0xFF2E7D32); // Dark Green
  static const Color glassWhite = Color(0xFFFFFFFF);
  static const Color glassStroke = Color(0x1AFFFFFF);
  static const Color glassShadow = Color(0x3A000000);

  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: primaryColor,
      primary: primaryColor,
      secondary: const Color(0xFF66BB6A),
      tertiary: const Color(0xFF81C784),
      surface: glassWhite.withOpacity(0.8),
      background: Colors.grey[100]!,
    ),
    
    // Glassmorphism App Bar
    appBarTheme: AppBarTheme(
      systemOverlayStyle: SystemUiOverlayStyle.dark,
      backgroundColor: glassWhite.withOpacity(0.8),
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: true,
      titleTextStyle: const TextStyle(
        color: Colors.black87,
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
      iconTheme: const IconThemeData(color: Colors.black87),
    ),

    // Scaffold Background
    scaffoldBackgroundColor: Colors.grey[100],

    // Glassmorphism Card
    cardTheme: CardTheme(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: glassStroke.withOpacity(0.1)),
      ),
      color: glassWhite.withOpacity(0.7),
      surfaceTintColor: Colors.transparent,
      shadowColor: glassShadow.withOpacity(0.1),
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    ),

    // Floating Action Button with Glass Effect
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: glassWhite.withOpacity(0.9),
      foregroundColor: primaryColor,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: glassStroke.withOpacity(0.2)),
      ),
    ),

    // Elevated Button with Glass Effect
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: glassWhite.withOpacity(0.8),
        foregroundColor: primaryColor,
        elevation: 0,
        shadowColor: Colors.transparent,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: glassStroke.withOpacity(0.2)),
        ),
      ),
    ),

    // Outlined Button with Glass Effect
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: primaryColor,
        backgroundColor: glassWhite.withOpacity(0.5),
        side: BorderSide(color: primaryColor.withOpacity(0.2)),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    ),

    // Text Button with Glass Effect
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: primaryColor,
        backgroundColor: Colors.transparent,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
    ),

    // Input Decoration with Glass Effect
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: glassWhite.withOpacity(0.7),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: glassStroke.withOpacity(0.2)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: glassStroke.withOpacity(0.1)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: primaryColor.withOpacity(0.5)),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      prefixIconColor: primaryColor.withOpacity(0.7),
      suffixIconColor: primaryColor.withOpacity(0.7),
    ),

    // Bottom Navigation Bar with Glass Effect
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: glassWhite.withOpacity(0.8),
      selectedItemColor: primaryColor,
      unselectedItemColor: Colors.grey[600],
      type: BottomNavigationBarType.fixed,
      elevation: 0,
      landscapeLayout: BottomNavigationBarLandscapeLayout.centered,
    ),

    // Tab Bar with Glass Effect
    tabBarTheme: TabBarTheme(
      labelColor: primaryColor,
      unselectedLabelColor: Colors.grey[600],
      indicatorColor: primaryColor,
      indicatorSize: TabBarIndicatorSize.label,
      dividerColor: Colors.transparent,
    ),

    // Chip Theme with Glass Effect
    chipTheme: ChipThemeData(
      backgroundColor: glassWhite.withOpacity(0.7),
      selectedColor: primaryColor.withOpacity(0.2),
      labelStyle: TextStyle(color: primaryColor),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: glassStroke.withOpacity(0.2)),
      ),
    ),

    // Dialog Theme with Glass Effect
    dialogTheme: DialogTheme(
      backgroundColor: glassWhite.withOpacity(0.9),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: glassStroke.withOpacity(0.2)),
      ),
    ),

    // Bottom Sheet Theme with Glass Effect
    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: glassWhite.withOpacity(0.9),
      elevation: 0,
      modalElevation: 0,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
    ),

    // Divider Theme
    dividerTheme: DividerThemeData(
      color: glassStroke.withOpacity(0.1),
      thickness: 1,
      space: 1,
    ),

    // List Tile Theme with Glass Effect
    listTileTheme: ListTileThemeData(
      tileColor: Colors.transparent,
      selectedTileColor: primaryColor.withOpacity(0.1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),

    // Popup Menu Theme with Glass Effect
    popupMenuTheme: PopupMenuThemeData(
      color: glassWhite.withOpacity(0.9),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: glassStroke.withOpacity(0.2)),
      ),
    ),

    // Snack Bar Theme with Glass Effect
    snackBarTheme: SnackBarThemeData(
      backgroundColor: glassWhite.withOpacity(0.9),
      contentTextStyle: const TextStyle(color: Colors.black87),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: glassStroke.withOpacity(0.2)),
      ),
      behavior: SnackBarBehavior.floating,
    ),
  );

  // Helper method to create glass effect container
  static BoxDecoration glassDecoration({
    double opacity = 0.7,
    double borderOpacity = 0.2,
    double radius = 16,
  }) {
    return BoxDecoration(
      color: glassWhite.withOpacity(opacity),
      borderRadius: BorderRadius.circular(radius),
      border: Border.all(
        color: glassStroke.withOpacity(borderOpacity),
        width: 1,
      ),
      boxShadow: [
        BoxShadow(
          color: glassShadow.withOpacity(0.1),
          blurRadius: 10,
          spreadRadius: 0,
        ),
      ],
    );
  }
} 