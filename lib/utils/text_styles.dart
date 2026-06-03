import 'package:flutter/material.dart';
import '../utils/colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

TextStyle textStyle_40Bold() {
  return GoogleFonts.encodeSans(
    fontSize: 50.sp,
    fontWeight: FontWeight.bold,
    color: const Color(0xFFB6F0FF),
    height: 1.0.h,
  );
}

TextStyle textStyle_45Bold() {
  return GoogleFonts.encodeSans(
    fontSize: 45.sp,
    fontWeight: FontWeight.bold,
    color: const Color(0xFFB6F0FF),
    height: 1.2.h,
  );
}

TextStyle textStyle_10() {
  return GoogleFonts.encodeSans(
    fontSize: 10.sp,
    color: const Color(0xFFE5E8EC),
  );
}

TextStyle textStyle_12() {
  return GoogleFonts.encodeSans(
    fontSize: 12.sp,
    fontWeight: FontWeight.w400,
    color: const Color(0xFFE5E8EC),
  );
}

TextStyle textStyle_14() {
  return GoogleFonts.encodeSans(
    fontSize: 14.sp,
    fontWeight: FontWeight.w500,
    color: const Color(0xFFE5E8EC),
  );
}

TextStyle textStyle_18() {
  return GoogleFonts.encodeSans(
    fontSize: 18.sp,
    fontWeight: FontWeight.w500,
    color: const Color(0xFFE5E8EC),
  );
}

TextStyle textStyle_20Bold() {
  return GoogleFonts.encodeSans(
    color: const Color(0xFFB6F0FF),
    fontSize: 20.sp,
    fontWeight: FontWeight.bold,
  );
}

TextStyle textStyle_25Bold() {
  return GoogleFonts.encodeSans(
    fontSize: 25.sp,
    fontWeight: FontWeight.bold,
    color: const Color(0xFFACE4FC),
    height: 1.4,
  );
}

TextStyle textStyle_13Medium() {
  return GoogleFonts.encodeSans(
    fontSize: 13.sp,
    fontWeight: FontWeight.w600,
    color: const Color(0xFFE5E8EC),
  );
}

TextStyle textStyle_13() {
  return GoogleFonts.encodeSans(
    fontSize: 13.sp,
    fontWeight: FontWeight.w400,
    color: const Color(0xFFE5E8EC),
  );
}

TextStyle textStyle_16Medium() {
  return GoogleFonts.encodeSans(
    fontSize: 16.sp,
    fontWeight: FontWeight.w500,
    color: Colors.white,
  );
}

TextStyle textStyle_22Bold() {
  return GoogleFonts.encodeSans(
    fontSize: 22.sp,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );
}

TextStyle textStyle_12Regular() {
  return GoogleFonts.encodeSans(
    fontSize: 12.sp,
    fontWeight: FontWeight.w400,
    color: const Color(0xFF7AFFFF),
  );
}

TextStyle textStyle_15SemiBold() {
  return GoogleFonts.encodeSans(
    fontSize: 15.sp,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );
}

TextStyle textStyle_12Medium() {
  return GoogleFonts.encodeSans(
    fontSize: 12.sp,
    fontWeight: FontWeight.w600,
    color: const Color(0xFFA6A6A6),
  );
}

TextStyle textStyle_18Medium() {
  return TextStyle(
    fontSize: 18.sp,
    fontWeight: FontWeight.w500,
    color: Colors.white,
  );
}

TextStyle textStyle_10Medium() {
  return TextStyle(
    fontSize: 10.sp,
    fontWeight: FontWeight.w500,
    color: const Color(0xFFA6A6A6),
  );
}

TextStyle textStyle_14Regular() {
  return GoogleFonts.encodeSans(
    fontSize: 14.sp,
    fontWeight: FontWeight.w400,
    color: Colors.white,
    height: 1.78,
  );
}

TextStyle textStyle_20Regular() {
  return TextStyle(
    fontSize: 20.sp,
    fontWeight: FontWeight.w400,
    color: Colors.white,
  );
}

TextStyle textStyle_8UpperCase() {
  return TextStyle(
    fontSize: 8.sp,
    fontWeight: FontWeight.w400,
    color: Colors.white,
    letterSpacing: 1.0,
  );
}

TextStyle textStyle_14Light() {
  return TextStyle(
    fontSize: 14.sp,
    fontWeight: FontWeight.w300,
    color: Colors.white,
  );
}

TextStyle textStyle_12NavigationLinks() {
  return GoogleFonts.encodeSans(
    fontSize: 12.sp,
    fontWeight: FontWeight.w400,
    height: 2.0,
  );
}

TextStyle textStyle_18SemiBold() {
  return TextStyle(
    fontSize: 18.sp,
    fontWeight: FontWeight.w500,
    color: Colors.white,
  );
}

