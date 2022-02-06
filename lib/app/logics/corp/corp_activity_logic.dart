import 'package:commons_flutter/exceptions/app_error.dart';
import 'package:commons_flutter/storage/local_storage.dart';
import 'package:creator_activity/app/dtos/activity_dto.dart';
import 'package:creator_activity/app/lib_session.dart';
import 'package:creator_activity/app/logics/generics/activity_download_logic.dart';
import 'package:creator_activity/app/logics/generics/activity_logic.dart';
import 'package:creator_activity/app/logics/generics/file_activity_logic.dart';
import 'package:creator_activity/app/services/corp/corp_activity_service.dart';
import 'package:flutter/widgets.dart';

abstract class CorpActivityLogic extends ActivityLogic {
  CorpActivityLogic(
    this._repository,
    this._service,
    this._downloadLogic,
    FileActivityLogic fileLogic,
  ) : super(fileLogic);

  final ILocalStorage<ActivityDto, String> _repository;
  final CoprActivityService _service;
  final ActivityDownloadLogic _downloadLogic;

  Future<List<ActivityDto>> syncActivitites(
      Function(String) onProgress, List<ActivityDto> activities,
      {Function(ActivityDto dto)? updatedActivity}) async {
    try {
      activities = activities.getRange(0, 10).toList();
      onProgress("Preparando pra baixar ${activities.length} aulas");
      await saveActivities(
        activities,
        onProgress,
        updatedActivity: updatedActivity,
      );
      return activities;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> saveActivities(
      List<ActivityDto> list, Function(String) onProgress,
      {Function(ActivityDto dto)? updatedActivity}) async {
    try {
      onProgress("Baixando Aulas");
      var count = 1;
      for (ActivityDto dto in list) {
        var progress = "Baixando Aula $count de $list.length";
        dto.localLink = await _downloadLogic.downloadActivity(
            dto.code!, (String percent) => onProgress("$progress - $percent"));
        _repository.upsert(dto);
        if (updatedActivity != null) {
          await updatedActivity(dto);
        }
        count++;
      }

      var list2 = await _repository.getAll();

      debugPrint('Aulas salvas com sucesso! ${list2.length} ');
    } catch (e) {
      throw AppError(
          'Desculpe mas algo saiu errado enquanto salvando localmente as atividades baixadas!');
    }
  }

  @override
  Future<List<ActivityDto>> getActivities() async {
    var list = await _repository.getAll();
    list = list
        .where((element) => element.classCode == LibSession.schoolClassCode)
        .toList();
    return list;
  }

  @override
  Future<ActivityDto> deleteDownloadedActivity(ActivityDto dto) async {
    return dto;
  }

  @override
  Future<String> downloadActivity(
      String code, Function(String percent) onReceive) async {
    throw UnimplementedError();
  }

  @override
  Future<ActivityDto> updateActivity(ActivityDto dto) async {
    await _repository.upsert(dto);
    return dto;
  }
}
