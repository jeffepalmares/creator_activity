import 'package:creator_activity/app/controllers/activity_controller.dart';
import 'package:creator_activity/app/widgets/profile/profile_widgets.dart';
import 'package:flutter/widgets.dart';

import '../app_widgets.dart';
import '../tralling_icon_widget.dart';

abstract class PageHeadPanel {
  static Widget studentDoneheadPanel(ActivityController controller) {
    return Padding(
        padding: const EdgeInsets.only(top: 15, left: 16, bottom: 10),
        child: Column(
          children: [
            ProfileWidgets.titlePanel("Histórico de aulas"),
            controller.listSize == 0
                ? Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: Align(
                        alignment: Alignment.centerLeft,
                        child: AppWidgets.getText("Não há aulas realizadas")),
                  )
                : Padding(
                    padding: const EdgeInsets.only(top: 10, bottom: 10),
                    child: Row(
                      children: <Widget>[TrallingIconWidget.notSyncedLegend()],
                    ),
                  )
          ],
        ));
  }
}
