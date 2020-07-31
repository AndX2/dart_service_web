import 'package:flutter/material.dart';

/// Material цвет. В отличие от обычного Color необходимо определить 
/// словарь оттенков с различной "насыщенностью"
final mediumSeaGreen = MaterialColor(0xFF43BA56, _colorCodes);

Map<int, Color> _colorCodes = {
  50: Color(0xFF43BA56).withOpacity(.1),
  100: Color(0xFF43BA56).withOpacity(.2),
  200: Color(0xFF43BA56).withOpacity(.3),
  300: Color(0xFF43BA56).withOpacity(.4),
  400: Color(0xFF43BA56).withOpacity(.5),
  500: Color(0xFF43BA56).withOpacity(.6),
  600: Color(0xFF43BA56).withOpacity(.7),
  700: Color(0xFF43BA56).withOpacity(.8),
  800: Color(0xFF43BA56).withOpacity(.9),
  900: Color(0xFF43BA56).withOpacity(1.0),
};


