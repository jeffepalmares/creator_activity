import 'package:creator_activity/app/widgets/app_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

abstract class ActivityWidgets {
  static Widget pageBody() {
    return Column(
      children: <Widget>[
        Padding(
            padding: const EdgeInsets.only(top: 20, left: 10, bottom: 10),
            child: Container() //_getHeaderPanel(controller, page),
            ),
        Expanded(child: Container() //_mainBody(controller, page),
            ),
      ],
    );
    /*switch (controller.state) {
    case ActionState.Loading:
      return loading();
    case ActionState.Error:
      return noInternetError(
          () => controller.loadActivities(isDone: isDone, isManual: true));
    default:
      ;
  }
  */
  }
}
