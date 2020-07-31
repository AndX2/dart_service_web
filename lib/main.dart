import 'package:flutter/material.dart';

import 'package:dartservice_web/di/di_container.dart';
import 'package:dartservice_web/res/color/colors.dart' as colors;
import 'package:dartservice_web/ui/stub.dart';
import 'package:dartservice_web/utils/screen_util_ext.dart';

/// Точка входа в приложение
void main() {
  /// Инициализируем DI контейнер
  getItInit();
  /// Запускаем приложение, создав экземпляр корневого виджета
  runApp(MyApp());
}

/// Корневой класс приложения
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    /// Инициализируем утилиту адаптации размеров экрана
    initScreenUtil();
    return MaterialApp(
      title: 'Dart service',
      theme: ThemeData(
        primarySwatch: colors.primaryColor,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      /// Временный виджет экрана заглушки
      home: StubScreen(),
    );
  }
}
