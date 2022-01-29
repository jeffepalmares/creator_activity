import 'package:creator_activity/app/dtos/activity_dto.dart';

abstract class ActivityLogic {
  Future<void> checkFileActivity(ActivityDto dto);

  Future<ActivityDto> checkLastDeliveryStatus(ActivityDto dto);
}