TextStyle textStyle_16Bold() {
  return GoogleFonts.encodeSans(
    color: const Color(0xFFB6F0FF),
    fontSize: 16.sp,
    fontWeight: FontWeight.bold,
  );
}

TextStyle textStyle_20() {
  return GoogleFonts.encodeSans(
    color: const Color(0xFFB6F0FF),
    fontSize: 20.sp,
  );
}

TextStyle textStyle_20SemiBold() {
  return GoogleFonts.encodeSans(
    fontSize: 20.sp,
    fontWeight: FontWeight.w600,
    foreground: Paint()
      ..shader = const LinearGradient(
        colors: [Color(0xFFFFFFFF), Color(0xFF7AFFFF)],
      ).createShader(const Rect.fromLTWH(0.0, 0.0, 200.0, 70.0)),
  );
}

TextStyle textStyle_16RegularGrey() {
  return TextStyle(
    fontFamily: 'ProductSans',
    fontSize: 16.sp,
    fontWeight: FontWeight.normal,
    color: const Color(0xFF6D6D6D),
    height: 1.0,
  );
}

TextStyle textStyle_24RegularGrey() {
  return TextStyle(
    fontFamily: 'ProductSans',
    fontSize: 24.sp,
    fontWeight: FontWeight.w600,
    color: const Color(0xFF6D6D6D),
    height: 1.0,
  );
}

TextStyle textStyle_14RegularGrey() {
  return TextStyle(
    fontFamily: 'ProductSans',
    fontSize: 14.sp,
    fontWeight: FontWeight.w300,
    color: const Color(0xFF6D6D6D),
    height: 1.0,
  );
}

TextStyle textStyle_12LightGrey() {
  return TextStyle(
    fontFamily: 'ProductSans',
    fontSize: 12.sp,
    fontWeight: FontWeight.w300,
    color: const Color(0xFF6D6D6D),
    height: 1.2,
  );
}

TextStyle textStyle_12RegularGrey() {
  return TextStyle(
    fontFamily: 'ProductSans',
    fontSize: 12.sp,
    fontWeight: FontWeight.normal,
    color: const Color(0xFF6D6D6D),
    height: 1.0,
  );
}

TextStyle textStyle_12MediumGrey() {
  return TextStyle(
    fontFamily: 'ProductSans',
    fontSize: 12.sp,
    fontWeight: FontWeight.w500,
    color: const Color(0xFF949494),
    height: 1.0,
  );
}

TextStyle textStyle_14RegularBlack() {
  return TextStyle(
    fontFamily: 'ProductSans',
    fontSize: 14.sp,
    fontWeight: FontWeight.normal,
    color: const Color(0xFF000000),
    height: 1.0,
  );
}

TextStyle textStyle_14MediumGreyHintStyle() {
  return TextStyle(
    fontFamily: 'ProductSans',
    fontSize: 14.sp,
    fontWeight: FontWeight.normal,
    color: const Color(0xFF6D6D6D),
    height: 1.0,
  );
}

TextStyle textStyle_14LightBlack() {
  return TextStyle(
    fontFamily: 'ProductSans',
    fontSize: 14.sp,
    fontWeight: FontWeight.w400,
    color: const Color(0xFF000000),
    height: 1.0,
  );
}

TextStyle textStyle_18BoldBlack() {
  return TextStyle(
    fontFamily: 'ProductSans',
    fontSize: 18.sp,
    fontWeight: FontWeight.bold,
    color: const Color(0xFF000000),
    height: 1.3,
  );
}

TextStyle textStyle_24BoldBlack() {
  return TextStyle(
    fontFamily: 'ProductSans',
    fontSize: 24.sp,
    fontWeight: FontWeight.bold,
    color: const Color(0xFF000000),
    height: 1.0,
    letterSpacing: 1.0,
  );
}

TextStyle textStyle_16RegularBlack() {
  return TextStyle(
    fontFamily: 'ProductSans',
    fontSize: 16.sp,
    fontWeight: FontWeight.w400,
    color: const Color(0xFF161616),
    height: 1.0,
  );
}

TextStyle textStyle_16MediumBlack() {
  return TextStyle(
    fontFamily: 'ProductSans',
    fontSize: 16.sp,
    fontWeight: FontWeight.w500,
    color: const Color(0xFF161616),
    height: 1.0,
  );
}

TextStyle textStyle_16BoldBlack() {
  return TextStyle(
    fontFamily: 'ProductSans',
    fontSize: 16.sp,
    fontWeight: FontWeight.w800,
    color: const Color(0xFF161616),
    height: 1.0,
  );
}

TextStyle textStyle_16RegularWhite() {
  return TextStyle(
    fontFamily: 'ProductSans',
    fontSize: 16.sp,
    fontWeight: FontWeight.normal,
    color: const Color(0xFFF4F4F4),
    height: 1.0,
  );
}

