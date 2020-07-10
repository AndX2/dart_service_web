import 'dart:async';

import 'package:dartservice_web/domain/heartbeat/heartbeat.dart';
import 'package:dartservice_web/domain/settings/dev_time.dart';
import 'package:dartservice_web/service/heartbeat/heartbeat_repository.dart';
import 'package:dartservice_web/service/settings/settings_repository.dart';
import 'package:rxdart/rxdart.dart';

class HeartbeatService {
  final HeartbeatRepository _heartbeatRepository;
  final SettingsRepository _settingsRepository;

  DevTimeSettings _devTimeSettings;

  // ignore: close_sinks
  final beatObservable = BehaviorSubject<Heartbeat>();

  HeartbeatService(
    this._heartbeatRepository,
    this._settingsRepository,
  ) {
    refreshDevTime();
    _heartbeatRepository.beatStream.listen(
      (_) {
        if (_devTimeSettings != null && beatObservable.hasListener) {
          beatObservable.add(
            Heartbeat.fromDateTime(
              _devTimeSettings.startTime,
              _devTimeSettings.launchTime,
            ),
          );
        }
      },
    );
  }

  Future<DevTimeSettings> refreshDevTime() async {
    final devTime = await _settingsRepository.fetchDevTime();
    if (devTime != null && devTime is DevTimeSettings) {
      _devTimeSettings = devTime;
    }
    return devTime;
  }
}
