import 'package:creator_activity/app/dtos/activity_dto.dart';
import 'package:creator_activity/app/dtos/sync_request_dto.dart';
import 'package:creator_activity/app/services/actvity_service.dart';
import 'package:commons_flutter/storage/local_storage.dart';
import 'activity_download_logic.dart';
import 'student_activity_logic.dart';

class StudentPedingActivityLogic extends StudentActivityLogic {
  StudentPedingActivityLogic(StudentActivityService service,
      ILocalStorage repository, ActivityDownloadLogic downloadLogic)
      : super(service, repository, downloadLogic);

  @override
  Future<List<ActivityDto>> loadActivities(SyncRequestDto syncRequest) async {
    try {
      var activities = await getActivities(syncRequest);

      activities.removeWhere((act) => act.isDone());

      return activities;
    } catch (err) {
      rethrow;
    }
  }
}
