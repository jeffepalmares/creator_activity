import 'package:creator_activity/app/constants/color_constants.dart';
import 'package:creator_activity/app/widgets/app_widgets.dart';
import 'package:creator_activity/app/widgets/user_picture_widgets.dart';
import 'package:flutter/material.dart';

abstract class ProfileWidgets {
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

  static Widget pendingProfilePanel(int listSize) {
    var panel = listSize == 0
        ? noActivitiesPanel()
        : listSize == 1
            ? onlyOneActivityPanel()
            : mutipleActivitiesPanel();

    return Padding(
      padding: const EdgeInsets.only(top: 20, left: 16, bottom: 10),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              UserPictureWidgets.userPicture(),
              AppWidgets.widthSpacer(),
              Expanded(child: panel),
            ],
          ),
          titlePanel(listSize == 0 ? "" : "Aulas"),
        ],
      ),
    );
  }

  static Widget noActivitiesPanel() {
    return _wellComePanel("Você está em dia. Nenhuma nova aula para você");
  }

  static Widget onlyOneActivityPanel() {
    return _wellComePanel("Temos uma nova tarefa pra você");
  }

  static Widget mutipleActivitiesPanel() {
    return _wellComePanel("Temos novas tarefas pra você");
  }

  static Widget _wellComePanel(String subtitle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        getPanelTitle(),
        getPanelSubTitle(subtitle),
      ],
    );
  }

  static Text getPanelTitle() {
    return AppWidgets.getText("Bem-vindo (a) de Volta.",
        fontSize: 18,
        fontColor: ColorConstants.defaultGrey,
        fontWeight: FontWeight.w600);
  }

  static Text getPanelSubTitle(String subtitle) {
    return AppWidgets.getText(
      subtitle,
      fontSize: 18,
      fontColor: ColorConstants.defaultGrey,
      fontWeight: FontWeight.normal,
    );
  }
}
