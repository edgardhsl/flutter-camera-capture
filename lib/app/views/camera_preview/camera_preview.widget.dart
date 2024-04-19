import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_camera_capture/app/views/camera_preview/widgets/buttons/button_recorder.widget.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:developer';

class CameraPreviewWidget extends StatefulWidget {
  const CameraPreviewWidget({super.key});

  @override
  State<CameraPreviewWidget> createState() => _CameraPreviewWidgetState();
}

class _CameraPreviewWidgetState extends State<CameraPreviewWidget> {
  late CameraController controller;
  List<CameraDescription>? cameras;
  bool _isReady = false;

  Future<void> _setupCameras() async {
    try {
      var status = await Permission.storage.status;
      if (!status.isGranted) {
        await Permission.storage.request();
      }

      // initialize cameras.
      cameras = await availableCameras();
      // initialize camera controllers.
      controller = CameraController(cameras![0], ResolutionPreset.high);
      await controller.initialize();
    } on CameraException catch (e) {
      log("CameraException: ${e.description}");
    }
    if (!mounted) return;
    setState(() {
      _isReady = true;
    });
  }

  @override
  void initState() {
    super.initState();
    _setupCameras();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isReady) return Container();

    return Stack(
      fit: StackFit.expand,
      alignment: Alignment.bottomCenter,
      children: [
        CameraPreview(controller),
        RecordButtonWidget(cameraController: controller),
      ],
    );
  }
}
