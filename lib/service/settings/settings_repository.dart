import 'package:dartservice_web/domain/settings/dev_time.dart';

class SettingsRepository {
  
  Future<DevTimeSettings> fetchDevTime() async {
    return DevTimeSettings(DateTime(2020, 7, 1), DateTime(2020, 10, 1));
  }
}
