import 'package:creator_activity/app/dtos/activity_dto.dart';
import 'package:commons_flutter/storage/local_storage.dart';
import 'package:creator_activity/app/logics/corp/corp_activity_logic.dart';
import 'package:creator_activity/app/services/corp/corp_activity_service.dart';
import 'package:creator_activity/app/logics/generics/file_activity_logic.dart';
import 'package:creator_activity/app/logics/generics/activity_download_logic.dart';

class CoprPendingActivityLogic extends CorpActivityLogic {
  CoprPendingActivityLogic(
      ILocalStorage<ActivityDto, String> repository,
      CoprActivityService service,
      ActivityDownloadLogic downloadLogic,
      FileActivityLogic fileLogic)
      : super(repository, service, downloadLogic, fileLogic);

  @override
  Future<List<ActivityDto>> loadActivities(bool isManual) async {
    var list = await getActivities();
    list.removeWhere((act) => act.hasScore());
    return list;
  }
}
