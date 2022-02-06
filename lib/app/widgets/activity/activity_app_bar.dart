import 'package:creator_activity/app/constants/lib_icons.dart';
import 'package:creator_activity/app/controllers/activity_controller.dart';
import 'package:flutter/material.dart';

import '../../lib_session.dart';
import '../app_widgets.dart';
import 'activity_view_option_widget.dart';

abstract class ActivityAppBar {
  static AppBar? getAppBar(
    ActivityController controller, {
    Color? backGroundColor,
    double? elevation,
    Color titleColor = Colors.white,
  }) {
    return AppBar(
      title: getAppActivityAppBarTitle("Olá ${LibSession.loggedUserName}",
          titleColor: titleColor),
      leading: getAppBarLeading(controller),
      actions: getAppBarActions(controller),
      backgroundColor: backGroundColor,
      elevation: elevation,
    );
  }

  static Widget getAppActivityAppBarTitle(String title,
      {Color titleColor = Colors.white}) {
    return AppWidgets.getText(
      title,
      fontColor: titleColor,
      fontSize: 20,
      fontWeight: FontWeight.bold,
    );
  }

  static Widget getAppBarLeading(ActivityController controller) {
    return IconButton(
        icon: const Icon(
          Icons.settings,
        ),
        onPressed: () {
          showDialog(
            context: controller.context,
            builder: (ctx) {
              return ActivityViewConfigWidgets.getViewOptionsBody(
                  controller.context, controller.applyViewConfig);
            },
          );
        });
  }

  static List<Widget> getAppBarActions(ActivityController controller) {
    return [
      IconButton(
        icon: LibIcons.generateIcon(LibIcon.syncIcon,
            color: Colors.white, height: 45, width: 45),
        onPressed: () async => await controller.syncActivities(),
      )
    ];
  }
}
