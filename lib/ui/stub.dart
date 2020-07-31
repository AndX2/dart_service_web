import 'dart:html' as html;
import 'package:dartservice_web/di/di_container.dart';
import 'package:dartservice_web/res/strings.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:dartservice_web/domain/heartbeat/heartbeat.dart';
import 'package:dartservice_web/res/color/colors.dart' as colors;
import 'package:dartservice_web/res/images.dart';
import 'package:dartservice_web/ui/widget/estimate_indicator.dart';
import 'package:dartservice_web/utils/util.dart';

/// Страница - заглушка
class StubScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    /// Каркас экрана Material design, нужен в том числе для правильного отображения шрифтов
    return Scaffold(
      /// Виджет компоновщик для размещения виджетов один над другим
      body: Stack(
        children: [
          /// Растянуть на весь контейнер Stack
          Positioned.fill(
            /// Статическое изображение (из assets)
            child: Image.asset(
              /// Получаем из DI контейнера класс с изображениями и геттер с background
              /// заглушки ждя текущей ориентации экрана
              getIt.get<Images>().background(portrait: context.isPort).stub,
              /// Обрезать картинку смасштабировав по минимальной стороне
              fit: BoxFit.cover,
            ),
          ),
          /// Виджет - отступ
          Padding(
            /// Со всех сторон 96 адаптивных единиц
            padding: EdgeInsets.all(96.asp),
            /// Расположить в центре Stack
            child: Center(
              /// Виджет компоновщик, позволяющий "переносить" на следующую строку
              /// вложенные виджеты
              child: Wrap(
                /// Выравнивание виджетов по вертикали в строке между собой
                crossAxisAlignment: WrapCrossAlignment.center,
                /// Выравнивание виджетов в строке по горизонтали
                alignment: WrapAlignment.center,
                /// Расстояния между виджетами в строке и между строками
                runSpacing: 100.asp,
                spacing: 100.asp,
                children: [
                  _buildContainer(
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: _buildLabel(),
                    ),
                  ),
                  _buildContainer(
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: _buildTimerList(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Контейнер декоратор для вывода текста
  Widget _buildContainer(Widget child) {
    return Container(
      padding: EdgeInsets.all(32.sp),
      /// Настройка внешнего вида контейнера
      decoration: BoxDecoration(
          /// Цвет заднего фона
          color: Colors.grey[500].withOpacity(.5),
          /// Радиус углов
          borderRadius: BorderRadius.circular(32.sp)),
      child: child,
    );
  }

  /// Список надписей
  List<Widget> _buildLabel() {
    /// Строковые константы для экрана заглушки
    final strings = getIt.get<Strings>().stub;
    return [
      Text(
        strings.comingSoon,
        /// Использование Google шрифта
        style: GoogleFonts.jura(
          fontSize: 64.asp,
          color: colors.textColor,
        ),
      ),
      Text(
        strings.dartService.toUpperCase(),
        style: GoogleFonts.jura(
          fontSize: 96.asp,
          color: colors.textColor,
          fontWeight: FontWeight.w800,
        ),
      ),
      /// Виджет компоновщик "абзаца" текста с различным форматированием
      Text.rich(
        TextSpan(
          children: <TextSpan>[
            TextSpan(
                text: strings.openSource,
                style: GoogleFonts.jura(
                  fontSize: 48.asp,
                  color: colors.textLinkColor,
                ),
                /// Виджет "распознаватель" пользовательского ввода
                recognizer: TapGestureRecognizer()
                  /// Передаем метод обработчик клика
                  ..onTap = () => kIsWeb
                      /// Открыть веб ссылку
                      ? html.window.open(
                          'https://github.com/AndX2/dart_server',
                          'github link',
                        )
                      : () {} //TODO: открыть ссылку на нативном устройстве,
                ),
            TextSpan(
              text: strings.cross,
              style: GoogleFonts.jura(
                fontSize: 48.asp,
                color: colors.textColor,
              ),
            ),
            TextSpan(
              text: strings.smart,
              style: GoogleFonts.jura(
                fontSize: 48.asp,
                color: colors.textColor,
              ),
            ),
          ],
        ),
      )
    ];
  }

  /// Список таймеров
  List<Widget> _buildTimerList() {
    final strings = getIt.get<Strings>().common;
    return [
      EstimateIndicator(
        HeartbeatParam.days,
        160.asp,
        strings.days,
      ),
      SizedBox(height: 16.asp),
      Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          EstimateIndicator(
            HeartbeatParam.hours,
            100.asp,
            strings.hours,
          ),
          SizedBox(width: 16.asp),
          EstimateIndicator(
            HeartbeatParam.minutes,
            100.asp,
            strings.min,
          ),
          SizedBox(width: 16.asp),
          EstimateIndicator(
            HeartbeatParam.seconds,
            100.asp,
            strings.sec,
          ),
        ],
      ),
    ];
  }
}
