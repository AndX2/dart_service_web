import 'dart:async';

import 'package:dartservice_web/di/di_container.dart';
import 'package:dartservice_web/domain/heartbeat/heartbeat.dart';
import 'package:dartservice_web/res/colors.dart' as colors;
import 'package:dartservice_web/service/heartbeat/heartbeat_service.dart';
import 'package:dartservice_web/ui/widget/arc_painter.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dartservice_web/utils/util.dart';

const _beatDuration = Duration(milliseconds: 300);

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
      duration: _beatDuration,
    );

    _ringAnimationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1000),
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
        getIt.get<HeartbeatService>().beatObservable.listen((Heartbeat beat) {
      _ringValue = beat.value(widget.heartbeatParam).toDouble() /
          beat.full(widget.heartbeatParam);
      _ringAnimationController.reset();
      _ringAnimationController.forward();
      if (newValue != beat.seconds)
        setState(() {
          oldValue = newValue;
          newValue = beat.seconds;
        });
    });
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
                child: AnimatedCrossFade(
                  firstChild: Text(
                    oldValue.toString(),
                    style: GoogleFonts.jura(
                      fontSize: (widget.width).asp,
                      color: colors.textColor,
                    ),
                  ),
                  secondChild: Text(
                    newValue.toString(),
                    style: GoogleFonts.jura(
                      fontSize: (widget.width).asp,
                      color: colors.textColor,
                    ),
                  ),
                  crossFadeState: newValue.isOdd
                      ? CrossFadeState.showSecond
                      : CrossFadeState.showFirst,
                  duration: Duration(milliseconds: 500),
                ),
              ),
              Positioned.fill(
                child: AnimatedBuilder(
                    animation: _ringAnimationController,
                    builder: (_, __) {
                      return CustomPaint(
                        painter: ArcPainter(
                            _ringValue, 5.0.asp * _ringAnimation.value),
                      );
                    }),
              ),
            ],
          ),
        ),
        Text(
          widget.text,
          style: GoogleFonts.jura(
            fontSize: (0.2 * widget.width).asp,
            color: colors.textColor,
          ),
        ),
      ],
    );
  }
}
