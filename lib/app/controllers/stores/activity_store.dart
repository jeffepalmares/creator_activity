import 'package:commons_flutter/utils/app_string_utils.dart';
import 'package:creator_activity/app/dtos/activity_dto.dart';
import 'package:mobx/mobx.dart';
part 'activity_store.g.dart';

class ActivityStore = _ActivityStore with _$ActivityStore;

abstract class _ActivityStore with Store {
  ActivityDto? dto;

  _ActivityStore(ActivityDto dto) {
    dto = dto;
    isDownloaded = !AppStringUtils.isEmptyOrNull(dto.localLink);
    hasScore = dto.hasScore();
    score = this.dto?.score;
  }

  @observable
  bool isDownloading = false;

  @observable
  bool isDownloaded = false;

  @observable
  bool hasScore = false;

  @observable
  String downloadingPercent = "0";

  @observable
  String score = "0";

  @action
  setScore() {
    score = dto?.score;
  }
}
