import 'package:commons_flutter/utils/encode_utils.dart';
import 'package:commons_flutter/utils/app_navigator.dart';
import 'package:creator_activity/app/constants/lib_routes.dart';
import 'package:creator_activity/app/controllers/activity_helper.dart';
import 'package:creator_activity/app/dtos/activity_dto.dart';
import 'package:creator_activity/app/enums/action_state_enum.dart';
import 'package:creator_activity/app/lib_session.dart';
import 'package:creator_activity/app/utils/dialog_utils.dart';
import 'package:creator_activity/logics/activity_logic.dart';
import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';

import 'stores/activity_store.dart';
part 'activity_controller.g.dart';

abstract class ActivityController = _ActivityControllerBase
    with _$ActivityController;

abstract class _ActivityControllerBase with Store {
  final ActivityLogic _logic;

  late BuildContext context;

  @observable
  ActionState state = ActionState.loading;

  @observable
  ObservableList<ActivityStore> activities =
      ObservableList<ActivityStore>.of([]).asObservable();

  List<ActivityDto> activitiesSource = [];

  _ActivityControllerBase(this._logic);

  Future<String?> generateActivityLink(ActivityStore store);

  Future<void> openActivity(ActivityStore store);

  Future<List<ActivityDto>> loadActivities();

  Future<void> syncActivities();

  @action
  Future<void> deleteDownloadedActivity(ActivityStore activity) async {
    activity.isDownloading = true;
    activity.dto = await _logic.deleteDownloadedActivity(activity.dto!);
    activity.isDownloaded = false;
    activity.isDownloading = false;
  }

  @action
  Future<void> downloadActivity(ActivityStore activity) async {
    activity.isDownloading = true;
    var path = await _logic.downloadActivity(activity.dto!.code!,
        (String percent) => activity.downloadingPercent = "$percent %");
    activity.isDownloading = false;
    activity.dto?.localLink = path;
    activity.isDownloaded = true;
  }

  @computed
  bool get isLoading {
    return state == ActionState.loading;
  }

  @computed
  int get listSize {
    return activities.length;
  }

  Future<void> doOpenActivity(ActivityStore store) async {
    state = ActionState.loading;

    store.dto = await _logic.checkLastDeliveryStatus(store.dto!);

    if (!(await ActivityHelper.validateCanOpen(
        store, LibSession.loggedAge, context))) {
      return;
    }

    var link = await generateActivityLink(store);

    if (link == null) return;

    link = EncodeUtils.encodeUri(link);

    debugPrint('Link: $link');

    await AppNavigator.pushNamed(LibRoutes.openActivity,
        arguments: {"link": link, 'dto': store.dto});
    store.setScore();

    if (store.dto?.showPopup ?? false) {
      DialogUtils.presentDialog(context, "Sucesso",
          "Nota gravada com sucesso.\nNota: ${store.score}%");
      store.dto?.showPopup = false;
    }

    state = ActionState.success;
  }

  @action
  void applyViewConfig() {
    state = ActionState.loading;
    activities = ActivityHelper.aplyViewConfig(activitiesSource);
    state = ActionState.success;
  }

  @action
  Future<void> checkFileActivity(ActivityDto dto) async {
    await _logic.checkFileActivity(dto);
  }

  @action
  Future<void> removeActivity(ActivityDto dto) async {
    activitiesSource.removeWhere((element) => element.code == dto.code);

    activities = ObservableList<ActivityStore>.of(
        activitiesSource.map((e) => ActivityStore(e))).asObservable();
  }
}
