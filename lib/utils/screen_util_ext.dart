import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';

/// "Настроечные" константы определяющие границы условий масштабирования
/// Экраны с нетривиально маленькими размерами iPhone5/GalaxyS5
/// обычно требуют отдельной настройки размеров UI
const _smallMobileScreenWidth = 340;
/// Минимальный размер экрана, после которого устройство - планшет
const _minTabletScreen = 600;
/// -//- десктоп или iPad Pro
const _maxTabletScreen = 1024;

/// Начальная настройка утилиты масштабирования размеров UI
/// Вызывается в методе build() корневого виджета, или позже, но
/// до первого вызова её методов
void initScreenUtil() {
  ScreenUtil.init(
    /// Базовый размер экрана, для которого верстается UI
    width: 1920,
    height: 1080,
    /// Масштабирование шрифтов по умолчанию 
    allowFontScaling: true,
  );
}

/// Расширение утилиты масштабирования размеров UI
/// позволяет при верстке проверить тип устройства по размеру
/// экрана
extension ScreenUtilExt on Widget {
  bool get isSmall =>
      min(ScreenUtil.screenWidth, ScreenUtil.screenHeight) <
      _smallMobileScreenWidth;

  bool get isMobile =>
      min(ScreenUtil.screenWidth, ScreenUtil.screenHeight) < _minTabletScreen;

  bool get isTablet =>
      min(
              ScreenUtil.screenWidth, ScreenUtil.screenHeight) >=
          _minTabletScreen &&
      min(ScreenUtil.screenWidth, ScreenUtil.screenHeight) <=
          _maxTabletScreen &&
      max(ScreenUtil.screenWidth, ScreenUtil.screenHeight) <= _maxTabletScreen;

  bool get isDesktop => ScreenUtil.screenWidth > _maxTabletScreen;

  double get minSize => min(ScreenUtil.screenWidth, ScreenUtil.screenHeight);
  double get maxSize => max(ScreenUtil.screenWidth, ScreenUtil.screenHeight);
}

/// Расширение утилиты масштабирования размеров UI
/// позволяющее запросить текущее расположение 
/// экрана ландшафтный/портретный 
extension ScreenUtilContextExt on BuildContext {
  bool get isLand {
    final size = _getSize();
    return size.width > size.height;
  }

  bool get isPort => !isLand;

  Size _getSize() => MediaQuery.of(this).size;
}

/// Расширение утилиты масштабирования размеров UI
/// позволяющее масштабировать размеры верстки в зависимости
/// от того во сколько раз диагональ "базового"
/// экрана отличается от текущего
extension ScreenUtilSpExt on num {
  num get asp {
    final minScale = (sqrt(
          pow(ScreenUtil.screenWidth, 2) + pow(ScreenUtil.screenHeight, 2),
        ) /
        (sqrt(
          pow(ScreenUtil().uiWidthPx, 2) + pow(ScreenUtil().uiHeightPx, 2),
        )));

    return this * minScale / ScreenUtil.textScaleFactor;
  }
}
