import 'package:collection/collection.dart';
import 'package:commons_flutter/storage/local_storage.dart';
import 'package:commons_flutter/utils/network_utils.dart';

import 'package:creator_activity/app/dtos/activity_dto.dart';
import 'package:creator_activity/app/enums/sync_preference_enum.dart';
import 'package:creator_activity/app/lib_session.dart';
import 'package:creator_activity/app/logics/generics/file_activity_logic.dart';
import 'package:creator_activity/app/logics/helpers/file_activity_logic_helper.dart';
import 'package:creator_activity/app/services/actvity_service.dart';

import '../generics/activity_download_logic.dart';
import '../generics/activity_logic.dart';
import '../helpers/sync_activity_logic_helper.dart';

abstract class StudentActivityLogic extends ActivityLogic {
  final StudentActivityService service;
  final ILocalStorage repository;
  final ActivityDownloadLogic downloadLogic;

  StudentActivityLogic(this.service, this.repository, this.downloadLogic,
      FileActivityLogic fileLogic)
      : super(fileLogic);

  @override
  Future<List<ActivityDto>> getActivities() async {
    var activities = await repository.getByKey(LibSession.loggedUser);
    return activities ?? [];
  }

  Future<List<ActivityDto>> findActivities(
      List<ActivityDto> fromDb, bool isManual) async {
    try {
      List<ActivityDto> result = await syncActivities(fromDb, isManual);

      await repository.upsert(result);

      result.sort((a, b) {
        return a.name!.toLowerCase().compareTo(b.name!.toLowerCase());
      });

      return result;
    } catch (err) {
      rethrow;
    }
  }

  Future<List<ActivityDto>> syncActivities(
      List<ActivityDto> fromDb, bool isManual) async {
    List<ActivityDto> fromService = await getActivitiesFromService(isManual);

    List<ActivityDto> result = [];
    result.addAll(
        SyncActivityLogicHelper.getOnlyNewActivities(fromDb, fromService));
    result.addAll(
        SyncActivityLogicHelper.getActivitiesToKeep(fromDb, fromService));

    for (var element in result) {
      element.synced = true;
    }

    await deleteActivities(
        SyncActivityLogicHelper.toDeleteDownloadedActivities(fromDb, result));

    FileActivityLogicHelper.updateFileActivityScore(result);

    return result;
  }

  @override
  Future<ActivityDto> deleteDownloadedActivity(ActivityDto dto) async {
    var list = await getActivities();

    await deleteDownloadedActivitiesFiles(dto);

    dto.localLink = "";

    for (var element in list) {
      if (element.code == dto.code) element.localLink = "";
    }

    await repository.upsert(list);

    return dto;
  }

  Future<List<ActivityDto>> getActivitiesFromService(bool isManual) async {
    List<ActivityDto> fromService = [];

    if (!(await NetworkUtils.hasInternetConnection())) return fromService;

    var allowSync = await SyncActivityLogicHelper.allowedSync(isManual);

    if (allowSync) {
      try {
        fromService = await service.getActivities();
      } catch (err) {
        return fromService;
      }
    }
    return fromService;
  }

  @override
  Future<String> downloadActivity(
      String code, Function(String) onReceive) async {
    try {
      var list = await getActivities();
      var dto = list.firstWhereOrNull((element) => element.code == code);
      if (dto == null) return code;
      dto.localLink = await downloadLogic.downloadActivity(code, onReceive);
      await updateActivity(dto);
      return dto.localLink!;
    } catch (err) {
      //TODO send error to analytics
      rethrow;
    }
  }

  @override
  Future<ActivityDto> updateActivity(ActivityDto dto) async {
    try {
      var list = await getActivities();
      list.removeWhere((element) => element.code == dto.code);
      list.add(dto);
      await repository.upsert(list);
      return dto;
    } catch (err) {
      rethrow;
    }
  }

  Future<List<ActivityDto>> sendDoneActivities(
      List<ActivityDto> list, bool isManual) async {
    if (!(await _validateSendDoneActivities(list, isManual))) return list;

    var markCheckedDeliveredActivities =
        FileActivityLogicHelper.toMarkAsChecked(list);

    var doneActivities = getDoneActivities(list);

    var doneFileActivities = FileActivityLogicHelper.doneFileActivities(list);

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

    return list;
  }

  Future<bool> _validateSendDoneActivities(
      List<ActivityDto> list, bool isManual) async {
    if (list.isEmpty) return false;

    if (LibSession.syncPreference == SyncPreference.manual && !isManual) {
      return false;
    }

    var isWifi = await NetworkUtils.isWifi();

    if (LibSession.syncPreference == SyncPreference.wifi && !isWifi) {
      return false;
    }
    return true;
  }
}
