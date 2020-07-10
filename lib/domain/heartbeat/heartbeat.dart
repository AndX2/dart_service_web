import 'package:flutter/foundation.dart';

@immutable
class Heartbeat {
  final int daysFromStart;
  final int days;
  final int hours;
  final int minutes;
  final int seconds;

  Heartbeat(
    this.daysFromStart,
    this.days,
    this.hours,
    this.minutes,
    this.seconds,
  );

  factory Heartbeat.fromDateTime(DateTime start, DateTime end) {
    var cursor = DateTime.now();
    final days = end.difference(cursor).inDays;
    cursor = cursor.add(Duration(days: days));
    final hours = end.difference(cursor).inHours;
    cursor = cursor.add(Duration(hours: hours));
    final min = end.difference(cursor).inMinutes;
    cursor = cursor.add(Duration(minutes: min));
    final sec = end.difference(cursor).inSeconds;
    return Heartbeat(end.difference(start).inDays, days, hours, min, sec);
  }
}

enum HeartbeatParam {
  days,
  hours,
  minutes,
  seconds,
}

extension HeartbeatUiExt on Heartbeat {
  int full(HeartbeatParam param) {
    switch (param) {
      case HeartbeatParam.days:
        return daysFromStart;
        break;
      case HeartbeatParam.hours:
        return Duration.hoursPerDay;
        break;
      case HeartbeatParam.minutes:
        return Duration.minutesPerHour;
        break;
      default:
        return Duration.secondsPerMinute;
    }
  }

  int value(HeartbeatParam param) {
    switch (param) {
      case HeartbeatParam.days:
        return days;
        break;
      case HeartbeatParam.hours:
        return hours;
        break;
      case HeartbeatParam.minutes:
        return minutes;
        break;
      default:
        return seconds;
    }
  }
}
