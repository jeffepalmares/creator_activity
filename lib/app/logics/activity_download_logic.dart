import 'package:commons_flutter/exceptions/app_error.dart';
import 'package:commons_flutter/utils/network_utils.dart';
import 'package:commons_flutter/utils/disk_utils.dart';
import 'package:creator_activity/app/enums/sync_preference_enum.dart';
import 'package:creator_activity/app/lib_session.dart';
import 'package:creator_activity/app/services/activity_download_service.dart';
import 'package:flutter/material.dart';

class ActivityDownloadLogic {
  final ActivityDownloadService _service;

  ActivityDownloadLogic(this._service);

  Future<String> downloadActivity(
    String code,
    Function(String) onReceive,
  ) async {
    await _allowDownload();
    var resp =
        await _service.downloadActivity(code, _calcDownloadReceive(onReceive));
    var path = await _unzip(resp, code);
    return path;
  }

  Future _allowDownload() async {
    try {
      await NetworkUtils.validateInternet();

      var isWifi = await NetworkUtils.isWifi();
      var onlyWifi = LibSession.syncPreference == SyncPreference.wifi;
      var allowed = onlyWifi ? isWifi : true;

      if (!allowed) {
        throw AppError(
            "Suas configurações não permitem baixar aulas sem estar conectado a internet via Wi-Fi!");
      }
    } catch (err) {
      rethrow;
    }
  }

  Function(int count, int total) _calcDownloadReceive(
      Function(String) receive) {
    return (int received, int total) {
      if (total != -1) {
        String percent = (received / total * 100).toStringAsFixed(0);
        debugPrint("$percent %");
        receive(percent);
      }
    };
  }

  Future<String> _unzip(List<int> file, String code) async {
    var path =
        await DiskUtils.getRootPath(isExternal: LibSession.isExternalStorage);
    path = "$path/$code";
    return await DiskUtils.unzip(file, path);
  }
}
