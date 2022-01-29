import 'package:commons_flutter/utils/app_date_utils.dart';
import 'package:commons_flutter/utils/app_string_utils.dart';
import 'package:creator_activity/app/constants/activity_delivery_status.dart';
import 'package:creator_activity/app/enums/activity_status_enum.dart';
import 'package:creator_activity/app/enums/activity_type_enum.dart';

import 'activity_class_dto.dart';
import 'activity_delivery_dto.dart';
import 'activity_file_dto.dart';
import 'activity_score_dto.dart';

class ActivityDto {
  String? id;
  String? code;
  String? name;
  String? scheduleId;
  String? start;
  String? end;
  String? age;
  bool? isExam;
  String? lastScore;
  String? lastScoreDate;
  String? localLink;
  String? link;
  ActivityType? type;
  bool? synced = false;
  ActivityClassDto? activityClass;
  bool? showPopup = false;
  List<ActivityScoreDto>? scores = [];
  List<ActivityFileDto>? files = [];
  ActivityStatus? status;
  ActivityDeliveryDto? delivery;

  ActivityDto({
    this.id,
    this.code,
    this.age,
    this.name,
    this.scheduleId,
    this.start,
    this.end,
    this.isExam,
    this.lastScore,
    this.localLink,
    this.lastScoreDate,
    this.link,
    this.scores,
    this.synced,
    this.activityClass,
    this.type,
    this.files,
    this.status,
    this.delivery,
  });

  get score {
    return lastScore;
  }

  addScore(ActivityScoreDto scoreDto) {
    lastScore = scoreDto.score.toString();
    lastScoreDate = AppDateUtils.formatDate(scoreDto.scoreDate);
    scores = scores ?? [];
    scores?.add(scoreDto);
  }

  bool hasScore() {
    return AppStringUtils.isNotEmptyOrNull(lastScore);
  }

  bool isDone() {
    return hasScore() ||
        (delivery == null && (files?.isNotEmpty ?? false)) ||
        (ActivityDeliveryStatus.pending == delivery?.status) ||
        (ActivityDeliveryStatus.adjusted == delivery?.status &&
            !(delivery?.checked ?? false)) ||
        (ActivityDeliveryStatus.adjusted == delivery?.status &&
            ((delivery?.checked ?? false) &&
                (!(delivery?.shouldRedo ?? false))));
  }
}
