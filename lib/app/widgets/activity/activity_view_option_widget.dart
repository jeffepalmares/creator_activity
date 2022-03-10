import 'package:creator_activity/app/constants/color_constants.dart';
import 'package:creator_activity/app/widgets/app_widgets.dart';
import 'package:creator_activity/app/widgets/view_config/view_options_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

abstract class ActivityViewConfigWidgets {
  static ViewConfig _viewConfig() {
    return ViewConfig(
      end: ViewOptionsWidgets.config.end,
      from: ViewOptionsWidgets.config.from,
      groupBy: ViewOptionsWidgets.config.groupBy,
      sortBy: ViewOptionsWidgets.config.sortBy,
      sortType: ViewOptionsWidgets.config.sortType,
    );
  }

  static Widget getViewOptionsBody(BuildContext context, Function action) {
    var currentConfig = _viewConfig();
    return SingleChildScrollView(
      child: Center(
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: _bodyItems(context, currentConfig, action),
            ),
          ),
        ),
      ),
    );
  }

  static List<Widget> _bodyItems(
      BuildContext context, ViewConfig currentConfig, Function action) {
    List<Widget> items = <Widget>[
      _headPanel(context, currentConfig),
      AppWidgets.spacer(height: 20),
      AppWidgets.line(),
      AppWidgets.spacer(height: 20),
      AppWidgets.getText('Configurações de Exibição',
          fontSize: 16,
          fontWeight: FontWeight.bold,
          fontColor: ColorConstants.buttonBlue),
      AppWidgets.spacer(height: 20),
      ViewOptionsWidgets.getPeriodDropDown(),
      ViewOptionsWidgets.getOrderBy(),
      ViewOptionsWidgets.mode(),
      ViewOptionsWidgets.groupBy(),
      AppWidgets.spacer(height: 20),
      AppWidgets.line(),
      AppWidgets.spacer(height: 20),
      AppWidgets.appButton(
        'Aplicar',
        () {
          action();
          Navigator.of(context).pop();
        },
        labelColor: Colors.white,
        bckColor: Colors.green,
      )
    ];
    return items;
  }

  static Widget _headPanel(BuildContext context, ViewConfig currentConfig) {
    return Stack(
      alignment: Alignment.center,
      children: [
        _label(),
        _closeIcon(context, currentConfig),
      ],
    );
  }

  static Widget _label() {
    return Align(
      alignment: Alignment.centerLeft,
      child: AppWidgets.getText('Exibição',
          fontSize: 16, fontColor: Colors.grey[800]),
    );
  }

  static Widget _closeIcon(BuildContext context, ViewConfig currentConfig) {
    return Align(
      alignment: Alignment.centerRight,
      child: IconButton(
        icon: const Icon(Icons.close_outlined),
        onPressed: () {
          ViewOptionsWidgets.config = currentConfig;
          Navigator.of(context).pop();
        },
      ),
    );
  }
}
