import 'package:camera/camera.dart';
import 'package:ethread_app/main.dart';
import 'package:flutter/material.dart';

class CameraPreviewWidget extends StatefulWidget {
  final Function(CameraController controller) takePicture;
  const CameraPreviewWidget({required this.takePicture, Key? key})
      : super(key: key);

  @override
  State<CameraPreviewWidget> createState() => _CameraPreviewWidgetState();
}

class _CameraPreviewWidgetState extends State<CameraPreviewWidget> with WidgetsBindingObserver {
  late XFile file;
  late CameraController controller;

  onNewCameraSelected() {
    controller = CameraController(
        cameras.first,
        ResolutionPreset.max,
        enableAudio: false,
      );
    controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance?.addObserver(this);
    onNewCameraSelected();
  }


  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // App state changed before we got the chance to initialize.
    if (!controller.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.inactive) {
      controller.dispose();
    } else if (state == AppLifecycleState.resumed) {
      onNewCameraSelected();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance?.removeObserver(this);
    if(controller.value.isInitialized)controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!controller.value.isInitialized) {
      return Container(
        color: Colors.black,
      );
    }
    return Stack(
      fit: StackFit.expand,
      alignment: Alignment.bottomCenter,
      children: [
        CameraPreview(controller),
        Positioned(
          bottom: 16.0,
          child: FloatingActionButton(
            child: const Icon(
              Icons.camera_alt,
              color: Colors.black87,
            ),
            backgroundColor: Colors.white,
            onPressed: () async {
              widget.takePicture(controller);
            },
          ),
        ),
      ],
    );
  }
}
