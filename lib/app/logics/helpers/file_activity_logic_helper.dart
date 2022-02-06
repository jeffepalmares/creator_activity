import 'package:creator_activity/app/constants/activity_delivery_status.dart';
import 'package:creator_activity/app/dtos/activity_dto.dart';
import 'package:creator_activity/app/enums/activity_type_enum.dart';

class FileActivityLogicHelper {
  static void updateFileActivityScore(List<ActivityDto> list) {
    for (var element in list) {
      if (_isFileAndHasDelivery(element)) {
        if (_shouldUpdateScoreFromDelivery(element)) {
          element.lastScore = element.delivery?.score;
          element.lastScoreDate = element.delivery?.date;
        } else {
          element.lastScore = null;
          element.lastScoreDate = null;
        }
      }
    }
  }

  static List<ActivityDto> toMarkAsChecked(List<ActivityDto> list) {
    return list
        .where((element) =>
            ActivityType.file == element.type &&
            !(element.synced ?? false) &&
            (element.delivery?.checked ?? false))
        .toList();
  }

  static List<ActivityDto> doneFileActivities(List<ActivityDto> list) {
    return list
        .where(
          (element) =>
              !(element.synced ?? false) &&
              ActivityType.file == element.type &&
              (element.files?.isNotEmpty ?? false),
        )
        .toList();
  }

  static bool _shouldUpdateScoreFromDelivery(ActivityDto dto) {
    return ActivityDeliveryStatus.adjusted == dto.delivery?.status &&
        (dto.delivery?.checked ?? false) &&
        !(dto.delivery?.shouldRedo ?? false);
  }

  static bool _isFileAndHasDelivery(ActivityDto dto) {
    return ActivityType.file == dto.type && dto.delivery != null;
  }
}
