import 'package:creator_activity/app/dtos/activity_dto.dart';
import 'package:creator_activity/app/enums/activity_status_enum.dart';
import 'package:creator_activity/app/logics/generics/activity_logic.dart';

class OpenActivityLogic {
  final ActivityLogic _logic;

  OpenActivityLogic(this._logic);

  Future updateActivity(ActivityDto activityDto) async {
    var list = await _logic.getActivities();
    for (var element in list) {
      if (element.code == activityDto.code) {
        element.scores = activityDto.scores;
        element.lastScore = activityDto.lastScore;
        element.lastScoreDate = activityDto.lastScoreDate;
        element.files = activityDto.files;
        element.synced = false;
        element.status = ActivityStatus.waitingSync;
        activityDto = element;
        break;
      }
    }
    await _logic.updateActivity(activityDto);
  }
}
