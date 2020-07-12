import 'package:flutter/material.dart';

import 'package:dartservice_web/di/di_container.dart';
import 'package:dartservice_web/res/color/colors.dart' as colors;
import 'package:dartservice_web/ui/stub.dart';
import 'package:dartservice_web/utils/screen_util_ext.dart';

void main() {
  getItInit();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    initScreenUtil();
    return MaterialApp(
      title: 'Dart service',
      theme: ThemeData(
        primarySwatch: colors.primaryColor,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: StubScreen(),
    );
  }
}
