import 'dart:io';

import 'package:creator_activity/app/controllers/student/pending_activity_controller.dart';
import 'package:creator_activity/app/widgets/activity/student_activity_pending_widgets.dart';
import 'package:commons_flutter/utils/dependency_injector.dart';
import 'package:flutter/material.dart';

class ActivityStudentPedingPage extends StatefulWidget {
  final String title;
  const ActivityStudentPedingPage(
      {Key? key, this.title = 'ActivityStudentPedingPage'})
      : super(key: key);
  @override
  ActivityStudentPedingPageState createState() =>
      ActivityStudentPedingPageState();
}

class ActivityStudentPedingPageState extends State<ActivityStudentPedingPage> {
  PendingActivityController controller =
      DependencyInjector.get<PendingActivityController>();

  @override
  void initState() {
    super.initState();
    if (Platform.isIOS) {
      controller.loadActivities(isManual: false);
      return;
    }

    controller.loadActivities(isManual: false);
  }

  @override
  Widget build(BuildContext context) {
    StudenActivityPendingWidgets builder =
        StudenActivityPendingWidgets(controller);

    builder.controller.context = context;
    return builder.build();
  }
}
