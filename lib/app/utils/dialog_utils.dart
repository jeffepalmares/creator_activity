import 'package:creator_activity/app/constants/color_constants.dart';
import 'package:creator_activity/app/widgets/app_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class DialogUtils {
  static Widget getAlert(BuildContext context, String title, String message,
      {Function? ontap}) {
    return AlertDialog(
      title: _getTitle(title),
      content: _getText(message),
      actions: <Widget>[
        _getButton("Ok", ontap, context, setColor: true),
      ],
    );
  }

  static void presentDialog(BuildContext context, String title, String message,
      {Function? ontap}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return getAlert(context, title, message, ontap: ontap);
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
      {TextAlign textAlignment = TextAlign.left}) {
    return AppWidgets.getText(text, textAlign: textAlignment);
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
          Navigator.of(context).pop();
          if (onTap != null) {
            onTap();
          }
        },
      ),
    );
  }
}
