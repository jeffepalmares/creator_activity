import 'package:creator_activity/app/constants/color_constants.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';

enum LibIcon { redo, syncIcon, trash, eye, download }

abstract class LibIcons {
  static const String _prefix = "assets/images/icons/";
  static final _appIconToIconName = {
    LibIcon.redo: "redo_icon",
    LibIcon.syncIcon: "sync_icon",
    LibIcon.trash: "trash_icon",
    LibIcon.eye: "eye_icon",
    LibIcon.download: "download_icon",
  };

  static String _appIconToPath(LibIcon icon) {
    String iconName = _appIconToIconName[icon] ?? "account_icon";
    return _prefix + iconName + ".svg";
  }

  static Widget generateIcon(LibIcon icon,
      {Color? color, double? height, double? width}) {
    return SvgPicture.asset(
      _appIconToPath(icon),
      color: color ?? ColorConstants.defaultGrey,
      height: height ?? 20,
      width: width ?? 20,
    );
  }
}
