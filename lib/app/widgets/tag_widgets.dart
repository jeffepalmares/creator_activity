import 'package:creator_activity/app/constants/color_constants.dart';
import 'package:creator_activity/app/widgets/app_widgets.dart';
import 'package:flutter/material.dart';

abstract class TagWidgets {
  static Widget build(String tag, {Color? bkgColor, Color? labelColor}) {
    bkgColor = bkgColor ?? ColorConstants.buttonBlue;
    labelColor = labelColor ?? Colors.white;
    return Padding(
      padding: const EdgeInsets.only(right: 5.0),
      child: _box(tag, bkgColor, labelColor),
    );
  }

  static Widget _box(String text, Color bkgColor, Color labelColor) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4.0),
        color: bkgColor,
      ),
      child: _label(text, labelColor),
    );
  }

  static Widget _label(String text, Color labelColor) {
    return Padding(
      padding:
          const EdgeInsets.only(left: 4.0, right: 4.0, top: 3.0, bottom: 3.0),
      child: AppWidgets.getText(text, fontColor: labelColor),
    );
  }
}
