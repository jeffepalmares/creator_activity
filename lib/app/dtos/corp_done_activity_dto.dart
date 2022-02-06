import 'activity_dto.dart';
import 'activity_score_dto.dart';

class CorpDoneActivityDto {
  String? user;
  String? userId;
  String? activityCode;
  String? link;
  String? activityId;
  ActivityDto? dto;
  int? activityScore;
  DateTime? scoreDate;
  List<ActivityScoreDto>? scores;

  CorpDoneActivityDto({
    this.user,
    this.userId,
    this.activityCode,
    this.link,
    this.activityScore,
    this.scoreDate,
    this.scores,
    this.dto,
    this.activityId,
  });
}
