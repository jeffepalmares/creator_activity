import 'package:creator_activity/app/constants/color_constants.dart';
import 'package:creator_activity/app/enums/activity_screen_enum.dart';
import 'package:creator_activity/app/widgets/app_widgets.dart';
import 'package:creator_activity/app/widgets/profile/done_profile_widget.dart';
import 'package:creator_activity/app/widgets/profile/future_profile_widget.dart';
import 'package:creator_activity/app/widgets/profile/pending_profile_widget.dart';
import 'package:flutter/material.dart';

abstract class ProfileWidgets {
  static final ProfileWidgets _pedingInstance = PedingProfileWidget();
  static final ProfileWidgets _doneInstance = DoneProfileWidget();
  static final ProfileWidgets _futureInstance = FutureProfileWidget();

  static ProfileWidgets getInstance(ActivityScreenEnum screen) {
    if (screen == ActivityScreenEnum.peding) return _pedingInstance;
    if (screen == ActivityScreenEnum.done) return _doneInstance;
    return _futureInstance;
  }

  Widget getPanel();

  static Widget titlePanel(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          style: TextStyle(fontSize: 18, color: ColorConstants.softBlue),
        ),
      ),
    );
  }

  static Widget wellComePanel() {
    return Expanded(
        child: Padding(
      padding: const EdgeInsets.only(left: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          getPanelTitle(),
          getPanelSubTitle(),
        ],
      ),
    ));
  }

  static Text getPanelTitle() {
    return AppWidgets.getText("Bem-vindo (a) de Volta.",
        fontSize: 18,
        fontColor: ColorConstants.whiteGrey,
        fontWeight: FontWeight.w600);
  }

  static Text getPanelSubTitle() {
    return AppWidgets.getText(getSubTitle(),
        fontSize: 18,
        fontColor: ColorConstants.whiteGrey,
        fontWeight: FontWeight.w600);
  }

  static String getSubTitle() {
    var list = [];
    if (list.isEmpty) {
      return "Você está em dia. Nenhuma nova aula para você";
    }
    if (list.length == 1) {
      return "Temos uma nova tarefa pra você";
    }

    return "Temos novas tarefas pra você";
  }
}
