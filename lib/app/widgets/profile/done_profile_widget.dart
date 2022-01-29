import 'package:creator_activity/app/widgets/app_widgets.dart';
import 'package:creator_activity/app/widgets/tralling_icon_widget.dart';
import 'package:flutter/widgets.dart';

import 'profile_widgets.dart';

class DoneProfileWidget extends ProfileWidgets {
  @override
  Widget getPanel() {
    var list = <Widget>[];

    list.add(ProfileWidgets.titlePanel("Histórico de aulas"));
    if ([].isEmpty) {
      list.add(_noDoneActivitiesLabel());
    } else {
      list.add(Padding(
        padding: const EdgeInsets.only(top: 10, bottom: 10),
        child: Row(
          children: <Widget>[_notSyncedLabel()],
        ),
      ));
    }
    return Column(
      children: list,
    );
  }

  Widget _noDoneActivitiesLabel() {
    return Padding(
      padding: const EdgeInsets.only(top: 5),
      child: Align(
          alignment: Alignment.centerLeft,
          child: AppWidgets.getText("Não há aulas realizadas")),
    );
  }

  Widget _notSyncedLabel() {
    return Padding(
        padding: const EdgeInsets.only(top: 10, bottom: 10),
        child: Row(
          children: [
            TrallingIconWidget.notSyncedIcon(),
            AppWidgets.spacer(width: 8),
            AppWidgets.getText("Aula não sincronizada!",
                fontWeight: FontWeight.w500)
          ],
        ));
  }
}
