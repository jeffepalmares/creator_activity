import 'package:creator_activity/app/logics/done_activity_logic.dart';
import 'package:mobx/mobx.dart';

import 'package:creator_activity/app/controllers/activity_controller.dart';
import 'package:creator_activity/app/controllers/stores/activity_store.dart';

import '../activity_helper.dart';

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
    return ActivityHelper.getActivityLink(store, context);
  }

  @override
  @action
  Future<void> syncActivities() async {
    await loadActivities(isManual: true);
  }
}
