import 'package:commons_flutter/utils/dependency_injector.dart';
import 'package:creator_activity/app/controllers/open_activity_controller.dart';
import 'package:creator_activity/app/dtos/activity_dto.dart';
import 'package:creator_activity/app/utils/dialog_utils.dart';
import 'package:creator_activity/app/widgets/app_widgets.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';

class OpenActivityWebViewPage extends StatefulWidget {
  final String title;

  const OpenActivityWebViewPage(
      {Key? key, this.title = 'OpenActivityWebViewPage'})
      : super(key: key);

  @override
  OpenActivityWebViewPageState createState() => OpenActivityWebViewPageState();
}

class OpenActivityWebViewPageState extends State<OpenActivityWebViewPage> {
  String link = "";
  ActivityDto dto = ActivityDto();
  OpenActivityController controller =
      DependencyInjector.get<OpenActivityController>();

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight
    ]);
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge,
        overlays: SystemUiOverlay.values);

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map;
    link = args["link"] as String;
    dto = args["dto"] as ActivityDto;
    controller.state = true;
    return SafeArea(
      child: AppWidgets.observerBuilder(
        (p0) => Stack(
          children: [
            _getWebView(context),
            controller.state ? AppWidgets.loading() : const SizedBox(),
          ],
        ),
      ),
    );
  }

  Widget _getWebView(BuildContext context) {
    return WebView(
      initialUrl: link,
      initialMediaPlaybackPolicy: AutoMediaPlaybackPolicy.always_allow,
      javascriptMode: JavascriptMode.unrestricted,
      onPageFinished: (url) => controller.finishLoad(),
      onWebResourceError: (err) {
        if (err.errorType == WebResourceErrorType.unknown) {
          return;
        }
        DialogUtils.presentDialog(
            context, "Oops!", "Houve um erro ao carregar sua aula!",
            ontap: () => Navigator.pop(context));
      },
      javascriptChannels: {
        getCloseJsChannel(),
        getSaveScoreJsChannel(),
        getDeliveryFileOnline(),
        getDeliveryFileOffline(),
      },
    );
  }

  JavascriptChannel getCloseJsChannel() {
    return JavascriptChannel(
        name: "appCloseClass",
        onMessageReceived: (JavascriptMessage message) {
          Navigator.pop(this.context);
        });
  }

  JavascriptChannel getSaveScoreJsChannel() {
    return JavascriptChannel(
        name: "appOffineSetDadosAula",
        onMessageReceived: (JavascriptMessage jsmessage) async {
          try {
            await controller.saveActivityScore(jsmessage.message, dto);
            dto.showPopup = true;
            Navigator.pop(context);
          } catch (err) {
            Navigator.pop(context);
          }
        });
  }

  JavascriptChannel getDeliveryFileOnline() {
    return JavascriptChannel(
        name: "onlineDeliveryFile",
        onMessageReceived: (JavascriptMessage jsmessage) async {
          try {
            await controller.saveFileActivity(jsmessage.message, dto);
          } catch (err) {
            print(err);
            Navigator.pop(context);
          }
        });
  }

  JavascriptChannel getDeliveryFileOffline() {
    return JavascriptChannel(
        name: "offlineDeliveryFile",
        onMessageReceived: (JavascriptMessage jsmessage) async {
          try {
            await controller.saveFileActivity(jsmessage.message, dto);
          } catch (err) {
            print(err);
            Navigator.pop(context);
          } finally {
            Navigator.pop(context);
          }
        });
  }
}
