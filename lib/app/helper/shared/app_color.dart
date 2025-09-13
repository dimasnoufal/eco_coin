import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColor {
  // Primary color
  static const kPrimaryColor = Color(0xFF22C55E);

  // Secondary color
  static const kMint = Color(0xFF34D399);
  static const kTeal = Color(0xFF10B981);
  static const kBlueInfo = Color(0xFF0EA5E9);
  static const kWhite = Color(0xFFFFFFFF);
  static const kSoftBlack = Color(0xFF1F2937);
  static const kGrey = Color(0xFF9CA3AF);
  static const kGrey2 = Color(0xFFE5E7EB);

  // Status color
  static const kInfoColor = kBlueInfo;
  static const kSuccessColor = Color(0xFF22C55E);
  static const kWarningColor = Color(0xFFF59E0B);
  static const kErrorColor = Color(0xFFEF4444);

  // Backgrounds color
  static const kPage = Color(0xFFF9FAFB);
  static const kInfoBoxColor = Color(0xFFEFF6FF);

  // Gradients color
  static const kEmeraldGradient = [Color(0xFF22C55E), Color(0xFF34D399)];

  static const kMintAquaGradient = [Color(0xFF34D399), Color(0xFFA7F3D0)];

  static const kTealSoftGradient = [Color(0xFF10B981), Color(0xFFCCFBEF)];

  static const kDividerGradient = [Color(0xFFF3F4F6), Color(0xFFFFFFFF)];

  static const kBottomGradient = [Color(0xFF0F172A), Color(0xFF0EA5E9)];

  // Text Colors
  static const kTextBlack = kSoftBlack;
  static const kTextWhite = kWhite;

  static TextStyle blackTextStyle = GoogleFonts.inter(color: kTextBlack);
  static TextStyle whiteTextStyle = GoogleFonts.inter(color: kTextWhite);
  static TextStyle greyTextStyle = GoogleFonts.inter(color: kGrey);

  static TextStyle get regular =>
      GoogleFonts.inter(fontWeight: FontWeight.w400);
  static TextStyle get medium => GoogleFonts.inter(fontWeight: FontWeight.w500);
  static TextStyle get semibold =>
      GoogleFonts.inter(fontWeight: FontWeight.w600);
  static TextStyle get bold => GoogleFonts.inter(fontWeight: FontWeight.w700);

  // ThemeData (Light)
  static ThemeData mainScheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    scaffoldBackgroundColor: kPage,
    colorScheme: const ColorScheme.light(
      primary: kPrimaryColor,
      secondary: kTeal,
      surface: kWhite,
      error: kErrorColor,
      onPrimary: kWhite,
      onSecondary: kWhite,
      onSurface: kTextBlack,
      onError: kWhite,
    ),
    textTheme: GoogleFonts.interTextTheme(ThemeData.light().textTheme),
    appBarTheme: AppBarTheme(
      backgroundColor: kWhite,
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      titleTextStyle: GoogleFonts.inter(
        color: kTextBlack,
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
      iconTheme: const IconThemeData(color: kTextBlack),
    ),
    dividerColor: kGrey2,
    cardColor: kWhite,
  );

  // ThemeData (Dark)
  static ThemeData darkScheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: Color(0xFF0B1220),
    colorScheme: const ColorScheme.dark(
      primary: kPrimaryColor,
      secondary: kTeal,
      surface: Color(0xFF111827),
      error: kErrorColor,
      onPrimary: kWhite,
      onSecondary: kWhite,
      onSurface: kWhite,
      onError: kWhite,
    ),
    textTheme: GoogleFonts.interTextTheme(ThemeData.dark().textTheme),
    appBarTheme: AppBarTheme(
      backgroundColor: Color(0xFF111827),
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      titleTextStyle: GoogleFonts.inter(
        color: kWhite,
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
      iconTheme: const IconThemeData(color: kWhite),
    ),
    dividerColor: const Color(0xFF1F2937),
    cardColor: const Color(0xFF111827),
  );
}
