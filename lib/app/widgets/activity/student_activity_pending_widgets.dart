import 'package:creator_activity/app/constants/color_constants.dart';
import 'package:creator_activity/app/constants/lib_icons.dart';
import 'package:creator_activity/app/controllers/stores/activity_store.dart';
import 'package:creator_activity/app/controllers/student/pending_activity_controller.dart';
import 'package:creator_activity/app/enums/activity_type_enum.dart';
import 'package:creator_activity/app/lib_session.dart';
import 'package:creator_activity/app/widgets/app_widgets.dart';
import 'package:creator_activity/app/widgets/profile/profile_widgets.dart';
import 'package:creator_activity/app/widgets/tag_widgets.dart';
import 'package:creator_activity/app/widgets/tralling_icon_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import '../list_item_widget.dart';
import 'activity_view_option_widget.dart';
import 'activity_widget.dart';

class StudenActivityPendingWidgets extends ActivityWidgets {
  final PendingActivityController _controller;

  StudenActivityPendingWidgets(this._controller) : super(_controller);

  @override
  Widget build() {
    return activityScaffold(controller, _appBar, _pageBody);
  }

  Widget _pageBody() {
    return Column(children: [
      ProfileWidgets.pendingProfilePanel(controller.listSize),
      Expanded(
          child: SingleChildScrollView(
        child: activityListTable(controller, indexedItemBuilder: _itemBuild),
      )),
    ]);
  }

  AppBar _appBar() {
    return getActivityAppBar("Olá ${LibSession.loggedUserName}",
        leading: _getLeading(), actions: _getAction());
  }

  Widget _itemBuild(BuildContext _, ActivityStore store, int index) {
    return ListItemWidget.listItem(
      store.dto?.name ?? "",
      onTap: () => _controller.openActivity(store),
      subTitle: _getSubtitle(store),
      trailing: _getTrailing(store),
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

  List<Widget> _getAction() {
    return [
      IconButton(
        icon: LibIcons.generateIcon(LibIcon.syncIcon,
            color: Colors.white, height: 45, width: 45),
        onPressed: () async => await _controller.syncActivities(),
      )
    ];
  }

  Widget _getLeading() {
    return IconButton(
        icon: const Icon(
          Icons.settings,
        ),
        onPressed: () {
          showDialog(
            context: _controller.context,
            builder: (ctx) {
              return ActivityViewConfigWidgets.getViewOptionsBody(
                  _controller.context, _controller.applyViewConfig);
            },
          );
        });
  }
}
