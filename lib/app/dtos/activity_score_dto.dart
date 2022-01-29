import 'activity_scorm_dto.dart';

class ActivityScoreDto {
  final int? score;
  final DateTime? scoreDate;
  final ActivityScormDto? scorm;

  ActivityScoreDto({this.score, this.scoreDate, this.scorm});
}
