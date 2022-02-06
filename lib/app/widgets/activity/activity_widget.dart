import 'package:commons_flutter/utils/app_date_utils.dart';
import 'package:commons_flutter/utils/app_string_utils.dart';
import 'package:creator_activity/app/constants/activity_delivery_status.dart';
import 'package:creator_activity/app/constants/color_constants.dart';
import 'package:creator_activity/app/controllers/activity_controller.dart';
import 'package:creator_activity/app/controllers/stores/activity_store.dart';
import 'package:creator_activity/app/dtos/activity_dto.dart';
import 'package:creator_activity/app/utils/dialog_utils.dart';
import 'package:creator_activity/app/widgets/app_widgets.dart';
import 'package:creator_activity/app/widgets/list_item_widget.dart';
import 'package:creator_activity/app/widgets/view_config/drop_down_options.dart';
import 'package:creator_activity/app/widgets/view_config/view_options_widget.dart';
import 'package:flutter/material.dart';

import '../grouped_list_table.dart';
import '../tralling_icon_widget.dart';
import 'activity_app_bar.dart';

abstract class ActivityWidgets {
  final ActivityController controller;

  ActivityWidgets(this.controller);

  List<Widget> pageBodyItems();

  Widget build() {
    return activityScaffold(pageBodyItems);
  }

  Widget activityScaffold(List<Widget> Function() body) {
    return MaterialApp(
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: getAppBar(),
          body: _pageContent(body),
        ),
      ),
    );
  }

  AppBar? getAppBar() {
    return ActivityAppBar.getAppBar(controller);
  }

  Widget activityListTable(ActivityController controller,
      {String Function(ActivityStore)? paramGroupBy,
      Widget Function(BuildContext context, ActivityStore element, int index)?
          indexedItemBuilder}) {
    return GroupedListTable.listTable<ActivityStore, String>(
        controller.activities, paramGroupBy ?? groupBy,
        indexedItemBuilder: indexedItemBuilder ?? itemBuild);
  }

  Widget itemBuild(BuildContext context, ActivityStore activity, int index) {
    return ListItemWidget.listItem(activity.dto?.name ?? "");
  }

  String getSubtitleDate(ActivityDto dto) {
    dto.start = dto.start ?? DateTime.now().toIso8601String();
    if ((dto.end == null ||
            DateTime.parse(dto.end ?? "").isAfter(DateTime.now())) &&
        AppStringUtils.isNotEmptyOrNull(dto.start)) {
      return "Disponível desde ${AppDateUtils.stringToFormatedDate(dto.start!)}";
    } else if (dto.end != null &&
        AppDateUtils.isSameDate(DateTime.parse(dto.end!), DateTime.now())) {
      return "Disponível até hoje às 23:59";
    } else if (AppStringUtils.isEmptyOrNull(dto.start)) {
      return "-";
    }
    return "Data extrapolada. Fazer agora!";
  }

  String groupBy(ActivityStore activity) {
    return (ViewOptionsWidgets.config.groupBy == GroupBy.T
        ? activity.dto?.activityClass?.name ?? "Turma"
        : (activity.dto?.isExam ?? false)
            ? "Prova"
            : "Aulas");
  }

  AppBar getActivityAppBar(Widget title,
      {List<Widget>? actions, Widget? leading}) {
    return AppBar(
      title: title,
      leading: leading,
      actions: actions,
    );
  }

  Widget getAppActivityAppBarTitle(String title) {
    return AppWidgets.getText(
      title,
      fontColor: Colors.white,
      fontSize: 20,
      fontWeight: FontWeight.bold,
    );
  }

  Widget _pageContent(List<Widget> Function() body) {
    return AppWidgets.observerBuilder((_) {
      if (controller.isLoading) {
        return AppWidgets.loading();
      }
      var items = body();
      return Column(children: [
        items.first,
        Expanded(
            child: SingleChildScrollView(
          child: items.last,
        )),
      ]);
    });
  }

  Widget deleteDownloadedIcon(ActivityStore store) {
    return TrallingIconWidget.deleteActivityIcon(() =>
        DialogUtils.presentConfirmationDialog(
            controller.context,
            "",
            "Excluir aula \"${store.dto?.name}\" do dispositivo. Esta aula poderá ser baixada novamente.",
            () async => await controller.deleteDownloadedActivity(store)));
  }

  List<Widget> fileTrailling(ActivityStore store) {
    List<Widget> list = [];
    if (ActivityDeliveryStatus.adjusted == store.dto?.delivery?.status &&
        !(store.dto?.delivery?.checked ?? false)) {
      list.add(TrallingIconWidget.showScoreIcon());
    } else if (ActivityDeliveryStatus.adjusted == store.dto?.delivery?.status &&
        (store.dto?.delivery?.checked ?? false) &&
        !(store.dto?.delivery?.shouldRedo ?? false)) {
      list.add(TrallingIconWidget.scoreIcon(
          AppStringUtils.defaultValue(store.dto?.score)));
      list.add(TrallingIconWidget.disabledIcon(
          TrallingIconWidget.redoIcon((store.dto?.synced ?? false))));
    } else {
      list.add(TrallingIconWidget.scoreIcon("!"));
      list.add(TrallingIconWidget.redoIcon(store.dto?.synced ?? false));
    }
    return list;
  }
}
