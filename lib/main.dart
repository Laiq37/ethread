import 'dart:async';

import 'package:camera/camera.dart';
import 'package:ethread_app/home/ui/home_screen.dart';
import 'package:ethread_app/route/ui/route_screen.dart';
import 'package:ethread_app/services/models/bin/bin_report.dart';
import 'package:ethread_app/services/models/report/report.dart';
import 'package:ethread_app/services/models/user/user.dart';
import 'package:ethread_app/services/models/vehicle/vehicles.dart';
import 'package:ethread_app/splash/ui/splash_screen.dart';
import 'package:ethread_app/utils/config/theme/theme_config.dart';
import 'package:ethread_app/utils/helpers/constants.dart';
import 'package:ethread_app/utils/helpers/dart_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:torch_light/torch_light.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart' show kDebugMode;

late List<CameraDescription> cameras;
late String filePath;

void main() async {
  runZonedGuarded<Future<void>>(() async {
    WidgetsFlutterBinding.ensureInitialized();

    await Firebase.initializeApp();
    FlutterError.onError = (errorDetails) {
      FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
    };

    //Inorder to get available Cameras
    cameras = await availableCameras();

    //To get reference of the application package folder
    final document = await getApplicationDocumentsDirectory();

    Hive.init(document.path);

    //Registering Hive adapters
    Hive.registerAdapter<User>(UserAdapter());
    Hive.registerAdapter<Vehicles>(VehiclesAdapter());
    Hive.registerAdapter<Report>(ReportAdapter());
    Hive.registerAdapter<Bin>(BinAdapter());

    //Initialize Hive boxes
    await Hive.openBox<User>(Constants.userBox);
    await Hive.openBox<Vehicles>(Constants.vehiclesBox);
    await Hive.openBox<Report>(Constants.reportsBox);

    runApp(const MyApp());
    if (kDebugMode) {
      // Force disable Crashlytics collection while doing every day development.
      // Temporarily toggle this to true if you want to test crash reporting in your app.
      await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(false);
    }
    runApp(const MyApp());
  }, (error, stack,) => FirebaseCrashlytics.instance.recordError(error, stack, fatal: true));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.

  setFlashVar() async {
    try {
      Constants.isFlashAvailable = await TorchLight.isTorchAvailable();
    } catch (e) {
      Constants.isFlashAvailable = false;
    }
  }

  @override
  void initState() {
    super.initState();
    DartFunctions.initControllers();
    setFlashVar();
  }

  @override
  void dispose() {
    Get.deleteAll();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(600.9389348488247, 961.5022957581195),
      builder: (context, child) => GetMaterialApp(
          title: 'E-thread',
          theme: ThemeConfig.lightTheme,
          themeMode: ThemeMode.system,
          home: child),
      child: FutureBuilder<bool>(
        future: DartFunctions.isLoggedIn(),
        builder: (BuildContext context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.data != null && snapshot.data == true) {
              return Constants.userType == Constants.permenant
                  ? const HomeScreen()
                  : RouteScreen(routes: const []);
            } else {
              return const SplashScreen();
            }
          } else {
            return const Center();
          }
        },
      ),
    );
  }
}
