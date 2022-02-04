import 'package:commons_flutter/storage/local_storage.dart';
import 'package:commons_flutter/utils/app_string_utils.dart';
import 'package:creator_activity/app/dtos/activity_dto.dart';
import 'package:creator_activity/app/enums/activity_status_enum.dart';
import 'package:creator_activity/app/lib_session.dart';

class OpenActivityLogic {
  final ILocalStorage<List<ActivityDto>, String> _repository;

  OpenActivityLogic(this._repository);

  Future<List<ActivityDto>> _getActivitiesFromDataBase() async {
    if (AppStringUtils.isEmptyOrNull(LibSession.loggedUser)) {
      return [];
    }

    var activities = await _repository.getByKey(LibSession.loggedUser);

    return activities ?? [];
  }

  Future updateActivity(ActivityDto activityDto) async {
    var list = await _getActivitiesFromDataBase();
    for (var element in list) {
      if (element.code == activityDto.code) {
        element.scores = activityDto.scores;
        element.lastScore = activityDto.lastScore;
        element.lastScoreDate = activityDto.lastScoreDate;
        element.files = activityDto.files;
        element.synced = false;
        element.status = ActivityStatus.waitingSync;
        break;
      }
    }
    await _repository.upsert(list);
  }
}
