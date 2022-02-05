import 'package:creator_activity/app/constants/color_constants.dart';
import 'package:creator_activity/app/constants/lib_icons.dart';
import 'package:creator_activity/app/controllers/stores/activity_store.dart';
import 'package:creator_activity/app/controllers/student/pending_activity_controller.dart';
import 'package:creator_activity/app/enums/activity_type_enum.dart';
import 'package:creator_activity/app/widgets/app_widgets.dart';
import 'package:creator_activity/app/widgets/profile/profile_widgets.dart';
import 'package:creator_activity/app/widgets/tag_widgets.dart';
import 'package:creator_activity/app/widgets/tralling_icon_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import '../list_item_widget.dart';
import 'activity_widget.dart';

class StudenActivityPendingWidgets extends ActivityWidgets {
  final PendingActivityController _controller;

  StudenActivityPendingWidgets(this._controller) : super(_controller);

  @override
  List<Widget> pageBodyItems() {
    return [
      ProfileWidgets.pendingProfilePanel(controller.listSize),
      activityListTable(controller, indexedItemBuilder: itemBuild),
    ];
  }

  @override
  Widget itemBuild(BuildContext context, ActivityStore activity, int index) {
    return ListItemWidget.listItem(
      activity.dto?.name ?? "",
      onTap: () => _controller.openActivity(activity),
      subTitle: _getSubtitle(activity),
      trailing: _getTrailing(activity),
    );
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
      items.add(deleteDownloadedIcon(store));
      items.add(TrallingIconWidget.eyeIcon());
    } else {
      items.add(TrallingIconWidget.downloadIco(
          () => _controller.downloadActivity(store)));
    }
    return items;
  }

  Widget _getSubtitle(ActivityStore store) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            LibIcons.generateIcon(
              LibIcon.calendarCheck,
              color: Colors.green,
              height: 15,
              width: 13,
            ),
            AppWidgets.widthSpacer(width: 5),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppWidgets.getText(
                  getSubtitleDate(store.dto!),
                  fontColor: ColorConstants.defaultGrey,
                ),
              ],
            ),
          ],
        ),
        Container(
          child: _getTags(store),
        )
      ],
    );
  }

  static Widget _getTags(ActivityStore store) {
    var list = <Widget>[];
    if (ActivityType.file == store.dto?.type) {
      list.add(TagWidgets.build('Entrega de arquivo'));
      if (store.dto?.delivery != null &&
          (store.dto?.delivery?.shouldRedo ?? false)) {
        list.add(TagWidgets.build('Refazer',
            bkgColor: Colors.amber, labelColor: Colors.black));
      }
    }
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: list,
      ),
    );
  }
}
