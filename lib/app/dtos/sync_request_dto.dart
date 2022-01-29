import 'activity_dto.dart';

class SyncRequestDto {
  final bool isManual;
  List<ActivityDto> fromDb = [];
  List<ActivityDto> fromService = [];
  List<ActivityDto> newActivites = [];
  List<ActivityDto> toDelete = [];
  List<ActivityDto> toKeep = [];
  List<ActivityDto> result = [];
  String sendingScoreErrorMessage = "";
  String receiveNewErrorMessage = "";
  bool isSuccessfullySendingScores = false;
  bool isSuccessfullyReceivingActivities = true;
  bool hasNoInternet = false;
  bool allowDownload = false;

  SyncRequestDto(this.isManual);
}
