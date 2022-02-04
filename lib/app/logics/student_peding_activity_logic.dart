import 'package:creator_activity/app/dtos/activity_dto.dart';
import 'package:creator_activity/app/dtos/sync_request_dto.dart';
import 'package:creator_activity/app/services/actvity_service.dart';
import 'package:commons_flutter/storage/local_storage.dart';
import 'activity_download_logic.dart';
import 'student_activity_logic.dart';

class StudentPedingActivityLogic extends StudentActivityLogic {
  final StudentActivityService _service;
  final ILocalStorage _repository;
  final ActivityDownloadLogic _downloadLogic;

  StudentPedingActivityLogic(
      this._service, this._repository, this._downloadLogic)
      : super(_service, _repository, _downloadLogic);

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
