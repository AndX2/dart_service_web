import 'package:flutter/foundation.dart';

/// Дата класс, содержащий даты начала разработки приложения
/// и дату релиза. Хорошей практикой является делать такие
/// объекты неизменяемыми. [@immutable] - выведет предупреждение 
/// если какое-то из полей класса не final.
@immutable
class DevTimeSettings {
  final DateTime startTime;
  final DateTime launchTime;

  DevTimeSettings(
    this.startTime,
    this.launchTime,
  );
}
