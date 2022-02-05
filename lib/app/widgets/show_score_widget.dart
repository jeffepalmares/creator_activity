import 'package:commons_flutter/utils/app_navigator.dart';
import 'package:commons_flutter/utils/regex_utils.dart';
import 'package:creator_activity/app/constants/color_constants.dart';
import 'package:creator_activity/app/constants/lib_icons.dart';
import 'package:creator_activity/app/controllers/activity_controller.dart';
import 'package:creator_activity/app/controllers/stores/activity_store.dart';
import 'package:creator_activity/app/dtos/activity_delivery_content_dto.dart';
import 'package:creator_activity/app/utils/dialog_utils.dart';
import 'package:creator_activity/app/widgets/app_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:url_launcher/url_launcher.dart';

import '../lib_session.dart';
import 'file_extension_icon.dart';

class ShowScoreWidget {
  static ActivityStore? _activity;
  static ActivityController? _controller;

  static void show(
    ActivityStore act,
    ActivityController controller,
  ) {
    _controller = controller;
    _activity = act;
    DialogUtils.popup(_body(), controller.context);
  }

  static Widget _body() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _title(),
          _className(),
          _shouldRedo(),
          _message(),
          AppWidgets.heightSpacer(height: 20),
          _files(),
          AppWidgets.heightSpacer(height: 20),
          _getActions(),
        ],
      ),
    );
  }

  static Widget _title() {
    return AppWidgets.getText(
      "Correção do Professor",
      fontSize: 20,
      fontColor: ColorConstants.buttonBlue,
      fontWeight: FontWeight.w600,
    );
  }

  static Widget _className() {
    return Column(
      children: [
        _getKeyValue("Aula: ", _activity?.dto?.name ?? ""),
        _getKeyValue("Nota: ", _activity?.score ?? ""),
      ],
    );
  }

  static Widget _shouldRedo() {
    return Column(
      children: [
        AppWidgets.heightSpacer(height: 20),
        AppWidgets.getText(
          (_activity?.dto?.delivery?.shouldRedo ?? true)
              ? "! É necessário refazer a aula"
              : "",
          fontColor: Colors.red,
          fontWeight: FontWeight.bold,
        ),
        AppWidgets.heightSpacer(height: 20),
      ],
    );
  }

  static Widget _message() {
    return Column(
      children: [
        _getKeyValue("Mensagem: ", _activity?.dto?.delivery?.feedback ?? ""),
        _getKeyValue(
            "Data da mensagem: ", _activity?.dto?.delivery?.feedbackDate ?? ""),
      ],
    );
  }

  static Widget _files() {
    var list = _activity?.dto?.delivery?.contents
            ?.map((e) => _getFileLink(e))
            .toList() ??
        [];
    return Column(
      children: list,
    );
  }

  static Widget _getFileLink(ActivityDeliveryContentDto content) {
    var extension = RegexUtils.extractStringMatch(content.content, r"[^.]+$");

    Widget icon = FileExtensionIcon.getByExtension(extension);

    return Column(
      children: [
        AppWidgets.line(),
        GestureDetector(
          onTap: () => launch(
              "https://repositorio.creator4all.com/api/entrega/arquivo/${content.content}/${LibSession.httpToken}"),
          child: Row(
            children: [
              icon,
              Flexible(
                child: Text(
                  "Arquivo $extension (Baixar Arquivo)",
                  style:
                      TextStyle(fontSize: 16, color: ColorConstants.buttonBlue),
                ),
              )
            ],
          ),
        )
      ],
    );
  }

  static Widget _getKeyValue(String field, String value) {
    return Row(
      children: [
        AppWidgets.getText(
          field,
          fontWeight: FontWeight.bold,
          fontColor: Colors.black,
        ),
        AppWidgets.getText(value),
      ],
    );
  }

  static Widget _getActions() {
    var list = <Widget>[];
    if (_activity?.dto?.delivery?.shouldRedo ?? true) {
      list.add(_redoNow());
      list.add(_redoLater());
    } else {
      list.add(_close());
    }
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: list,
    );
  }

  static Widget _close() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(primary: Colors.green),
      onPressed: () async {
        await _controller?.checkFileActivity(_activity!.dto!);
        AppNavigator.pop(_controller!.context);
      },
      child: Row(
        children: [
          LibIcons.generateIcon(LibIcon.redo, color: Colors.white),
          Padding(
            padding: const EdgeInsets.only(left: 8),
            child: AppWidgets.getText("Entendi", fontColor: Colors.white),
          )
        ],
      ),
    );
  }

  static Widget _redoNow() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(primary: Colors.green),
      onPressed: () async {
        await _controller!.checkFileActivity(_activity!.dto!);
        await _controller!.openActivity(_activity!);
        AppNavigator.pop(_controller!.context);
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          LibIcons.generateIcon(LibIcon.redo, color: Colors.white),
          Padding(
            padding: const EdgeInsets.only(left: 5),
            child: AppWidgets.getText("Refazer agora", fontColor: Colors.white),
          )
        ],
      ),
    );
  }

  static Widget _redoLater() {
    return TextButton(
        onPressed: () async {
          await _controller!.checkFileActivity(_activity!.dto!);
          _controller!.removeActivity(_activity!.dto!);
          AppNavigator.pop(_controller!.context);
        },
        child: AppWidgets.getText(
          "Refazer depois",
          fontColor: Colors.grey[900],
          other: const TextStyle(decoration: TextDecoration.underline),
        ));
  }
}
