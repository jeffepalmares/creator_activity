import 'package:creator_activity/app/controllers/activity_helper.dart';
import 'package:creator_activity/app/dtos/activity_dto.dart';
import 'package:creator_activity/app/enums/action_state_enum.dart';
import 'package:mobx/mobx.dart';

import 'stores/activity_store.dart';

abstract class ActivityController with Store {
  @observable
  ActionState state = ActionState.loading;

  List<ActivityDto> activitiesSource = [];

  ObservableList<ActivityStore> activities =
      ObservableList<ActivityStore>.of([]).asObservable();

  ObservableList<ActivityStore> getActivities();

  @action
  void applyViewConfig() {
    state = ActionState.loading;
    activities = ActivityHelper.aplyViewConfig(activitiesSource);
    state = ActionState.success;
  }
}
