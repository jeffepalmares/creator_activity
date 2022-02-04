import 'package:creator_activity/app/controllers/activity_controller.dart';
import 'package:creator_activity/app/controllers/activity_helper.dart';
import 'package:creator_activity/app/controllers/stores/activity_store.dart';
import 'package:creator_activity/app/dtos/activity_dto.dart';
import 'package:creator_activity/app/enums/action_state_enum.dart';
import 'package:creator_activity/app/logics/student_peding_activity_logic.dart';
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
  Future<String?> generateActivityLink(ActivityStore store) async {
    return ActivityHelper.getActivityLink(store, context);
  }
}
