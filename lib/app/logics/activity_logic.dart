import 'package:creator_activity/app/dtos/activity_dto.dart';
import 'package:creator_activity/app/dtos/sync_request_dto.dart';

abstract class ActivityLogic {
  Future<void> checkFileActivity(ActivityDto dto);

  Future<ActivityDto> checkLastDeliveryStatus(ActivityDto dto);

  Future<ActivityDto> deleteDownloadedActivity(ActivityDto dto);

  Future<List<ActivityDto>> loadActivities(SyncRequestDto dto);

  Future<String> downloadActivity(
      String code, Function(String percent) onReceive);
}
