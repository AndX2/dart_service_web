import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:dartservice_web/di/di_container.dart';
import 'package:dartservice_web/domain/heartbeat/heartbeat.dart';
import 'package:dartservice_web/res/color/colors.dart' as colors;
import 'package:dartservice_web/service/heartbeat/heartbeat_service.dart';
import 'package:dartservice_web/ui/widget/arc_painter.dart';

/// Настроечные константы
const _beatDuration = Duration(milliseconds: 1000);
const _valueDuration = Duration(milliseconds: 200);
const _fontSize = .6;
const _arcWidth = .07;
const _labelFontSize = .3;

/// Круговой индикатор обратного отсчета
class EstimateIndicator extends StatefulWidget {
  /// Параметр времени, для которого строится индикатор
  final HeartbeatParam heartbeatParam;
  /// Ширина
  final double width;
  /// Надпись под индикатором
  final String text;

  EstimateIndicator(
    this.heartbeatParam,
    this.width,
    this.text, {
    Key key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => EstimateIndicatorState();
}

/// Состояние виджета индикатора
class EstimateIndicatorState extends State<EstimateIndicator>
    with TickerProviderStateMixin {
  /// Текущее значение индикатора
  double _ringValue = 0.0;
  /// Новое и старое значения числа
  int oldValue = 0;
  int newValue = 0;
  /// Подписка на стрим с событиями
  StreamSubscription<Heartbeat> subscription;

  /// Анимации и контроллеры анимаций для линии индикатора и числа
  Animation<double> _ringAnimation;
  AnimationController _ringAnimationController;
  Animation<double> _valueAnimation;
  AnimationController _valueAnimationController;

  @override
  void initState() {
    super.initState();
    /// Инициализация анимаций и контроллеров
    _valueAnimationController = AnimationController(
      vsync: this, // Это TickerProviderStateMixin
      duration: _valueDuration,
    );

    _valueAnimation = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(_valueAnimationController);

    _ringAnimationController = AnimationController(
      vsync: this,
      duration: _beatDuration,
    );
    /// Составная анимация из нескольких периодов 
    /// 0-10% - значение растет от 0,1 до 1,0;
    /// 10%-20% не изменяется на уровне 1,0;
    /// 20%-100% снижается от 1,0 до 0,1
    _ringAnimation = TweenSequence(
      <TweenSequenceItem<double>>[
        TweenSequenceItem<double>(
          tween: Tween<double>(begin: .1, end: 1.0)
              .chain(CurveTween(curve: Curves.ease)),
          weight: 10.0,
        ),
        TweenSequenceItem<double>(
          tween: ConstantTween<double>(1.0),
          weight: 10.0,
        ),
        TweenSequenceItem<double>(
          tween: Tween<double>(begin: 1.0, end: .1)
              .chain(CurveTween(curve: Curves.ease)),
          weight: 80.0,
        ),
      ],
    ).animate(_ringAnimationController);
    /// Подписываемся на события потока Heartbeat в сервисе и сохраняем 
    /// экземпляр подписки
    subscription =
        getIt.get<HeartbeatService>().beatObservable.listen(_beatEventListen);
  }

  @override
  void dispose() {
    /// При уничтожении виджета не забываем отписываться от потока событий
    subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    /// В Стек помещаем три виджета надпись, число и шкалу индикатора
    return Stack(
      children: [
        /// Виджет с размерами, по нижнему краю выравниваем надпись
        SizedBox(
          height: 1.4 * widget.width,
          width: widget.width,
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Text(
              widget.text,
              style: GoogleFonts.jura(
                fontSize: _labelFontSize * widget.width,
                color: colors.textColor,
              ),
            ),
          ),
        ),
        SizedBox(
          height: widget.width,
          width: widget.width,
          child: Center(
            /// Виджет для локальной анимации. Он позволяет перестраивать только необходимую
            /// часть дерева виджетов, избегая вызова метода setState(), приводящего к перестроению
            /// всего EstimateIndicatorState. Этим достигается повышение производительности.
            child: AnimatedBuilder(
              animation: _valueAnimationController,
              builder: (_, __) {
                /// Анимация здесь это изменение прозрачности child виджета в соотвествии со значением
                /// объекта анимации _valueAnimation.value
                return Opacity(
                  opacity: _valueAnimation.value,
                  child: Text(
                    oldValue.toString(),
                    style: GoogleFonts.jura(
                      fontSize: _fontSize * widget.width,
                      color: colors.textColor,
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        SizedBox(
          height: widget.width,
          width: widget.width,
          /// Виджет анимации шкалы индикатора
          child: AnimatedBuilder(
            animation: _ringAnimationController,
            builder: (_, __) {
              /// Рисуем кастомный примитив на canvas. Сектор кольца, где градус сектора - 
              /// текущее значение шкалы, а толщина линии - значение анимации _ringAnimation.value
              return CustomPaint(
                painter: ArcPainter(
                  _ringValue,
                  _arcWidth * widget.width * _ringAnimation.value,
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  /// Метод, вызываемый при событии Heartbeat
  void _beatEventListen(Heartbeat beat) {
    /// Получаем новое значение числа для индикатора
    newValue = beat.value(widget.heartbeatParam);
    /// Считаем, какую часть шкалы индикатора нужно показать
    _ringValue = beat.value(widget.heartbeatParam).toDouble() /
        beat.full(widget.heartbeatParam);
    /// Сбрасываем и запускаем с начала анимацию шкалы индикатора
    _ringAnimationController.reset();
    _ringAnimationController.forward();
    /// Если изменилось значение числа индикатора запускаем анимацию его замены
    if (newValue != oldValue) {
      /// Сбрасываем контроллер анимации числа
      _valueAnimationController.reset();
      /// Назначаем метод "прослушивания" состояния анимации числа
      _valueAnimationController.addStatusListener(
        (status) {
          /// При завершении анимации запускаем ее в обратную сторону, но уже с новым числом
          if (status == AnimationStatus.completed) {
            oldValue = newValue;
            _valueAnimationController.reverse();
          }
        },
      );
      /// Запускаем анимацию
      _valueAnimationController.forward();
    }
  }
}
