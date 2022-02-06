import 'enums/sync_preference_enum.dart';

abstract class LibSession {
  static int loggedAge = 0;
  static String loggedUser = "";
  static String loggedUserName = "";
  static String loggedUserPicture = "";
  static String httpToken = "";
  static SyncPreference? syncPreference = SyncPreference.automatically;
  static bool isExternalStorage = false;
  //Corp
  static String schoolClassCode = "";
}
