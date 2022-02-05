import 'package:creator_activity/app/constants/lib_icons.dart';
import 'package:creator_activity/app/controllers/activity_controller.dart';
import 'package:flutter/material.dart';

import '../../lib_session.dart';
import '../app_widgets.dart';
import 'activity_view_option_widget.dart';

abstract class ActivityAppBar {
  static AppBar? getAppBar(ActivityController controller) {
    return getActivityAppBar(
      getAppActivityAppBarTitle("Olá ${LibSession.loggedUserName}"),
      leading: getAppBarLeading(controller),
      actions: getAppBarActions(controller),
    );
  }

  static AppBar getActivityAppBar(Widget title,
      {List<Widget>? actions, Widget? leading}) {
    return AppBar(
      title: title,
      leading: leading,
      actions: actions,
    );
  }

  static Widget getAppActivityAppBarTitle(String title) {
    return AppWidgets.getText(
      title,
      fontColor: Colors.white,
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
