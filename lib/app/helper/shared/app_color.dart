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
  static const kSuccessColor = emeraldDefault;
  static const kWarningColor = orangeDefault;
  static const kErrorColor = rubyDefault;

  // Backgrounds color
  static const kPage = Color(0xFFF9FAFB);
  static const kInfoBoxColor = Color(0xFFEFF6FF);

  // Gradients color
  static const kEmeraldGradient = [Color(0xFF22C55E), Color(0xFF34D399)];

  static const kMintAquaGradient = [Color(0xFF34D399), Color(0xFFA7F3D0)];

  static const kTealSoftGradient = [Color(0xFF10B981), Color(0xFFCCFBEF)];

  static const kDividerGradient = [Color(0xFFF3F4F6), Color(0xFFFFFFFF)];

  static const kBottomGradient = [Color(0xFF0F172A), Color(0xFF0EA5E9)];

  // Emerald Colors
  static const emeraldDefault = Color(0xFF2AC769);
  static const emeraldDark = Color(0xFF1AB759);
  static const emeraldLight = Color(0xFF40DD7F);
  static const emeraldBg = Color(0xFFACFFCD);
  static const emeraldBgLight = Color(0xFFCFFFE5);

  // Orange Colors
  static const orangeDefault = Color(0xFFF6A609);
  static const orangeDark = Color(0xFFE89806);
  static const orangeLight = Color(0xFFFFBC1F);
  static const orangeBg = Color(0xFFFFEFCA);

  // Neutral Colors
  static const neutralBlack = Color(0xFF161616);
  static const neutral80 = Color(0xFF2D2D2D);
  static const neutral60 = Color(0xFF3E3E3E);
  static const neutral50 = Color(0xFF4D4D4D);
  static const neutral40 = Color(0xFF737373);
  static const neutral30 = Color(0xFFB3B3B3);
  static const neutral20 = Color(0xFFECECEC);
  static const neutral10 = Color(0xFFF3F3F3);
  static const neutral5 = Color(0xFFF4F4F4);
  static const neutralWhite = Color(0xFFFFFFFF);

  // Ruby Colors
  static const rubyDefault = Color(0xFFFB4E4E);
  static const rubyDark = Color(0xFFE93C3C);
  static const rubyLight = Color(0xFFFF6262);
  static const rubyBg = Color(0xFFFFC1C1);
  static const rubyBgLight = Color(0xFFFFDEDE);

  // Text Colors
  static const kTextBlack = kSoftBlack;
  static const kTextWhite = kWhite;

  static TextStyle blackTextStyle = GoogleFonts.inter(color: neutralBlack);
  static TextStyle whiteTextStyle = GoogleFonts.inter(color: neutralWhite);
  static TextStyle greyTextStyle = GoogleFonts.inter(color: neutral40);

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
      primary: emeraldDefault,
      secondary: emeraldBg,
      surface: neutralWhite,
      error: kErrorColor,
      onPrimary: neutralWhite,
      onSecondary: neutralWhite,
      onSurface: neutralBlack,
      onError: neutralWhite,
    ),
    textTheme: GoogleFonts.interTextTheme(ThemeData.light().textTheme),
    appBarTheme: AppBarTheme(
      backgroundColor: neutralWhite,
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      titleTextStyle: GoogleFonts.inter(
        color: neutralBlack,
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
      iconTheme: const IconThemeData(color: neutralBlack),
    ),
    dividerColor: kGrey2,
    cardColor: neutralWhite,
  );

  // ThemeData (Dark)
  static ThemeData darkScheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: Color(0xFF0B1220),
    colorScheme: const ColorScheme.dark(
      primary: emeraldDefault,
      secondary: emeraldBg,
      surface: Color(0xFF111827),
      error: kErrorColor,
      onPrimary: neutralWhite,
      onSecondary: neutralWhite,
      onSurface: neutralWhite,
      onError: neutralWhite,
    ),
    textTheme: GoogleFonts.interTextTheme(ThemeData.dark().textTheme),
    appBarTheme: AppBarTheme(
      backgroundColor: Color(0xFF111827),
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      titleTextStyle: GoogleFonts.inter(
        color: neutralWhite,
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
      iconTheme: const IconThemeData(color: neutralWhite),
    ),
    dividerColor: const Color(0xFF1F2937),
    cardColor: const Color(0xFF111827),
  );
}
