import 'package:creator_activity/app/controllers/stores/activity_store.dart';
import 'package:creator_activity/app/lib_session.dart';
import 'package:creator_activity/app/logics/generics/activity_logic.dart';
import 'package:mobx/mobx.dart';

import 'package:creator_activity/app/controllers/activity_controller.dart';

part 'corp_pending_controller.g.dart';

class CorpPendingController = _CorpPendingControllerBase
    with _$CorpPendingController;

abstract class _CorpPendingControllerBase extends ActivityController
    with Store {
  _CorpPendingControllerBase(ActivityLogic logic) : super(logic);

  @override
  Future<String?> generateActivityLink(ActivityStore store) async {
    return "file://${store.dto?.localLink}/index.html?app-offline=true&usuario=${LibSession.loggedUser}&nome=${LibSession.loggedUserName}&prova=${store.dto?.isExam ?? false}";
  }

  @override
  @action
  Future<void> openActivity(ActivityStore store) async {
    var link = await generateActivityLink(store);

    await navigateToWebView(link!, store.dto!);

    activitiesSource.removeWhere((element) => element.hasScore());

    applyViewConfig();
  }
}
