import 'package:commons_flutter/utils/encode_utils.dart';
import 'package:commons_flutter/utils/regex_utils.dart';
import 'package:creator_activity/app/dtos/activity_dto.dart';
import 'package:creator_activity/app/dtos/activity_file_dto.dart';
import 'package:creator_activity/app/dtos/activity_score_dto.dart';
import 'package:creator_activity/app/dtos/scorm_dto.dart';
import 'package:creator_activity/app/logics/webview/open_activity_logic.dart';
import 'package:mobx/mobx.dart';

part 'open_activity_controller.g.dart';

class OpenActivityController = _OpenActivityControllerBase
    with _$OpenActivityController;

abstract class _OpenActivityControllerBase with Store {
  final OpenActivityLogic _logic;

  _OpenActivityControllerBase(this._logic);

  @observable
  bool state = true;

  @action
  finishLoad() {
    state = false;
  }

  Future<void> saveActivityScore(String stringJson, ActivityDto dto) async {
    try {
      var result = EncodeUtils.stringToJson(stringJson);
      var scorm = ScormDto.fromJson(result);
      var score = scorm.tentativa?.core?.score?.raw;
      var activityScore = ActivityScoreDto(
          score: score, scoreDate: DateTime.now(), scorm: scorm.tentativa);
      dto.addScore(activityScore);
      await _logic.updateActivity(dto);
    } catch (err) {}
  }

  Future<void> saveFileActivity(String stringJson, ActivityDto dto) async {
    try {
      var rawFiles = EncodeUtils.jsonToString(stringJson) as List<dynamic>;
      dto.files = [];
      for (var file in rawFiles) {
        var base64 = file['base64'];
        var data = RegexUtils.extractStringMatch(base64, r"data:(.*),") ?? "";
        var content = base64.toString().replaceAll(data, "");

        dto.files?.add(ActivityFileDto(
          name: file['nome'],
          content: content,
          extension: file['formato'],
        ));
      }

      await _logic.updateActivity(dto);
    } catch (err) {}
  }
}
