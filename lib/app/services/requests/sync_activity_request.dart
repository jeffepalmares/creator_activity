import 'dart:convert';
import 'package:commons_flutter/utils/app_date_utils.dart';
import 'package:commons_flutter/utils/app_string_utils.dart';
import 'package:commons_flutter/utils/encode_utils.dart';
import 'package:creator_activity/app/dtos/activity_dto.dart';
import 'package:dio/dio.dart';

class SyncAtividadeRequest {
  static Map<String, dynamic> build(List<ActivityDto> activities) {
    List<String> data = [];
    int count = 0;
    activities.forEach((element) {
      if (element.scores?.isNotEmpty ?? false) {
        element.scores?.forEach((e) {
          count++;
          data.add(json.encode({
            "registro_id": count,
            "projeto_id": element.id,
            "nota": e.score.toString(),
            "data": AppDateUtils.formatDate(e.scoreDate),
            "scorm": e.scorm
          }));
        });
      }
    });
    return {"atividades": '$data'};
  }

  static List<FormData> buildFileRequest(ActivityDto activity) {
    List<FormData> list = activity.files
            ?.map((e) => FormData.fromMap({
                  'projeto': activity.id,
                  'conteudo[]': MultipartFile.fromBytes(
                      EncodeUtils.base64ToBytes(
                          AppStringUtils.defaultValue(e.content)),
                      filename: e.name),
                }))
            .toList() ??
        [];

    return list;
  }
}
