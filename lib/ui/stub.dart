import 'dart:html' as html;

import 'package:dartservice_web/res/colors.dart' as colors;
import 'package:dartservice_web/res/images.dart';
import 'package:dartservice_web/ui/widget/estimate_indicator.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:dartservice_web/utils/util.dart';
import 'package:google_fonts/google_fonts.dart';

class StubScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    print(
        'port: ${context.isPort}, width: ${ScreenUtil.screenWidth}, height: ${ScreenUtil.screenHeight}');
    print('isSmall: $isSmall, isTablet: $isTablet, isDesktop: $isDesktop');
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              Images.background(portrait: context.isPort).stub,
              fit: BoxFit.cover,
            ),
          ),
          Center(
            child: Wrap(
              children: [
                _buildContainer(
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: _buildLabel(),
                  ),
                ),
                SizedBox(height: 100.asp, width: 100.asp),
                _buildContainer(EstimateIndicator(100.asp, 'sec')),
              ],
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
}
