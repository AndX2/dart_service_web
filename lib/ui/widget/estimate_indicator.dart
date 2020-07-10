import 'dart:async';

import 'package:dartservice_web/di/di_container.dart';
import 'package:dartservice_web/domain/heartbeat/heartbeat.dart';
import 'package:dartservice_web/res/colors.dart' as colors;
import 'package:dartservice_web/service/heartbeat/heartbeat_service.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dartservice_web/utils/util.dart';

class EstimateIndicator extends StatefulWidget {
  final double width;
  final String text;

  EstimateIndicator(
    this.width,
    this.text, {
    Key key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => EstimateIndicatorState();
}

class EstimateIndicatorState extends State<EstimateIndicator> {
  int oldValue = 0;
  int newValue = 0;
  StreamSubscription<Heartbeat> subscription;

  @override
  void initState() {
    super.initState();
    subscription =
        getIt.get<HeartbeatService>().beatObservable.listen((Heartbeat beat) {
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
