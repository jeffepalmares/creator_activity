import 'package:commons_flutter/utils/app_date_utils.dart';
import 'package:commons_flutter/utils/app_string_utils.dart';
import 'package:commons_flutter/utils/encode_utils.dart';
import 'package:commons_flutter/utils/network_utils.dart';
import 'package:creator_activity/app/controllers/stores/activity_store.dart';
import 'package:creator_activity/app/dtos/activity_dto.dart';
import 'package:creator_activity/app/enums/activity_type_enum.dart';
import 'package:creator_activity/app/lib_session.dart';
import 'package:creator_activity/app/utils/dialog_utils.dart';
import 'package:creator_activity/app/utils/lib_date_utils.dart';
import 'package:creator_activity/app/widgets/view_config/drop_down_options.dart';
import 'package:creator_activity/app/widgets/view_config/view_options_widget.dart';
import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';

abstract class ActivityHelper {
  static ObservableList<ActivityStore> aplyViewConfig(
      List<ActivityDto> activitiesSource) {
    var list = activitiesSource;

    if (ViewOptionsWidgets.config.from != null) {
      list = activitiesSource
          .where((element) => LibDateUtils.isBetween(
                AppDateUtils.stringToDate(element.start!),
                end: ViewOptionsWidgets.config.end,
                start: ViewOptionsWidgets.config.from,
              ))
          .toList();
    }

    if (ViewOptionsWidgets.config.sortBy == SortActivityBy.Name) {
      list.sort((a, b) => a.name!.compareTo(b.name!));
    } else {
      list.sort((a, b) => a.start!.compareTo(b.start!));
    }

    if (ViewOptionsWidgets.config.sortType == SortType.Desc) {
      list = list.reversed.toList();
    }
    var observables = list.map((e) {
      var store = ActivityStore(e);
      return store;
    }).toList();
    return ObservableList<ActivityStore>.of(observables).asObservable();
  }

  static String _generateLink(String? prefix, bool? isExam) {
    return "${prefix ?? ""}/index.html?app-offline=true&usuario=${LibSession.loggedUser}&nome=${LibSession.loggedUserName}&prova=${isExam ?? false}&is-prova=${isExam ?? false}";
  }

  static bool _isOnlineOpenActivity(ActivityStore store) {
    return !store.isDownloaded &&
        AppStringUtils.isEmptyOrNull(store.dto?.localLink);
  }

  static Future<String?> getActivityLink(
      ActivityStore store, BuildContext context) async {
    var link = "";

    if (!_isOnlineOpenActivity(store)) {
      link = _generateLink(
          "file://${store.dto?.localLink ?? ""}", store.dto?.isExam);
    } else {
      link = _generateLink(store.dto?.link, store.dto?.isExam);
    }
    if (store.dto?.type == ActivityType.file) {
      var params = getFileParams(store);

      link = "$link&sendFiles=${EncodeUtils.encodeBase64(params)}";
    }
    debugPrint(link);
    return link;
  }

  static Future<bool> validateCanOpen(ActivityStore store,
      int parentalControllAge, BuildContext context) async {
    if (store.isDownloading) return false;

    if ((store.dto?.isExam ?? false) &&
        (!AppStringUtils.isEmptyOrNull(store.dto?.lastScore) ||
            (store.dto?.scores?.isNotEmpty ?? false))) {
      DialogUtils.presentDialog(
          context, "Ops", "Provas só podem ser realizadas uma única vez!");
      return false;
    }
    if (AppStringUtils.isNotEmptyOrNull(store.dto?.age) &&
        store.dto?.age != "0" &&
        parentalControllAge < AppStringUtils.stringToNumber(store.dto?.age)) {
      DialogUtils.presentDialog(context, "Ops",
          "Seu controle parental não permite você assistir essa aula!");
      return false;
    }

    if (_isOnlineOpenActivity(store)) {
      var hasInternet = await NetworkUtils.hasInternetConnection();

      if (!hasInternet) {
        DialogUtils.presentDialog(context, "Oops!",
            "Parece que você não está conectado a internet, apenas aulas baixadas anteriormente podem ser assistidas sem internet!\nVerifique sua conexão e tente novamente!");
        return false;
      }
    }

    return true;
  }

  static String getFileParams(ActivityStore store) {
    if (!_isOnlineOpenActivity(store)) {
      return EncodeUtils.jsonToString({
        "isAppAluno": true,
        "isGravarOffline": true,
        "callback": "offlineDeliveryFile", // função sem o postMessage
        "data": {
          "projeto": store.dto?.name, // nome da aula
          "tipo": "arquivo",
          "upload_video_max_time":
              60, // informação da api de limites da plataforma
          "upload_file_max_size":
              20 // informação da api de limites da plataforma
        }
      });
    }
    return EncodeUtils.jsonToString({
      "isAppAluno": true,
      "token": LibSession.httpToken,
      "endpointUpload":
          "https://repositorio.creator4all.com/api/entrega/enviar/arquivos/atividade",
      "endpointFinish":
          "https://webservice.creator4all.com/projeto/pt-br/entrega/registrar",
      "callback": "onlineDeliveryFile", // função sem o postMessage
      "data": {
        "projeto": store.dto?.name, // nome da aula
        "tipo": "arquivo",
        "upload_video_max_time":
            60, // informação da api de limites da plataforma
        "upload_file_max_size": 20 // informação da api de limites da plataforma
      }
    });
  }
}
