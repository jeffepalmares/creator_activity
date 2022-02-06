import 'package:commons_flutter/storage/local_storage.dart';
import 'package:creator_activity/app/dtos/activity_dto.dart';
import 'package:creator_activity/app/logics/generics/file_activity_logic.dart';
import 'package:creator_activity/app/services/actvity_service.dart';

import '../generics/activity_download_logic.dart';
import 'student_activity_logic.dart';

class StudentDoneActivityLogic extends StudentActivityLogic {
  StudentDoneActivityLogic(
    StudentActivityService service,
    ILocalStorage repository,
    ActivityDownloadLogic downloadLogic,
    FileActivityLogic fileLogic,
  ) : super(service, repository, downloadLogic, fileLogic);

  @override
  Future<List<ActivityDto>> loadActivities(bool isManual) async {
    try {
      List<ActivityDto> activities = await getActivities();

      activities = await sendDoneActivities(activities, isManual);

      activities = await findActivities(activities, isManual);

      activities.removeWhere((act) => !act.isDone());

      return activities;
    } catch (err) {
      rethrow;
    }
  }
}
