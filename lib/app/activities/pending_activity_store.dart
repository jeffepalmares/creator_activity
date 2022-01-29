import 'package:creator_activity/app/controllers/activity_controller.dart';
import 'package:creator_activity/app/controllers/stores/activity_store.dart';
import 'package:mobx/mobx.dart';

part 'pending_activity_store.g.dart';

class PendingActivityStore = _PendingActivityStoreBase
    with _$PendingActivityStore;

abstract class _PendingActivityStoreBase extends ActivityController with Store {
  @action
  ObservableList<ActivityStore> getActivities() {
    return ObservableList<ActivityStore>.of([]).asObservable();
  }
}
