import 'dart:async';

import 'package:dartservice_web/di/di_container.dart';
import 'package:dartservice_web/domain/heartbeat/heartbeat.dart';
import 'package:dartservice_web/res/colors.dart' as colors;
import 'package:dartservice_web/service/heartbeat/heartbeat_service.dart';
import 'package:dartservice_web/ui/widget/arc_painter.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dartservice_web/utils/util.dart';

const _beatDuration = Duration(milliseconds: 1000);
const _valueDuration = Duration(milliseconds: 200);
const _fontSize = .7;
const _arcWidth = .05;
const _labelFontSize = .4;

class EstimateIndicator extends StatefulWidget {
  final HeartbeatParam heartbeatParam;
  final double width;
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

class EstimateIndicatorState extends State<EstimateIndicator>
    with TickerProviderStateMixin {
  double _ringValue = 0.0;
  int oldValue = 0;
  int newValue = 0;
  StreamSubscription<Heartbeat> subscription;

  Animation<double> _ringAnimation;
  AnimationController _ringAnimationController;
  Animation<double> _valueAnimation;
  AnimationController _valueAnimationController;

  @override
  void initState() {
    super.initState();

    _valueAnimationController = AnimationController(
      vsync: this,
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

    subscription =
        getIt.get<HeartbeatService>().beatObservable.listen(_beatEventListen);
  }

  @override
  void dispose() {
    subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: widget.width,
          width: widget.width,
          child: Stack(
            children: [
              Center(
                child: AnimatedBuilder(
                  animation: _valueAnimationController,
                  builder: (_, __) {
                    return Opacity(
                      opacity: _valueAnimation.value,
                      child: Text(
                        oldValue.toString(),
                        style: GoogleFonts.jura(
                          fontSize: (_fontSize * widget.width).asp,
                          color: colors.textColor,
                        ),
                      ),
                    );
                  },
                ),
              ),
              Positioned.fill(
                child: AnimatedBuilder(
                  animation: _ringAnimationController,
                  builder: (_, __) {
                    return CustomPaint(
                      painter: ArcPainter(
                        _ringValue,
                        _arcWidth * widget.width.asp * _ringAnimation.value,
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        Text(
          widget.text,
          style: GoogleFonts.jura(
            fontSize: (_labelFontSize * widget.width).asp,
            color: colors.textColor,
          ),
        ),
      ],
    );
  }

  void _beatEventListen(Heartbeat beat) {
    newValue = beat.value(widget.heartbeatParam);
    _ringValue = beat.value(widget.heartbeatParam).toDouble() /
        beat.full(widget.heartbeatParam);

    _ringAnimationController.reset();
    _ringAnimationController.forward();

    if (newValue != oldValue) {
      _valueAnimationController.reset();
      _valueAnimationController.addStatusListener(
        (status) {
          if (status == AnimationStatus.completed) {
            oldValue = newValue;
            _valueAnimationController.reverse();
          }
        },
      );
      _valueAnimationController.forward();
    }
  }
}