TextStyle textStyle_18MediumBlack() {
  return TextStyle(
    fontFamily: 'ProductSans',
    fontSize: 18.sp,
    fontWeight: FontWeight.w600,
    color: const Color(0xFF161616),
    height: 1.0,
    letterSpacing: 0.55,
  );
}

TextStyle textStyle_10White() {
  return TextStyle(
    fontFamily: 'ProductSans',
    fontSize: 10.sp,
    fontWeight: FontWeight.normal,
    color: const Color(0xFFFFFFFF),
    height: 1.0,
  );
}

TextStyle textStyle_36SemiBoldWhite() {
  return TextStyle(
    fontFamily: 'ProductSans',
    fontSize: 36.sp,
    fontWeight: FontWeight.w600,
    color: const Color(0xFFFFFFFF),
    height: 1.0,
  );
}

TextStyle textStyle_16RegularLinkBlue() {
  return TextStyle(
    fontFamily: 'ProductSans',
    fontSize: 16.sp,
    fontWeight: FontWeight.w400,
    color: const Color(0xFF4167F2),
    height: 1.0,
  );
}

TextStyle textStyle_14RegularLinkBlue() {
  return TextStyle(
    fontFamily: 'ProductSans',
    fontSize: 14.sp,
    fontWeight: FontWeight.w400,
    color: const Color(0xFF4167F2),
    height: 1.0,
  );
}

TextStyle textStyle_16BoldLinkBlue() {
  return TextStyle(
    fontFamily: 'ProductSans',
    fontSize: 16.sp,
    fontWeight: FontWeight.w700,
    color: const Color(0xFF4167F2),
    height: 1.0,
  );
}

TextStyle textStyle_14BoldLinkBlue() {
  return TextStyle(
    fontFamily: 'ProductSans',
    fontSize: 14.sp,
    fontWeight: FontWeight.bold,
    color: const Color(0xFF4167F2),
    height: 1.0,
  );
}

TextStyle textStyle_36semiBoldWhite() {
  return TextStyle(
    fontFamily: 'ProductSans',
    fontSize: 36.sp,
    fontWeight: FontWeight.w700,
    color: const Color(0xFFFFFFFF),
    height: 1.0,
  );
}

// Revamp styles
TextStyle textStyle_24BlackBold() {
  return TextStyle(
    fontFamily: 'ProductSans',
    fontSize: 24.sp,
    fontWeight: FontWeight.w700,
    color: const Color(0xFF000000),
    height: 1.0,
  );
}

TextStyle textStyle_24RegularBlack() {
  return TextStyle(
    fontFamily: 'ProductSans',
    fontSize: 24.sp,
    fontWeight: FontWeight.w400,
    color: const Color(0xFF000000),
    height: 1.0,
  );
}

TextStyle textStyle_14YellowRegular() {
  return TextStyle(
    fontFamily: 'ProductSans',
    fontSize: 14.sp,
    fontWeight: FontWeight.w400,
    color: const Color(0xFFEF9F20),
    height: 1.0,
  );
}

TextStyle textStyle_18RedRegular() {
  return TextStyle(
    fontFamily: 'ProductSans',
    fontSize: 18.sp,
    fontWeight: FontWeight.w400,
    color: AppColors.redBgText,
    height: 1.0,
  );
}

TextStyle textStyle_16RedRegular() {
  return TextStyle(
    fontFamily: 'ProductSans',
    fontSize: 16.sp,
    fontWeight: FontWeight.w400,
    color: AppColors.redBgText,
    height: 1.0,
  );
}

TextStyle textStyle_18BlackRegular() {
  return TextStyle(
    fontFamily: 'ProductSans',
    fontSize: 18.sp,
    fontWeight: FontWeight.w400,
    color: const Color(0xFF000000),
    height: 1.0,
  );
}

TextStyle textStyle_20BlackMedium() {
  return TextStyle(
    fontFamily: 'ProductSans',
    fontSize: 20.sp,
    fontWeight: FontWeight.w500,
    color: const Color(0xFF000000),
    height: 1.0,
  );
}

TextStyle textStyle_18BlackMedium() {
  return TextStyle(
    fontFamily: 'ProductSans',
    fontSize: 18.sp,
    fontWeight: FontWeight.w500,
    color: const Color(0xFF000000),
    height: 1.0,
  );
}

TextStyle textStyle_hintText() {
  return TextStyle(
    fontFamily: 'ProductSans',
    fontSize: 16.sp,
    fontWeight: FontWeight.w400,
    color: const Color(0xFFB0B0B0),
    height: 1.0,
  );
}

TextStyle textStyle_14FooterText() {
  return TextStyle(
    fontFamily: 'ProductSans',
    fontSize: 14.sp,
    fontWeight: FontWeight.w400,
    color: const Color(0xFF959595),
    height: 1.0,
  );
}
