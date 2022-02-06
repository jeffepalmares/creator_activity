import 'package:commons_flutter/utils/dependency_injector.dart';
import 'package:creator_activity/app/controllers/corp/corp_pending_controller.dart';
import 'package:creator_activity/app/widgets/activity/corp_peding_activity_widget.dart';
import 'package:flutter/material.dart';

class CorpPendingPage extends StatefulWidget {
  final String title;
  const CorpPendingPage({Key? key, this.title = 'CorpPendingPage'})
      : super(key: key);
  @override
  CorpPendingPageState createState() => CorpPendingPageState();
}

class CorpPendingPageState extends State<CorpPendingPage> {
  CorpPendingController controller = DependencyInjector.injector.getInstance();

  @override
  void initState() {
    controller.loadActivities();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    controller.context = context;
    CorpActivityPendingPageWidgets builder =
        CorpActivityPendingPageWidgets(controller);
    return builder.build();
  }
}
