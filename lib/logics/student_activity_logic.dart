import 'package:collection/collection.dart';
import 'package:commons_flutter/storage/local_storage.dart';
import 'package:commons_flutter/utils/app_date_utils.dart';
import 'package:commons_flutter/utils/app_string_utils.dart';
import 'package:commons_flutter/utils/network_utils.dart';
import 'package:creator_activity/app/constants/activity_delivery_status.dart';
import 'package:creator_activity/app/dtos/activity_dto.dart';
import 'package:creator_activity/app/dtos/sync_request_dto.dart';
import 'package:creator_activity/app/enums/activity_type_enum.dart';
import 'package:creator_activity/app/enums/sync_preference_enum.dart';
import 'package:creator_activity/app/lib_session.dart';
import 'package:creator_activity/app/services/actvity_service.dart';
import 'package:creator_activity/logics/activity_logic.dart';

class StudentPadingActivityLogic extends ActivityLogic {
  final StudentActivityService _service;
  final ILocalStorage _repository;

  StudentPadingActivityLogic(this._service, this._repository);

  @override
  Future<void> checkFileActivity(ActivityDto dto) async {
    dto.delivery?.checked = true;
    dto.delivery?.checkedDate =
        AppDateUtils.stringToFormatedDate(DateTime.now().toIso8601String());

    await _service.markDeliveryAsChecked([dto]);

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
    _repository.upsert(acitivities);
  }

  @override
  Future<ActivityDto> checkLastDeliveryStatus(ActivityDto dto) async {
    try {
      if (dto.type != ActivityType.file) return dto;

      var delivery = await _service.getActivityLastDelivery(dto);
      if (delivery != null) {
        var activities = await getActivitiesFromDataBase();
        for (var element in activities) {
          if (element.code == dto.code) {
            element.delivery = delivery;
          }
        }
        await _repository.upsert(activities);
      }
      return dto;
    } catch (err) {
      return dto;
    }
  }

  Future<List<ActivityDto>> getActivitiesFromDataBase() async {
    var activities = await _repository.getByKey(LibSession.loggedUser);
    return activities;
  }

  Future<List<ActivityDto>> loadActivities(SyncRequestDto syncRequest) async {
    if (AppStringUtils.isEmptyOrNull(LibSession.loggedUser)) {
      return [];
    }

    syncRequest.fromDb = await getActivitiesFromDataBase();

    syncRequest = await _sendDoneActivities(syncRequest);

    syncRequest = await syncActivities(syncRequest);

    await _repository.upsert(syncRequest.result);

    syncRequest.result.removeWhere((act) => act.isDone());

    syncRequest.result.sort((a, b) {
      return a.name!.toLowerCase().compareTo(b.name!.toLowerCase());
    });

    return syncRequest.result;
  }

  Future<SyncRequestDto> syncActivities(SyncRequestDto syncRequest) async {
    syncRequest = await getActivitiesFromService(syncRequest);

    _getNewActivities(syncRequest);
    _toKeepActivities(syncRequest);
    syncRequest.result = [];
    syncRequest.result.addAll(syncRequest.toKeep);
    syncRequest.result.addAll(syncRequest.newActivites);
    for (var element in syncRequest.result) {
      element.synced = true;
    }
    await _deleteActivities(syncRequest);
    for (var element in syncRequest.result) {
      if (element.delivery != null) {
        if (element.delivery?.status == ActivityDeliveryStatus.adjusted &&
            (element.delivery?.checked ?? false) &&
            !(element.delivery?.shouldRedo ?? true)) {
          element.lastScore = element.delivery?.score;
          element.lastScoreDate = element.delivery?.date;
        } else {
          element.lastScore = null;
          element.lastScoreDate = null;
        }
      }
    }
    return syncRequest;
  }

  Future _deleteActivities(SyncRequestDto syncRequest) async {
    syncRequest = _toDeleteActivities(syncRequest);
    for (var act in syncRequest.toDelete) {
      await deleteLocalActivity(act.code);
    }
  }

  Future deleteLocalActivity(String? code) async {
    if (AppStringUtils.isEmptyOrNull(code)) return;

    var list = await getActivitiesFromDataBase();

    var activity = list.firstWhereOrNull((element) => element.code == code);

    if (activity == null) return;

    //await StorageUtil.deleteFiles(activity.localLink);

    activity.localLink = "";
    await _repository.upsert(list);
    return list;
  }

  SyncRequestDto _toDeleteActivities(SyncRequestDto syncRequest) {
    syncRequest.toDelete = [];

    if (!syncRequest.isSuccessfullySendingScores ||
        syncRequest.fromDb.isEmpty ||
        syncRequest.result.isEmpty) {
      return syncRequest;
    }

    syncRequest.toDelete = syncRequest.fromDb
        .where((db) =>
            syncRequest.result.firstWhereOrNull((r) => r.code == db.code) ==
                null &&
            !AppStringUtils.isEmptyOrNull(db.localLink))
        .toList();

    return syncRequest;
  }

