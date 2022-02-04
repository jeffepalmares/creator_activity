import 'package:creator_activity/app/constants/app_fonts.dart';
import 'package:creator_activity/app/constants/color_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

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

  static Widget heightSpacer({double height = 8}) {
    return SizedBox(
      height: height,
      width: 0,
    );
  }

  static Widget widthSpacer({double width = 8}) {
    return SizedBox(
      height: 0,
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

  static Widget observerBuilder(Widget Function(BuildContext) builder) {
    return Observer(
      builder: builder,
    );
  }

  static Widget observer(Widget content) {
    return Observer(
      builder: (_) {
        return content;
      },
    );
  }

  static Widget loading() {
    return Container(
      color: Colors.white,
      child: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  static Widget appButton(String label, Function() onTap,
      {Color? bckColor, Color? labelColor, Color? borderColor}) {
    bckColor = bckColor ?? Colors.white;
    labelColor = labelColor ?? Colors.black;
    borderColor = borderColor ?? bckColor;

    return ElevatedButton(
      child: getText(label, fontColor: labelColor, fontSize: 44 * 0.43),
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(double.infinity, 44),
        primary: bckColor,
        side: BorderSide(
          color: borderColor,
        ),
      ),
      onPressed: onTap,
    );
  }

  static Widget separatorWidget({double? height, Color? color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Divider(
        height: height,
        color: color,
      ),
    );
  }
}
