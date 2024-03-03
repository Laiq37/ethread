import 'package:ethread_app/utils/helpers/constants.dart';

enum Screen {
   none,  
   home,
   route,
   listing,
   service,
}

class ScreenInfo{
  Screen _currentScreen = Constants.none;
  
  static ScreenInfo? _instance = ScreenInfo._internal();

  factory ScreenInfo() {
   return _instance ??= ScreenInfo._internal();
  }
  ScreenInfo._internal();

  get getCurrentScreen => _currentScreen;

  set setCurrentScreen(Screen value) => _currentScreen = value;
}