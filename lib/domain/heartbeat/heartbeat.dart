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
