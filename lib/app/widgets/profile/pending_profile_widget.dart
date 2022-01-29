import 'package:creator_activity/app/widgets/profile/profile_widgets.dart';
import 'package:creator_activity/app/widgets/user_picture_widgets.dart';
import 'package:flutter/material.dart';

class PedingProfileWidget extends ProfileWidgets {
  @override
  Widget getPanel() {
    return _profilePanel();
  }

  static Widget _profilePanel() {
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            UserPictureWidgets.userPicture(),
            ProfileWidgets.wellComePanel(),
          ],
        ),
        ProfileWidgets.titlePanel([].isEmpty ? "" : "Aulas")
      ],
    );
  }
}
