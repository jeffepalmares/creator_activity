import 'package:creator_activity/app/controllers/activity_controller.dart';
import 'package:creator_activity/app/controllers/activity_helper.dart';
import 'package:creator_activity/app/controllers/stores/activity_store.dart';
import 'package:creator_activity/app/dtos/activity_dto.dart';
import 'package:creator_activity/app/dtos/sync_request_dto.dart';
import 'package:creator_activity/app/enums/action_state_enum.dart';
import 'package:creator_activity/logics/student_peding_activity_logic.dart';
import 'package:flutter/widgets.dart';
import 'package:mobx/mobx.dart';

part 'pending_activity_controller.g.dart';

class PendingActivityController = _PendingActivityControllerBase
    with _$PendingActivityController;

abstract class _PendingActivityControllerBase extends ActivityController
    with Store {
  final StudentPedingActivityLogic _logic;

  _PendingActivityControllerBase(this._logic) : super(_logic);

  @override
  @action
  Future<List<ActivityDto>> loadActivities({bool isManual = false}) async {
    try {
      //AppAnalytics.setLogId();
      var request = SyncRequestDto(isManual);
      state = ActionState.loading;
      activitiesSource = await _logic.loadActivities(request);
      applyViewConfig();
      debugPrint("Activities loaded");
      state = ActionState.success;
      return activitiesSource;
    } catch (err) {
      state = ActionState.error;
      return activitiesSource;
    }
  }

  @override
  @action
  Future<void> syncActivities() async {
    try {
      state = ActionState.loading;
      await loadActivities(isManual: true);
      state = ActionState.success;
    } catch (err) {
      state = ActionState.error;
    }
  }

  @override
  @action
  Future<void> openActivity(ActivityStore store) async {
    try {
      await doOpenActivity(store);
      activitiesSource.removeWhere((element) => element.hasScore());
      applyViewConfig();
    } catch (err) {}
  }

  @override
  Future<String?> generateActivityLink(ActivityStore store) async {
    return ActivityHelper.getActivityLink(store, context);
  }
}
