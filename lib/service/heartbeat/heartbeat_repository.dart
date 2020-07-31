import 'dart:async';
/// Условный репозиторий событий, которые нужно отображать на UI
class HeartbeatRepository {
  final Stream beatStream;
  /// Поток событий
  HeartbeatRepository() : beatStream = Stream.periodic(Duration(seconds: 1));
}
