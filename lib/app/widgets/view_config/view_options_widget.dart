import 'package:creator_activity/app/widgets/app_widgets.dart';
import 'package:flutter/material.dart';

import 'drop_down_options.dart';

class ViewConfig {
  DateTime? from;
  DateTime? end;
  SortActivityBy? sortBy;
  SortType? sortType;
  GroupBy? groupBy;
  DropDownOption<DateTime> defaultPeriod = DefaultOptions.defaultPeriod;
  DropDownOption<SortActivityBy> defaultOrderBy = DefaultOptions.defaultOrderBy;
  DropDownOption<SortType> defaultMode = DefaultOptions.defaultMode;
  DropDownOption<GroupBy> defaultGroupBy = DefaultOptions.defaultGroupBy;
  ViewConfig({
    this.from,
    this.end,
    this.sortBy,
    this.sortType,
    this.groupBy,
  });
}

class ViewOptionsWidgets {
  static ViewConfig config = ViewConfig(
    end: DateTime.now(),
    from: null,
    groupBy: GroupBy.T,
    sortBy: SortActivityBy.Name,
    sortType: SortType.Asc,
  );
  static ViewConfig oldConfig = ViewConfig(
    end: DateTime.now(),
    from: null,
    groupBy: GroupBy.T,
    sortBy: SortActivityBy.Name,
    sortType: SortType.Asc,
  );

  static Widget getPeriodDropDown() {
    return getDropDown<DateTime>(
        'Período:', DropDowOptionsHelper.periods, config.defaultPeriod,
        (option) {
      config.from = option?.value;
      config.end = option?.end ?? DateTime.now();
      config.defaultPeriod = option!;
    });
  }

  static Widget getOrderBy() {
    return getDropDown<SortActivityBy>('Ordenar por:',
        DropDowOptionsHelper.orderOptions, config.defaultOrderBy, (option) {
      config.sortBy = option?.value;
      config.defaultOrderBy = option!;
    });
  }

  static Widget mode() {
    return getDropDown<SortType>(
        'Modo:', DropDowOptionsHelper.modeOptions, config.defaultMode,
        (option) {
      config.sortType = option?.value;
      config.defaultMode = option!;
    });
  }

  static Widget groupBy() {
    return getDropDown<GroupBy>(
        'Agrupar:', DropDowOptionsHelper.groupByOptions, config.defaultGroupBy,
        (option) {
      config.groupBy = option?.value;
      config.defaultGroupBy = option!;
    });
  }

  static Widget getDropDown<T>(String label, List<DropDownOption<T>> options,
      DropDownOption<T> defaultValue, Function(DropDownOption<T>?) action) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _getDropLabel(label),
        AppWidgets.spacer(height: 8.0),
        _getDropDown(options, defaultValue, action),
        AppWidgets.spacer(height: 20.0),
      ],
    );
  }

  static Widget _getDropLabel(String label) {
    return AppWidgets.getText(
      label,
      fontSize: 16,
      fontWeight: FontWeight.bold,
      fontColor: Colors.black,
    );
  }

  static Widget _getDropDown<T>(List<DropDownOption<T>> options,
      DropDownOption<T> defaultValue, Function(DropDownOption<T>?) action) {
    return DropdownButtonFormField<DropDownOption<T>>(
      decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0))),
      isExpanded: true,
      value: defaultValue,
      icon: const Icon(Icons.arrow_drop_down_sharp),
      onChanged: (DropDownOption<T>? value) {
        action(value);
      },
      items: options
          .map<DropdownMenuItem<DropDownOption<T>>>((DropDownOption<T> option) {
        return DropdownMenuItem<DropDownOption<T>>(
          value: option,
          child: Text(option.name),
        );
      }).toList(),
    );
  }
}
