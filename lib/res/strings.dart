/// Строковые константы
class Strings {
  Common get common => Common();
  Stub get stub => Stub();
}

class Common extends Strings {
  String get days => 'days';
  String get hours => 'hours';
  String get min => 'min';
  String get sec => 'sec';
}

class Stub extends Strings {
  String get comingSoon => 'Уже скоро здесь будет';
  String get dartService => 'сервис на DART';
  String get openSource => 'OPEN SOURCE';
  String get cross => '  CROSS  ';
  String get smart => 'SMART';
}
