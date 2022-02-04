import 'package:commons_flutter/storage/local_storage.dart';
import 'package:commons_flutter/utils/app_date_utils.dart';
import 'package:commons_flutter/utils/network_utils.dart';
import 'package:creator_activity/app/dtos/activity_dto.dart';
import 'package:creator_activity/app/dtos/sync_request_dto.dart';
import 'package:creator_activity/app/enums/activity_type_enum.dart';
import 'package:creator_activity/app/enums/sync_preference_enum.dart';
import 'package:creator_activity/app/lib_session.dart';
import 'package:creator_activity/app/services/actvity_service.dart';

import 'activity_download_logic.dart';
import 'student_activity_logic.dart';

class DoneActivityLogic extends StudentActivityLogic {
  DoneActivityLogic(StudentActivityService service, ILocalStorage repository,
      ActivityDownloadLogic downloadLogic)
      : super(service, repository, downloadLogic);

  Future<List<ActivityDto>> loadActivities(SyncRequestDto syncRequest) async {
    try {
      syncRequest = await sendDoneActivities(syncRequest);

      var activities = await getActivities(syncRequest);

      activities.removeWhere((act) => !act.isDone());

      return activities;
    } catch (err) {
      rethrow;
    }
  }

  @override
  Future<void> checkFileActivity(ActivityDto dto) async {
    dto.delivery?.checked = true;
    dto.delivery?.checkedDate =
        AppDateUtils.stringToFormatedDate(DateTime.now().toIso8601String());

    await service.markDeliveryAsChecked([dto]);

    if (dto.delivery?.shouldRedo ?? false) {
      dto.lastScore = null;
      dto.lastScoreDate = null;
    }

    var acitivities = await getActivitiesFromDataBase();

    for (var element in acitivities) {
      if (element.code == dto.code) {
        element.delivery?.checked = dto.delivery?.checked;
        element.lastScore = dto.lastScore;
        element.lastScoreDate = dto.lastScoreDate;
      }
    }
    repository.upsert(acitivities);
  }

  @override
  Future<ActivityDto> checkLastDeliveryStatus(ActivityDto dto) async {
    try {
      if (dto.type != ActivityType.file) return dto;

      var delivery = await service.getActivityLastDelivery(dto);
      if (delivery != null) {
        var activities = await getActivitiesFromDataBase();
        for (var element in activities) {
          if (element.code == dto.code) {
            element.delivery = delivery;
          }
        }
        await repository.upsert(activities);
      }
      return dto;
    } catch (err) {
      return dto;
    }
  }

  Future<SyncRequestDto> sendDoneActivities(SyncRequestDto request) async {
    if (!(await _validateSendDoneActivities(request))) return request;

    var markCheckedDeliveredActivities = request.fromDb
        .where((element) =>
            element.synced == false &&
            element.type == ActivityType.file &&
            (element.delivery?.checked ?? false))
        .toList();

    var doneActivities = request.fromDb
        .where((element) =>
            element.type != ActivityType.file &&
            element.scores != null &&
            (element.synced ?? false) &&
            (element.scores?.isNotEmpty ?? false))
        .toList();
    var doneFileActivities = request.fromDb
        .where(
          (element) =>
              element.synced == false &&
              element.type == ActivityType.file &&
              (element.files?.isNotEmpty ?? false),
        )
        .toList();
    if (doneActivities.isNotEmpty) {
      await service.sendDoneActivities(doneActivities);
      for (var element in doneActivities) {
        element.scores = [];
        element.synced = true;
      }
    }
    if (markCheckedDeliveredActivities.isNotEmpty) {
      await service.markDeliveryAsChecked(markCheckedDeliveredActivities);
    }
    if (doneFileActivities.isNotEmpty) {
      await service.sendDoneFileActivities(doneFileActivities);
    }
    request.isSuccessfullySendingScores = true;
    return request;
  }

  Future<bool> _validateSendDoneActivities(SyncRequestDto request) async {
    if (request.fromDb.isEmpty) return false;

    if (LibSession.syncPreference == SyncPreference.manual &&
        !request.isManual) {
      return false;
    }

    var isWifi = await NetworkUtils.isWifi();

    if (LibSession.syncPreference == SyncPreference.wifi && !isWifi) {
      request.isSuccessfullySendingScores = false;
      request.sendingScoreErrorMessage =
          "Não foi possivel sincronizar suas notas, você não está conectado via wi-fi";
      return false;
    }

    return true;
  }
}
