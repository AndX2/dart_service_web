import 'dart:math';

import 'package:flutter/material.dart';

const _defaultColor = Colors.red;

/// Кастомный примитив на canvas. Рисует дугу с началом (условно)
/// на 12 часов против часовой стрелки
class ArcPainter extends CustomPainter {
  /// Входные параметры: цвет и значение шкалы (от 0 до 1,0)
  final Color color;
  final double _value;
  /// "Кисть" которой будем рисовать дугу
  final Paint _paint;

  ArcPainter(
    this._value,
    double width, {
    this.color = _defaultColor,
  }) : _paint = Paint()
          /// Создаем экземпляр "кисти" и устанавливаем для него параметры:
          /// цвет, толщину линии, тип (окружность или сектор), тип окончания линии
          ..color = color
          ..strokeWidth = width
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round;

  @override
  void paint(Canvas canvas, Size size) {
    /// В прямоугольник, занимающий весь доступный холст вписываем дугу
    /// от -Пи/2 на угол равный 2*Пи*значение_шкалы направление - против 
    /// часовой стрелки
    final rect = Offset(0.0, 0.0) & size;
    canvas.drawArc(rect, -pi / 2, -2 * pi * _value, false, _paint);
  }
  /// Нужно ли перерисовывать элемент виджета, если старый был разрушен,
  /// а на его месте был создан такой же с теми же значениями полей класса
  @override
  bool shouldRepaint(ArcPainter oldDelegate) => false;
}
