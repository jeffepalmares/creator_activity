import 'package:commons_flutter/utils/app_date_utils.dart';
import 'package:commons_flutter/utils/app_string_utils.dart';
import 'package:commons_flutter/utils/network_utils.dart';
import 'package:creator_activity/app/dtos/activity_dto.dart';
import 'package:collection/collection.dart';
import 'package:creator_activity/app/enums/activity_type_enum.dart';
import 'package:creator_activity/app/enums/sync_preference_enum.dart';

import '../../lib_session.dart';

abstract class SyncActivityLogicHelper {
  static List<ActivityDto> getOnlyNewActivities(
      List<ActivityDto> fromDb, List<ActivityDto> fromService) {
    try {
      List<ActivityDto> list = [];
      if (fromDb.isEmpty) {
        return fromService;
      }

      list = fromService
          .where((service) =>
              fromDb.firstWhereOrNull((db) => db.code == service.code) == null)
          .toList();
      return list;
    } catch (err) {
      return [];
    }
  }

  static List<ActivityDto> getActivitiesToKeep(
      List<ActivityDto> fromDb, List<ActivityDto> fromService) {
    List<ActivityDto> toKeep = [];

    if (fromDb.isEmpty) {
      return toKeep;
    }

    if (fromService.isEmpty) {
      return fromDb;
    }

    toKeep = fromDb.where((db) {
      var found = _findIn(db, fromService);
      found = _validateAndUpdate(found, db);
      return found != null;
    }).toList();
    for (var element in toKeep) {
      element.synced = true;
    }
    return toKeep;
  }

  static List<ActivityDto> toDeleteDownloadedActivities(
      List<ActivityDto> fromDb, List<ActivityDto> result) {
    List<ActivityDto> toDelete = [];

    if (fromDb.isEmpty || result.isEmpty) {
      return toDelete;
    }

    toDelete = fromDb
        .where((db) =>
            result.firstWhereOrNull((r) => r.code == db.code) == null &&
            !AppStringUtils.isEmptyOrNull(db.localLink))
        .toList();

    return toDelete;
  }

  static ActivityDto? _validateAndUpdate(ActivityDto? found, ActivityDto db) {
    if (found == null) return null;
    if (_shouldUpdate(found, db)) {
      db.lastScore = found.lastScore;
      db.lastScoreDate = found.lastScoreDate;
      db.synced = true;
    } else if (_localIsSyncedButServiceHasDiferentScore(found, db)) {
      db.lastScore = found.lastScore;
      db.lastScoreDate = found.lastScoreDate;
      db.scores = [];
      db.synced = true;
    }
    if (db.delivery == null && found.delivery != null) {
      db.delivery = found.delivery;
    }
    return found;
  }

  static bool _localIsSyncedButServiceHasDiferentScore(
      ActivityDto? found, ActivityDto db) {
    return ((db.synced ?? false) &&
        found != null &&
        found.lastScore != db.lastScore);
  }

  static ActivityDto? _findIn(ActivityDto db, List<ActivityDto> fromService) {
    return fromService.firstWhereOrNull((service) => service.code == db.code);
  }

  static bool _shouldUpdate(ActivityDto? found, ActivityDto db) {
    if (found == null) return false;

    //em caso de prova o professor pode anular a nota da prova forçadamente, neste caso deve-se atualizar a nota local.
    if (ActivityType.exam == found.type &&
        found.lastScore == null &&
        found.lastScoreDate != null) {
      return true;
    }

    return _hasScoreAndScoreDate(found) &&
        _scoreDateIsNullOrOlder(db.lastScoreDate, found.lastScoreDate);
  }

  static bool _hasScoreAndScoreDate(ActivityDto dto) {
    return AppStringUtils.isNotEmptyOrNull(dto.lastScore) &&
        AppStringUtils.isNotEmptyOrNull(dto.lastScoreDate);
  }

  static bool _scoreDateIsNullOrOlder(String? dbDate, String? serviceDate) {
    if (AppStringUtils.isEmptyOrNull(serviceDate)) return false;

    if (AppStringUtils.isEmptyOrNull(dbDate)) return true;

    return AppDateUtils.stringToDate(dbDate!)
        .isBefore(AppDateUtils.stringToDate(serviceDate!));
  }

  static Future<bool> allowedSync(bool isManual) async {
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
}
