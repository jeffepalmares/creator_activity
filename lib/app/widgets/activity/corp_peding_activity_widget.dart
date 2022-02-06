import 'package:creator_activity/app/constants/color_constants.dart';
import 'package:creator_activity/app/constants/lib_icons.dart';
import 'package:creator_activity/app/controllers/activity_controller.dart';
import 'package:creator_activity/app/controllers/stores/activity_store.dart';
import 'package:creator_activity/app/enums/activity_type_enum.dart';
import 'package:creator_activity/app/widgets/profile/profile_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../app_widgets.dart';
import '../list_item_widget.dart';
import '../tag_widgets.dart';
import '../tralling_icon_widget.dart';
import 'activity_app_bar.dart';
import 'activity_widget.dart';

class CorpActivityPendingPageWidgets extends ActivityWidgets {
  CorpActivityPendingPageWidgets(ActivityController controller)
      : super(controller);

  @override
  List<Widget> pageBodyItems() {
    return <Widget>[
      ProfileWidgets.pendingProfilePanel(controller.listSize),
      activityListTable(controller, indexedItemBuilder: itemBuild),
    ];
  }

  @override
  AppBar? getAppBar() {
    return ActivityAppBar.getAppBar(
      controller,
      backGroundColor: Colors.white,
      titleColor: ColorConstants.softBlue,
      elevation: 0,
    );
  }

  @override
  Widget itemBuild(BuildContext context, ActivityStore activity, int index) {
    return ListItemWidget.listItem(
      activity.dto?.name ?? "",
      onTap: () => controller.openActivity(activity),
      subTitle: _getSubtitle(activity),
      trailing: _getTrailing(activity),
    );
  }

  Widget _getTrailing(ActivityStore store) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [TrallingIconWidget.eyeIcon()],
    );
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
