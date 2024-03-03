import 'package:flutter/material.dart';

class Pallete{
  static const MaterialColor primarySwatchColor = MaterialColor(
    0xff489842, // 0% comes in here, this will be color picked if no shade is selected when defining a Color property which doesn’t require a swatch.
  <int, Color>{
      50: Color(0x1a489842),//10%
      100: Color(0x33489842),//20%
      200: Color(0x4d489842),//30%
      300: Color(0x66489842),//40%
      400: Color(0x80489842),//50%
      500: Color(0x99489842),//60%
      600: Color(0xB3489842),//70%
      700: Color(0xCC489842),//80%
      800: Color(0xE6489842),//90%
      900: Color(0xff489842),//100%
    },
  );
}