import 'package:commons_flutter/utils/app_string_utils.dart';
import 'package:creator_activity/app/constants/color_constants.dart';
import 'package:creator_activity/app/widgets/app_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

abstract class ListItemWidget {
  static Widget listItem(String title,
      {Widget? subTitle, GestureTapCallback? onTap, Widget? trailling}) {
    return ListTile(
      title: AppWidgets.getText(AppStringUtils.defaultValue(title),
          fontColor: ColorConstants.defaultBlue, fontSize: 16),
      onTap: onTap,
      subtitle: subTitle,
      trailing: trailling,
    );
  }
}
