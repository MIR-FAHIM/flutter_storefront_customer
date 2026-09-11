import 'package:flutter/material.dart';

class AppColors {
  // ---------------------------------------------------------------------------
  // Brand Core Colors from PDF Theme
  // ---------------------------------------------------------------------------

  static final primaryColor = HexColor("#00007c");
  static final primaryDarkColor = HexColor("#151738");
  static final primaryNavyColor = HexColor("#2B2C6C");
  static final primaryLightColor = HexColor("#BDEFEE");

  // ---------------------------------------------------------------------------
  // Background Colors
  // ---------------------------------------------------------------------------

  static final backgroundColor = HexColor("#FFFFFF");
  static final backgroundBlueColor = HexColor("#00007c");
  static final scaffoldBackground = HexColor("#F5F7FB");
  static final secondbackgroundColor = HexColor("#EEF4FA");
  static final thirdbackgroundColor = HexColor("#EAF2FA");

  // Product and section backgrounds
  static final featuredProductBg = HexColor("#ADCBE3");
  static final allProductBg = HexColor("#F0F0F0");
  static final cardBackground = HexColor("#FFFFFF");
  static final softCardBackground = HexColor("#F8FAFC");

  // ---------------------------------------------------------------------------
  // Text Colors
  // ---------------------------------------------------------------------------

  static final homeTextColor1 = HexColor("#151738");
  static final homeTextColor2 = HexColor("#4B5563");
  static final homeTextColor3 = HexColor("#9CA3AF");

  static final textPrimary = HexColor("#151738");
  static final textSecondary = HexColor("#4B5563");
  static final textMuted = HexColor("#9CA3AF");
  static final textWhite = HexColor("#FFFFFF");
  static final textColorBlack = HexColor("#000000");
  static final textAlt = HexColor("#6B7280");

  // ---------------------------------------------------------------------------
  // Status Colors
  // ---------------------------------------------------------------------------

  static final redTextColor = HexColor("#FF5252");
  static final greenTextColor = HexColor("#00C853");

  static final successColor = HexColor("#16A34A");
  static final warningColor = HexColor("#F59E0B");
  static final errorColor = HexColor("#EF4444");
  static final infoColor = HexColor("#2563EB");

  // ---------------------------------------------------------------------------
  // Offer, Discount and Highlight
  // ---------------------------------------------------------------------------

  static final golden = HexColor("#FFC107");
  static final offerYellow = HexColor("#FEFF00");
  static final discountBlue = HexColor("#00509D");
  static final redColor = HexColor("#B70614");

  // ---------------------------------------------------------------------------
  // Category Shortcut Colors from PDF
  // ---------------------------------------------------------------------------

  static final todayDealColor = HexColor("#DF7529");
  static final allBrandsColor = HexColor("#428789");
  static final topSellerColor = HexColor("#AD792D");
  static final flashSaleColor = HexColor("#2B2C6C");
  static final newArrivalColor = HexColor("#AF1D5B");
  static final freeDeliveryColor = HexColor("#BD4D4C");

  // ---------------------------------------------------------------------------
  // Section Colors from PDF
  // ---------------------------------------------------------------------------

  static final groceryColor = HexColor("#00509D");
  static final medicineColor = HexColor("#428789");
  static final fashionColor = HexColor("#A59E83");
  static final healthBeautyColor = HexColor("#CE8080");
  static final electronicsColor = HexColor("#754C29");
  static final babyCareColor = HexColor("#5BC0DE");
  static final petCareColor = HexColor("#795548");
  static final homeApplianceColor = HexColor("#8E7BAA");

  // Soft section backgrounds
  static Color featuredProductSoftBg = HexColor("#00509D").withOpacity(0.32);
  static Color fashionSoftBg = HexColor("#A59E83").withOpacity(0.60);
  static Color healthBeautySoftBg = HexColor("#CE8080").withOpacity(0.36);
  static Color electronicsSoftBg = HexColor("#754C29").withOpacity(0.36);

  // ---------------------------------------------------------------------------
  // Borders and Dividers
  // ---------------------------------------------------------------------------

  static final dividerColor = HexColor("#E5E7EB");
  static final borderColor = HexColor("#E5E7EB");
  static final tableRowColor = HexColor("#F8FAFC");

  // ---------------------------------------------------------------------------
  // Old variable compatibility
  // Keep these so existing pages do not break immediately
  // ---------------------------------------------------------------------------

  static final homeCardBg = HexColor("#FFFFFF");
  static final SectionCardBg = HexColor("#F8FAFC");
  static final SectionHighLightCardBg = HexColor("#EAF2FA");

  static final primarydeepLightColor = HexColor("#FEFF00");

  static final gradientOne = HexColor("#00509D");
  static final gradientTwo = HexColor("#2563EB");

  static final softPink = HexColor("#F8DADA");
  static final softBrwn = HexColor("#754C29");
}

class HexColor extends Color {
  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");

    if (hexColor.length == 6) {
      hexColor = "FF$hexColor";
    }

    return int.parse(hexColor, radix: 16);
  }

  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
}