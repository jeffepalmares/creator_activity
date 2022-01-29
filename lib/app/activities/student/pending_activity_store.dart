import 'package:creator_activity/app/controllers/activity_controller.dart';
import 'package:creator_activity/app/controllers/stores/activity_store.dart';
import 'package:creator_activity/app/dtos/activity_dto.dart';
import 'package:creator_activity/app/dtos/sync_request_dto.dart';
import 'package:creator_activity/logics/student_activity_logic.dart';
import 'package:flutter/widgets.dart';
import 'package:mobx/mobx.dart';

part 'pending_activity_store.g.dart';

class PendingActivityStore = _PendingActivityStoreBase
    with _$PendingActivityStore;

abstract class _PendingActivityStoreBase extends ActivityController with Store {
  final StudentPadingActivityLogic _logic;

  _PendingActivityStoreBase(this._logic) : super(_logic);

  @override
  Future<List<ActivityDto>> loadActivities({bool isManual = false}) async {
    try {
      //AppAnalytics.setLogId();
      var request = SyncRequestDto(isManual);

      activitiesSource = await _logic.loadActivities(request);
      applyViewConfig();
      debugPrint("Activities loaded");
      return activitiesSource;
    } catch (err) {
      return activitiesSource;
    }
  }

  @override
  Future<void> openActivity(ActivityStore store) async {
    try {
      await doOpenActivity(store);
      activitiesSource.removeWhere((element) => element.hasScore());
      applyViewConfig();
    } catch (err) {}
  }

  @override
  Future<String?> generateActivityLink(ActivityStore store) async {
    return null;
  }
}
