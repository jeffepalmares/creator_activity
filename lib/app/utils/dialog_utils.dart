import 'package:commons_flutter/utils/app_navigator.dart';
import 'package:creator_activity/app/constants/color_constants.dart';
import 'package:creator_activity/app/widgets/app_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class DialogUtils {
  static Widget _getAlert(BuildContext context, Widget title, Widget content,
      {List<Widget>? actions, Function()? onTap}) {
    actions = actions ?? [_getButton("OK", onTap, context)];
    return AlertDialog(
      title: title,
      content: content,
      actions: actions,
    );
  }

  static void presentConfirmationDialog(BuildContext context, String title,
      String message, Function confirmationAction,
      {Function? cancelAction,
      String confirmationLabel = "Ok",
      String cancelLabel = "Cancelar"}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return _getAlert(
            context, _getTitle(title), _getText(message, fontSize: 16),
            actions: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _getButton(cancelLabel, cancelAction, context),
                  _getButton(confirmationLabel, confirmationAction, context,
                      setColor: true)
                ],
              ),
            ]);
      },
    );
  }

  static void presentDialog(BuildContext context, String title, String message,
      {Function()? ontap}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return _getAlert(context, _getTitle(title), _getText(message),
            onTap: ontap);
      },
    );
  }

  static void popup(Widget content, BuildContext context) {
    showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
              content: content,
            ));
  }

  static Text _getTitle(String text,
      {TextAlign textAlignment = TextAlign.left}) {
    return AppWidgets.getText(text,
        fontSize: 16,
        fontColor: ColorConstants.defaultBlue,
        textAlign: textAlignment);
  }

  static Text _getText(String text,
      {TextAlign textAlignment = TextAlign.left, double? fontSize}) {
    return AppWidgets.getText(text,
        textAlign: textAlignment, fontSize: fontSize);
  }

  static Widget _getButton(String label, Function? onTap, BuildContext context,
      {bool? setColor, double? width, Color? labelColor}) {
    setColor = setColor ?? false;
    labelColor = labelColor ?? (setColor ? Colors.white : Colors.blue);
    return Align(
      alignment: Alignment.center,
      child: ElevatedButton(
        child: AppWidgets.getText(
          label,
          fontColor: labelColor,
        ),
        style: ElevatedButton.styleFrom(
          primary: setColor ? ColorConstants.buttonBlue : Colors.white,
          fixedSize: Size(width ?? 100, 20),
        ),
        onPressed: () {
          if (onTap != null) {
            onTap();
          }
          Navigator.of(context).pop();
        },
      ),
    );
  }
}
