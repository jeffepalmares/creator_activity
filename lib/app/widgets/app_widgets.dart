import 'package:creator_activity/app/constants/app_fonts.dart';
import 'package:creator_activity/app/constants/color_constants.dart';
import 'package:flutter/material.dart';

abstract class AppWidgets {
  static Scaffold appScreenScaffold(
    Widget body, {
    Widget? bottomNavigationBar,
    Color? bottomColor,
    AppBar? appBar,
    Color? backGroundColor,
  }) {
    backGroundColor = backGroundColor ?? Colors.white.withAlpha(200);
    bottomColor = bottomColor ?? backGroundColor;
    return Scaffold(
      appBar: appBar,
      body: SafeArea(
        bottom: true,
        child: body,
      ),
      backgroundColor: backGroundColor,
      bottomNavigationBar:
          _getBottomNavigator(bottomNavigationBar, bottomColor),
    );
  }

  static Widget? _getBottomNavigator(Widget? content, Color bottomColor) {
    return content != null
        ? Container(
            color: bottomColor,
            child: SafeArea(
              child: content,
            ),
          )
        : content;
  }

  static Widget spacer({double height = 8, double width = 8}) {
    return SizedBox(
      height: height,
      width: width,
    );
  }

  static Widget line({Color? color}) {
    color = color ?? ColorConstants.defaultGrey.withAlpha(80);
    return Container(
      width: double.infinity,
      color: color,
      height: 1,
    );
  }

  static TextStyle getDefaultStyle(
      {String? fontFamily,
      double? fontSize,
      Color? fontColor,
      FontWeight? fontWeight}) {
    return TextStyle(
      fontFamily: fontFamily ?? AppFonts.segoe,
      fontSize: fontSize ?? 14,
      fontWeight: fontWeight ?? FontWeight.normal,
      color: fontColor ?? ColorConstants.defaultGrey,
    );
  }

  static Text getText(String text,
      {TextAlign? textAlign,
      String? fontFamily,
      double? fontSize,
      Color? fontColor,
      FontWeight? fontWeight}) {
    return Text(
      text,
      textAlign: textAlign,
      style: getDefaultStyle(
        fontColor: fontColor,
        fontFamily: fontFamily,
        fontSize: fontSize,
        fontWeight: fontWeight,
      ),
    );
  }
}