  Future<SyncRequestDto> getActivitiesFromService(
      SyncRequestDto syncRequest) async {
    syncRequest = await _checkInternetConnection(syncRequest);

    if (syncRequest.hasNoInternet) return syncRequest;

    var allowSync = await _allowedSync(syncRequest.isManual);

    syncRequest.fromService = [];

    if (allowSync) {
      try {
        syncRequest.fromService = await _service.getActivities();
      } catch (err) {
        syncRequest.isSuccessfullyReceivingActivities = false;
        syncRequest.receiveNewErrorMessage =
            "Ocorreu um erro ao buscar novas aulas!";
      }
    }
    return syncRequest;
  }

  SyncRequestDto _getNewActivities(SyncRequestDto syncRequest) {
    try {
      if (syncRequest.fromService.isEmpty) return syncRequest;

      if (syncRequest.fromDb.isEmpty) {
        syncRequest.newActivites = syncRequest.fromService;
        return syncRequest;
      }

      syncRequest.newActivites = syncRequest.fromService
          .where((service) =>
              syncRequest.fromDb.firstWhereOrNull((db) {
                return db.code == service.code;
              }) ==
              null)
          .toList();
    } catch (err) {
      syncRequest.fromService = [];
      syncRequest.isSuccessfullyReceivingActivities = false;
    }
    return syncRequest;
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

  Future<SyncRequestDto> _sendDoneActivities(SyncRequestDto request) async {
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
      await _service.sendDoneActivities(doneActivities);
      for (var element in doneActivities) {
        element.scores = [];
        element.synced = true;
      }
    }
    if (markCheckedDeliveredActivities.isNotEmpty) {
      await _service.markDeliveryAsChecked(markCheckedDeliveredActivities);
    }
    if (doneFileActivities.isNotEmpty) {
      await _service.sendDoneFileActivities(doneFileActivities);
    }
    request.isSuccessfullySendingScores = true;
    return request;
  }

  Future<SyncRequestDto> _checkInternetConnection(
      SyncRequestDto syncRequest) async {
    var hasInternet = await NetworkUtils.hasInternetConnection();

    if (!hasInternet) {
      syncRequest.hasNoInternet = true;
      syncRequest.isSuccessfullyReceivingActivities = false;
      syncRequest.receiveNewErrorMessage =
          "Parece que você está desconectado. Verifique sua conexão com a internet e tente novamente.";
    }
    return syncRequest;
  }

  Future<bool> _allowedSync(bool isManual) async {
    if (AppStringUtils.isEmptyOrNull(LibSession.loggedUser)) return false;

    if (isManual) return true;

    if (LibSession.syncPreference == SyncPreference.wifi) {
      var isWifi = await NetworkUtils.isWifi();

      return isWifi;
    } else if (LibSession.syncPreference == SyncPreference.automatically) {
      return true;
    }
    return isManual;
  }

  SyncRequestDto _toKeepActivities(SyncRequestDto syncRequest) {
    syncRequest.toKeep = [];

    if (syncRequest.fromDb.isEmpty) {
      return syncRequest;
    }

    if (!syncRequest.isSuccessfullyReceivingActivities) {
      syncRequest.toKeep = syncRequest.fromDb;
      return syncRequest;
    }

    if (syncRequest.fromService.isEmpty) {
      syncRequest.toKeep = syncRequest.fromDb;
      return syncRequest;
    }

    syncRequest.toKeep = syncRequest.fromDb.where((db) {
      var found = syncRequest.fromService
          .firstWhereOrNull((service) => db.code == service.code);
      if (shouldUpdate(found, db)) {
        db.lastScore = found?.lastScore;
        db.lastScoreDate = found?.lastScoreDate;
        db.synced = true;
      } else if ((db.synced ?? false) &&
          found != null &&
          found.lastScore != db.lastScore) {
        db.lastScore = found.lastScore;
        db.lastScoreDate = found.lastScoreDate;
        db.scores = [];
        db.synced = true;
      }
      if (db.delivery == null && found?.delivery != null) {
        db.delivery = found?.delivery;
      }
      return found != null;
    }).toList();
    for (var element in syncRequest.toKeep) {
      element.synced = true;
    }
    return syncRequest;
  }

  bool shouldUpdate(ActivityDto? found, ActivityDto db) {
    if (found == null) return false;
    if (found.type == ActivityType.exam) {
      if (found.lastScore == null && found.lastScoreDate != null) return true;
    }
    return found.lastScoreDate != null &&
        found.lastScore != null &&
        (db.lastScoreDate == null ||
            DateTime.parse(found.lastScoreDate!)
                .isBefore(DateTime.parse(db.lastScoreDate!)));
  }
}
