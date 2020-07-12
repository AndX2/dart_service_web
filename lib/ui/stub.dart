import 'dart:html' as html;
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:dartservice_web/domain/heartbeat/heartbeat.dart';
import 'package:dartservice_web/res/colors.dart' as colors;
import 'package:dartservice_web/res/images.dart';
import 'package:dartservice_web/ui/widget/estimate_indicator.dart';
import 'package:dartservice_web/utils/util.dart';

class StubScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          
          Positioned.fill(
            child: Image.asset(
              Images.background(portrait: context.isPort).stub,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: EdgeInsets.all(96.asp),
            child: Center(
              child: Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                alignment: WrapAlignment.center,
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

  Widget _buildContainer(Widget child) {
    return Container(
      padding: EdgeInsets.all(32.sp),
      decoration: BoxDecoration(
          color: Colors.grey[500].withOpacity(.5),
          borderRadius: BorderRadius.circular(16.sp)),
      child: child,
    );
  }

  List<Widget> _buildLabel() {
    return [
      Text(
        'Уже скоро здесь будет',
        style: GoogleFonts.jura(
          fontSize: 64.asp,
          color: colors.textColor,
        ),
      ),
      Text(
        'сервис на DART'.toUpperCase(),
        style: GoogleFonts.jura(
          fontSize: 96.asp,
          color: colors.textColor,
          fontWeight: FontWeight.w800,
        ),
      ),
      Text.rich(
        TextSpan(
          children: <TextSpan>[
            TextSpan(
              text: 'OPEN SOURCE',
              style: GoogleFonts.jura(
                fontSize: 48.asp,
                color: colors.textLinkColor,
              ),
              recognizer: TapGestureRecognizer()
                ..onTap = () => kIsWeb
                    ? html.window.open(
                        'https://github.com/AndX2/dart_server',
                        'github link',
                      )
                    : () {},
            ),
            TextSpan(
              text: '  CROSS  ',
              style: GoogleFonts.jura(
                fontSize: 48.asp,
                color: colors.textColor,
              ),
            ),
            TextSpan(
              text: 'SMART',
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

  List<Widget> _buildTimerList() {
    return [
      EstimateIndicator(
        HeartbeatParam.days,
        160.asp,
        'days',
      ),
      SizedBox(height: 16.asp),
      Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          EstimateIndicator(
            HeartbeatParam.hours,
            100.asp,
            'hours',
          ),
          SizedBox(width: 16.asp),
          EstimateIndicator(
            HeartbeatParam.minutes,
            100.asp,
            'min',
          ),
          SizedBox(width: 16.asp),
          EstimateIndicator(
            HeartbeatParam.seconds,
            100.asp,
            'sec',
          ),
        ],
      ),
    ];
  }
}
