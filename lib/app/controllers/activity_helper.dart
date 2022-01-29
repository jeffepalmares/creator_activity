import 'package:commons_flutter/utils/app_date_utils.dart';
import 'package:creator_activity/app/controllers/stores/activity_store.dart';
import 'package:creator_activity/app/dtos/activity_dto.dart';
import 'package:creator_activity/app/utils/lib_date_utils.dart';
import 'package:creator_activity/app/widgets/view_config/drop_down_options.dart';
import 'package:creator_activity/app/widgets/view_config/view_options_widget.dart';
import 'package:mobx/mobx.dart';

abstract class ActivityHelper {
  static ObservableList<ActivityStore> aplyViewConfig(
      List<ActivityDto> activitiesSource) {
    var list = activitiesSource;

    if (ViewOptionsWidgets.config.from != null) {
      list = activitiesSource
          .where((element) => LibDateUtils.isBetween(
                AppDateUtils.stringToDate(element.start!),
                end: ViewOptionsWidgets.config.end,
                start: ViewOptionsWidgets.config.from,
              ))
          .toList();
    }

    if (ViewOptionsWidgets.config.sortBy == SortActivityBy.Name) {
      list.sort((a, b) => a.name!.compareTo(b.name!));
    } else {
      list.sort((a, b) => a.start!.compareTo(b.start!));
    }

    if (ViewOptionsWidgets.config.sortType == SortType.Desc) {
      list = list.reversed.toList();
    }

    return ObservableList<ActivityStore>.of(
            list.isNotEmpty ? list.map((e) => ActivityStore(e)) : [])
        .asObservable();
  }
}
