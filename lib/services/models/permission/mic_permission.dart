import 'package:permission_handler/permission_handler.dart';

class MicPermission{

  static final MicPermission _singleton = MicPermission._internal();

  factory MicPermission() => _singleton;

  MicPermission._internal();

  bool? _status;

  void setStatus() async {
    _status = await Permission.microphone.status.isGranted;
  }

  bool getStatus(){

    return _status!;
  }

}