import 'package:creator_activity/app/controllers/activity_helper.dart';
import 'package:creator_activity/app/dtos/activity_dto.dart';
import 'package:creator_activity/app/enums/action_state_enum.dart';
import 'package:mobx/mobx.dart';

import 'stores/activity_store.dart';

abstract class ActivityController with Store {
  @observable
  ActionState state = ActionState.loading;

  @observable
  int value = 0;

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

  @action
  void increment() {
    value = value + 1;
  }

  @action
  void changeState() {
    if (state == ActionState.loading) {
      state = ActionState.success;
    } else {
      state = ActionState.loading;
    }
  }
}
