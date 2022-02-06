import 'package:creator_activity/app/constants/color_constants.dart';
import 'package:creator_activity/app/constants/lib_icons.dart';
import 'package:creator_activity/app/widgets/app_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

class TrallingIconWidget {
  static Widget showScoreIcon() {
    return Container(
      height: 30,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(3.0), color: Colors.amber),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.only(left: 8, right: 8),
          child: AppWidgets.getText("Ver nota", fontColor: Colors.black),
        ),
      ),
    );
  }

  static Widget scoreIcon(String? score) {
    score = score ?? "-";
    return Stack(
      alignment: Alignment.center,
      children: [
        _icon(
          Container(),
          ColorConstants.defaultGreen,
        ),
        AppWidgets.getText(score,
            fontColor: Colors.white, fontWeight: FontWeight.bold),
      ],
    );
  }

  static Widget disabledIcon(Widget icon) {
    return Stack(
      alignment: Alignment.center,
      children: [
        icon,
        Container(
          color: Colors.white.withOpacity(0.6),
          width: 30,
          height: 30,
        )
      ],
    );
  }

  static Widget redoIcon(bool? isSynced) {
    var bkgroundColor = (isSynced ?? true) ? Colors.amber : Colors.grey[400];
    return _icon(
      SizedBox(
        height: 15,
        width: 15,
        child: LibIcons.generateIcon(LibIcon.redo),
      ),
      bkgroundColor!,
    );
  }

  static Widget notSyncedIcon() {
    return SizedBox(
      width: 30,
      height: 30,
      child: Stack(
        children: [
          _icon(
            AppWidgets.getText(
              "!",
              fontWeight: FontWeight.bold,
              fontColor: Colors.black,
            ),
            Colors.grey[400]!,
          ),
          Align(
            alignment: Alignment.topRight,
            child: Container(
              width: 10,
              height: 10,
              decoration: const BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.all(Radius.circular(5.0)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  static Widget _icon(Widget child, Color bkgroundColor) {
    return Container(
      height: 30,
      width: 30,
      decoration: BoxDecoration(
        color: bkgroundColor,
        borderRadius: const BorderRadius.all(Radius.circular(5.0)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Align(
          alignment: Alignment.center,
          child: child,
        ),
      ),
    );
  }

  static Widget deleteActivityIcon(Function() deleteAction) {
    return IconButton(
      icon: LibIcons.generateIcon(LibIcon.trash, color: Colors.red),
      onPressed: deleteAction,
    );
  }

  static List<Widget> scoreTralling(String? score, bool? isSynced) {
    var list = <Widget>[];
    list.add(TrallingIconWidget.scoreIcon(score));
    list.add(TrallingIconWidget.redoIcon(isSynced));
    return list;
  }

  static Widget downloadIco(Function() download) {
    return IconButton(
      icon: LibIcons.generateIcon(LibIcon.download,
          color: ColorConstants.softBlue),
      onPressed: download,
    );
  }

  static Widget eyeIcon() {
    return LibIcons.generateIcon(LibIcon.eye, height: 25, width: 25);
  }

  static Widget downloadProgress(String percent) {
    percent = percent.replaceAll("%", "").trim();
    percent = percent == "##" ? "0" : percent;
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        _progressCircular(percent),
        _circleBlueShape(),
        _percentLabel(percent),
      ],
    );
  }

  static Widget _percentLabel(String percent) {
    return AppWidgets.getText(
      "$percent%",
      textAlign: TextAlign.center,
      fontSize: 12,
      fontColor: Colors.white,
    );
  }

  static Widget _circleBlueShape() {
    return Container(
      width: 38,
      height: 38,
      decoration: BoxDecoration(
        color: ColorConstants.softBlue,
        shape: BoxShape.circle,
      ),
    );
  }

  static Widget _progressCircular(String percent) {
    return CircularStepProgressIndicator(
      totalSteps: 100,
      currentStep: int.parse(percent),
      width: 48,
      height: 48,
      selectedColor: ColorConstants.softBlue,
      unselectedColor: Colors.grey[200],
      padding: 0,
      stepSize: 1,
      selectedStepSize: 3,
      roundedCap: (_, __) => true,
    );
  }

  static Widget notSyncedLegend() {
    return Row(
      children: [
        notSyncedIcon(),
        AppWidgets.widthSpacer(width: 8),
        AppWidgets.getText("Atividade não sincronizada!",
            fontWeight: FontWeight.w500),
      ],
    );
  }
}
