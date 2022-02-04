import 'package:collection/collection.dart';
import 'package:commons_flutter/storage/local_storage.dart';
import 'package:commons_flutter/utils/app_date_utils.dart';
import 'package:commons_flutter/utils/app_string_utils.dart';
import 'package:commons_flutter/utils/disk_utils.dart';
import 'package:commons_flutter/utils/network_utils.dart';
import 'package:creator_activity/app/constants/activity_delivery_status.dart';
import 'package:creator_activity/app/dtos/activity_dto.dart';
import 'package:creator_activity/app/dtos/sync_request_dto.dart';
import 'package:creator_activity/app/enums/activity_type_enum.dart';
import 'package:creator_activity/app/enums/sync_preference_enum.dart';
import 'package:creator_activity/app/lib_session.dart';
import 'package:creator_activity/app/services/actvity_service.dart';
import 'package:creator_activity/logics/activity_download_logic.dart';
import 'package:creator_activity/logics/activity_logic.dart';

abstract class StudentActivityLogic extends ActivityLogic {
  final StudentActivityService service;
  final ILocalStorage repository;
  final ActivityDownloadLogic downloadLogic;

  StudentActivityLogic(this.service, this.repository, this.downloadLogic);

  Future<List<ActivityDto>> getActivities(SyncRequestDto syncRequest) async {
    try {
      if (AppStringUtils.isEmptyOrNull(LibSession.loggedUser)) {
        return [];
      }

      syncRequest.fromDb = await getActivitiesFromDataBase();

      syncRequest = await syncActivities(syncRequest);

      await repository.upsert(syncRequest.result);

      syncRequest.result.sort((a, b) {
        return a.name!.toLowerCase().compareTo(b.name!.toLowerCase());
      });

      return syncRequest.result;
    } catch (err) {
      rethrow;
    }
  }

  @override
  Future<void> checkFileActivity(ActivityDto dto) async {}

  @override
  Future<ActivityDto> checkLastDeliveryStatus(ActivityDto dto) async {
    return dto;
  }

  Future<List<ActivityDto>> getActivitiesFromDataBase() async {
    var activities = await repository.getByKey(LibSession.loggedUser);
    return activities;
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
      if (ActivityType.file == element.type && element.delivery != null) {
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
      await deleteDownloadedActivity(act);
    }
  }

  @override
  Future<ActivityDto> deleteDownloadedActivity(ActivityDto dto) async {
    var list = await getActivitiesFromDataBase();

    if (AppStringUtils.isNotEmptyOrNull(dto.localLink)) {
      await DiskUtils.deleteFiles(dto.localLink!);
    }

    dto.localLink = "";

    for (var element in list) {
      if (element.code == dto.code) element.localLink = "";
    }

    await repository.upsert(list);

    return dto;
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
        syncRequest.fromService = await service.getActivities();
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

  @override
  Future<String> downloadActivity(
      String code, Function(String) onReceive) async {
    try {
      return await downloadLogic.downloadActivity(code, onReceive);
    } catch (err) {
      //TODO send error to analytics
      rethrow;
    }
  }
}
