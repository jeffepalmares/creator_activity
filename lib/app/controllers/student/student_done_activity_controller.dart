import 'package:creator_activity/app/logics/student/student_done_activity_logic.dart';
import 'package:mobx/mobx.dart';
import 'package:creator_activity/app/controllers/activity_controller.dart';
import 'package:creator_activity/app/controllers/stores/activity_store.dart';
import '../activity_helper.dart';
part 'student_done_activity_controller.g.dart';

class StudentDoneActivityController = _StudentDoneActivityController
    with _$StudentDoneActivityController;

abstract class _StudentDoneActivityController extends ActivityController
    with Store {
  _StudentDoneActivityController(StudentDoneActivityLogic logic) : super(logic);

  @override
  @action
  Future<String?> generateActivityLink(ActivityStore store) async {
    return ActivityHelper.getActivityLink(store, context);
  }

  @override
  @action
  Future<void> openActivity(ActivityStore store) async {
    await doOpenActivity(store);
    applyViewConfig();
  }

  @override
  @action
  Future<void> syncActivities() async {
    await loadActivities(isManual: true);
  }
}
