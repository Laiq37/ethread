import 'package:ethread_app/utils/helpers/screen_info.dart';

class Constants {
 static late final bool isFlashAvailable;
  
  static const baseUrl = "http://api/"; //live

  static const apFailureMessage = "Something went wrong";
  static const timeout = 20;

  static const Screen homeScreen = Screen.home;

  static const Screen routeScreen = Screen.route;

  static const Screen listingScreen = Screen.listing;

  static const Screen serviceScreen = Screen.service;

  static const Screen none = Screen.none;

  static const networkErrorMessage =
      'Please check your internet connection. Failed to communicate with the server';

  static const timeOutErrorMessage =
      'Failed to communicate with the server in a reasonable amount of time. Please check your internet connection. Try again later';

  static const String token = "user_token";

  static String userToken = "";
  
  static String userType = "";

  static const String tokenExpiry = "token_expiry";

  static const String type = "user_type";

  static const String dateFormat = 'EEEE d MMM yyyy';

  static const String permenant = "Permanent";

  static const String userBox = "user";

  static const String vehiclesBox = "vehicles";

  static const String binReportsBox = "bin_reports";

  static const String reportsBox = "reports";

  static const String activeStatus = "active";

  static const String pendingStatus = "pending";

  static const String completedStatus = "completed";

  static const String inProgressStatus = "in_progress";

  static const String firstPicture = "first_picture";

  static const String lastPicture = "last_picture";
}
