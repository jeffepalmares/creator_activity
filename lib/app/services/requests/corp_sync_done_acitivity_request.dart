import 'package:commons_flutter/utils/app_date_utils.dart';
import 'package:commons_flutter/utils/encode_utils.dart';
import 'package:creator_activity/app/dtos/corp_done_activity_dto.dart';

class CorpSyncDoneActivityRequest {
  static Map<String, dynamic> build(List<CorpDoneActivityDto> activities) {
    List<dynamic> data = [];
    for (var element in activities) {
      element.scores?.forEach((e) {
        data.add({
          "projeto_id": element.activityId,
          "usuario_id": element.userId,
          "nota": e.score.toString(),
          "data": AppDateUtils.formatDate(e.scoreDate),
          "scorm": e.scorm?.toJson(),
        });
      });
    }
    return {"atividades": EncodeUtils.jsonToString(data)};
  }
}
