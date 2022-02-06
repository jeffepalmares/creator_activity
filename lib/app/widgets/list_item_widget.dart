import 'package:creator_activity/app/constants/app_fonts.dart';
import 'package:creator_activity/app/constants/color_constants.dart';
import 'package:creator_activity/app/widgets/app_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

abstract class ListItemWidget {
  static Widget listItem(String title,
      {Widget? subTitle, GestureTapCallback? onTap, Widget? trailing}) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding:
            const EdgeInsets.only(left: 16, top: 16, right: 16, bottom: 10),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            _rowContent(title, subTitle: subTitle),
            trailing ?? const SizedBox(),
          ],
        ),
      ),
    );
  }

  static Widget _rowContent(String title, {Widget? subTitle}) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _tileTitle(title),
          AppWidgets.heightSpacer(height: 4),
          subTitle ?? const SizedBox(),
        ],
      ),
    );
  }

  static Widget _tileTitle(String title) {
    return AppWidgets.getText(
      title,
      fontColor: ColorConstants.defaultBlue,
      fontSize: 16,
      fontFamily: AppFonts.poppins,
    );
  }
}
