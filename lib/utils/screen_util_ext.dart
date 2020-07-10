import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';

const _smallMobileScreenWidth = 340;
const _minTabletScreen = 600;
const _maxTabletScreen = 1024;

void initScreenUtil() {
  ScreenUtil.init(
    width: 1920,
    height: 1080,
    allowFontScaling: true,
  );
}

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

extension ScreenUtilContextExt on BuildContext {
  
  bool get isLand {
    final size = _getSize();
    return size.width > size.height;
  }

  bool get isPort => !isLand;

  Size _getSize() => MediaQuery.of(this).size;
}

extension ScreenUtilSpExt on num {
  num get asp {
    final minScale = (ScreenUtil.screenWidth + ScreenUtil.screenHeight) /
        (ScreenUtil().uiWidthPx + ScreenUtil().uiHeightPx);

    return this * minScale / ScreenUtil.textScaleFactor;
  }
}
