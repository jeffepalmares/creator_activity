import 'package:creator_activity/app/dtos/sync_request_dto.dart';
import 'package:creator_activity/app/enums/action_state_enum.dart';
import 'package:mobx/mobx.dart';

import 'package:creator_activity/app/controllers/activity_controller.dart';
import 'package:creator_activity/app/controllers/stores/activity_store.dart';
import 'package:creator_activity/app/dtos/activity_dto.dart';
import 'package:creator_activity/logics/done_activity_logic.dart';

part 'done_activity_controller.g.dart';

class DoneActivityController = _DoneActivityController
    with _$DoneActivityController;

abstract class _DoneActivityController extends ActivityController with Store {
  final DoneActivityLogic _logic;

  _DoneActivityController(
    this._logic,
  ) : super(_logic);

  @override
  @action
  Future<String?> generateActivityLink(ActivityStore store) async {
    String? t;
    return t;
  }

  @override
  @action
  Future<void> openActivity(ActivityStore store) async {}

  @override
  @action
  Future<List<ActivityDto>> loadActivities() async {
    state = ActionState.loading;
    super.activitiesSource = await _logic.loadActivities(SyncRequestDto(false));
    applyViewConfig();
    state = ActionState.success;
    return super.activitiesSource;
  }

  @override
  @action
  Future<void> syncActivities() async {
    await loadActivities();
  }
}
