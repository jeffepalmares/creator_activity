import 'package:creator_activity/app/constants/color_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:grouped_list/grouped_list.dart';

import 'app_widgets.dart';

abstract class GroupedListTable {
  static Widget listTable<T, L>(List<T> activities, String Function(T) groupBy,
      {Widget Function(BuildContext context, T element, int index)?
          indexedItemBuilder}) {
    return GroupedListView<T, String>(
      elements: activities,
      groupBy: groupBy,
      shrinkWrap: true,
      groupComparator: (String a, String b) => a.compareTo(b),
      useStickyGroupSeparators: true,
      groupSeparatorBuilder: listSeparator(),
      separator: AppWidgets.separatorWidget(
          height: 1, color: ColorConstants.separatorColor),
      indexedItemBuilder: indexedItemBuilder,
    );
  }

  static Widget Function(String) listSeparator() {
    return (String value) {
      return Container(
        color: Colors.grey[200],
        child: Padding(
          padding: const EdgeInsets.only(left: 16, top: 10, bottom: 10),
          child: Text(
            value,
            style: TextStyle(
              color: ColorConstants.defaultBlue,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      );
    };
  }
}
