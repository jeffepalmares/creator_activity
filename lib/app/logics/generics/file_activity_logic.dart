import 'package:commons_flutter/utils/app_date_utils.dart';
import 'package:creator_activity/app/dtos/activity_dto.dart';
import 'package:creator_activity/app/enums/activity_type_enum.dart';
import 'package:creator_activity/app/services/file_activity_service.dart';

class FileActivityLogic {
  final FileActivityService _service;

  FileActivityLogic(this._service);

  Future<ActivityDto> doCheckFileActivity(ActivityDto dto) async {
    dto.delivery?.checked = true;
    dto.delivery?.checkedDate =
        AppDateUtils.stringToFormatedDate(DateTime.now().toIso8601String());

    await _service.markDeliveryAsChecked([dto]);

    if ((dto.delivery?.shouldRedo ?? false)) {
      dto.lastScore = null;
      dto.lastScoreDate = null;
    }

    return dto;
  }

  Future<ActivityDto> doCheckLastDeliveryStatus(ActivityDto activity) async {
    try {
      if (ActivityType.file != activity.type) return activity;

      var delivery = await _service.getActivityLastDelivery(activity);
      if (delivery != null) {
        activity.delivery = delivery;
      }
      return activity;
    } catch (err) {
      return activity;
    }
  }
}
