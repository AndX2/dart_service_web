import 'package:flutter/foundation.dart';

@immutable
class DevTimeSettings {
  final DateTime startTime;
  final DateTime launchTime;

  DevTimeSettings(
    this.startTime,
    this.launchTime,
  );
}
