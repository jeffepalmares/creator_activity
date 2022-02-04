import 'package:commons_flutter/utils/dependency_injector.dart';
import 'package:creator_activity/app/controllers/student/done_activity_controller.dart';
import 'package:creator_activity/app/widgets/activity/student_done_activity_pending_widgets.dart';
import 'package:flutter/material.dart';

class DoneActivityStudentPage extends StatefulWidget {
  final String title;
  const DoneActivityStudentPage(
      {Key? key, this.title = 'DoneActivityStudentPage'})
      : super(key: key);
  @override
  DoneActivityStudentPageState createState() => DoneActivityStudentPageState();
}

class DoneActivityStudentPageState extends State<DoneActivityStudentPage> {
  DoneActivityController controller =
      DependencyInjector.get<DoneActivityController>();
  @override
  void initState() {
    super.initState();
    controller.loadActivities();
  }

  @override
  Widget build(BuildContext context) {
    StudenDoneActivityPendingWidgets builder =
        StudenDoneActivityPendingWidgets(controller);
    controller.context = context;
    return builder.build();
  }
}
