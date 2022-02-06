import 'package:creator_activity/app/constants/activity_delivery_status.dart';
import 'package:creator_activity/app/constants/color_constants.dart';
import 'package:creator_activity/app/controllers/stores/activity_store.dart';
import 'package:creator_activity/app/controllers/student/student_done_activity_controller.dart';
import 'package:creator_activity/app/enums/activity_type_enum.dart';
import 'package:creator_activity/app/widgets/app_widgets.dart';
import 'package:creator_activity/app/widgets/page-head-panels/page_head_panel.dart';
import 'package:creator_activity/app/widgets/tag_widgets.dart';
import 'package:creator_activity/app/widgets/tralling_icon_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import '../list_item_widget.dart';
import '../show_score_widget.dart';
import 'activity_widget.dart';

class StudenDoneActivityPendingWidgets extends ActivityWidgets {
  final StudentDoneActivityController _controller;

  StudenDoneActivityPendingWidgets(this._controller) : super(_controller);

  @override
  List<Widget> pageBodyItems() {
    return [
      PageHeadPanel.studentDoneheadPanel(controller),
      activityListTable(controller, indexedItemBuilder: itemBuild),
    ];
  }

  @override
  Widget itemBuild(BuildContext context, ActivityStore activity, int index) {
    return ListItemWidget.listItem(
      activity.dto?.name ?? "",
      onTap: getOpenActivityFunction(activity),
      subTitle: _getSubtitle(activity),
      trailing: _getTrailing(activity),
    );
  }

  Function()? getOpenActivityFunction(ActivityStore activity) {
    if (ActivityType.file != activity.dto?.type) {
      return () => controller.openActivity(activity);
    }

    if (!(activity.dto?.synced ?? true)) return null;

    if (ActivityDeliveryStatus.adjusted == activity.dto?.delivery?.status &&
        !(activity.dto?.delivery?.checked ?? false)) {
      return () => ShowScoreWidget.show(activity, controller);
    }
    return null;
  }

  Widget _getTrailing(ActivityStore store) {
    return Observer(
      builder: (_) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: _getTrailingIcons(store),
        );
      },
    );
  }

  List<Widget> _getTrailingIcons(ActivityStore store) {
    List<Widget> items = [];
    if (store.isDownloading) {
      items.add(TrallingIconWidget.downloadProgress(store.downloadingPercent));
      return items;
    }

    if (store.isDownloaded) {
      items.add(TrallingIconWidget.deleteActivityIcon(
          () => _controller.deleteDownloadedActivity(store)));
    } else {
      items.add(TrallingIconWidget.downloadIco(
          () => _controller.downloadActivity(store)));
    }
    if (!(store.dto?.synced ?? true)) {
      items.add(TrallingIconWidget.notSyncedIcon());
      return items;
    }

    if (store.hasScore && ActivityType.file != store.dto?.type) {
      items.addAll(
          TrallingIconWidget.scoreTralling(store.score, store.dto?.synced));
    } else if (ActivityType.file == store.dto?.type &&
        store.dto?.delivery != null) {
      items.addAll(fileTrailling(store));
    }
    return items;
  }

  Widget _getSubtitle(ActivityStore store) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppWidgets.getText(
          getSubtitleDate(store.dto!),
          fontColor: ColorConstants.defaultGrey,
        ),
        _getTags(store)
      ],
    );
  }

  static Row _getTags(ActivityStore store) {
    var list = <Widget>[];
    if (ActivityType.file == store.dto?.type) {
      list.add(TagWidgets.build('Entrega de arquivo'));
      if (store.dto?.delivery != null &&
          (store.dto?.delivery?.shouldRedo ?? false)) {
        list.add(TagWidgets.build('Refazer',
            bkgColor: Colors.amber, labelColor: Colors.black));
      }
    }
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: list,
    );
  }
}
