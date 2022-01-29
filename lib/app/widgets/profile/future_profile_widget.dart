import 'package:flutter/material.dart';

import 'profile_widgets.dart';

class FutureProfileWidget extends ProfileWidgets {
  @override
  Widget getPanel() {
    if ([].isEmpty) {
      return ProfileWidgets.titlePanel("Não há aulas Futuras!");
    }
    return ProfileWidgets.titlePanel("Próximas Aulas");
  }
}
