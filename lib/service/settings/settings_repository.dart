import 'package:dartservice_web/domain/settings/dev_time.dart';

/// Репозиторий для получения с сервера настроек приложения
class SettingsRepository {
  /// Получить параметр, содержащий дату начала и окончания разработки 
  Future<DevTimeSettings> fetchDevTime() async {
    //TODO: сделать запрос после реализации на сервере
    return DevTimeSettings(DateTime(2020, 7, 1), DateTime(2020, 10, 1));
  }
}
