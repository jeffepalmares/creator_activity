import 'package:creator_activity/app/dtos/activity_dto.dart';
import 'package:creator_activity/app/logics/generics/file_activity_logic.dart';
import 'package:creator_activity/app/services/actvity_service.dart';
import 'package:commons_flutter/storage/local_storage.dart';
import '../generics/activity_download_logic.dart';
import 'student_activity_logic.dart';

class StudentPedingActivityLogic extends StudentActivityLogic {
  StudentPedingActivityLogic(
    StudentActivityService service,
    ILocalStorage repository,
    ActivityDownloadLogic downloadLogic,
    FileActivityLogic fileLogic,
  ) : super(service, repository, downloadLogic, fileLogic);

  @override
  Future<List<ActivityDto>> loadActivities(bool isManual) async {
    try {
      var activities = await getActivities();

      activities = await findActivities(activities, isManual);

      activities.removeWhere((act) => act.isDone());

      return activities;
    } catch (err) {
      rethrow;
    }
  }
}
