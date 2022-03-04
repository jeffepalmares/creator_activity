import 'package:commons_flutter/utils/app_string_utils.dart';
import 'package:commons_flutter/utils/disk_utils.dart';
import 'package:commons_flutter/utils/network_utils.dart';
import 'package:creator_activity/app/dtos/activity_dto.dart';
import 'package:creator_activity/app/enums/activity_type_enum.dart';
import 'package:creator_activity/app/logics/generics/file_activity_logic.dart';

abstract class ActivityLogic {
  final FileActivityLogic fileLogic;

  ActivityLogic(this.fileLogic);

  Future<void> checkFileActivity(ActivityDto dto) async {
    dto = await fileLogic.doCheckFileActivity(dto);
    await updateActivity(dto);
  }

  Future<ActivityDto> checkLastDeliveryStatus(ActivityDto dto) async {
    if (ActivityType.file != dto.type) return dto;
    if (!(await NetworkUtils.hasInternetConnection())) return dto;
    dto = await fileLogic.doCheckLastDeliveryStatus(dto);
    await updateActivity(dto);
    return dto;
  }

  Future<ActivityDto> deleteDownloadedActivity(ActivityDto dto);

  Future<List<ActivityDto>> loadActivities(bool isManual);

  Future<String> downloadActivity(
      String code, Function(String percent) onReceive);

  Future<List<ActivityDto>> getActivities();

  Future<ActivityDto> updateActivity(ActivityDto dto);

  Future deleteDownloadedActivitiesFiles(ActivityDto? dto) async {
    if (AppStringUtils.isNotEmptyOrNull(dto?.localLink)) {
      await DiskUtils.deleteFiles(dto!.localLink!);
    }
  }

  Future deleteActivities(List<ActivityDto> toDelete) async {
    for (var act in toDelete) {
      await deleteDownloadedActivitiesFiles(act);
    }
  }

  List<ActivityDto> getDoneActivities(List<ActivityDto> list) {
    return list
        .where((element) =>
            ActivityType.file != element.type &&
            element.scores != null &&
            (element.synced ?? false) &&
            (element.scores?.isNotEmpty ?? false))
        .toList();
  }
}
