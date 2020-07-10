import 'dart:async';

class HeartbeatRepository {
  final Stream beatStream;

  HeartbeatRepository() : beatStream = Stream.periodic(Duration(seconds: 1));
}
