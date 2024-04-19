import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_camera_capture/app/services/video/frame_extrator.dart';
import 'package:flutter_camera_capture/app/views/camera_preview/widgets/modal/audio_player.widget.dart';
import 'package:styled_widget/styled_widget.dart';

class RecordButtonWidget extends StatefulWidget {
  final CameraController cameraController;
  double progress;

  RecordButtonWidget(
      {required this.cameraController, this.progress = 0, super.key});

  @override
  State<RecordButtonWidget> createState() => _RecordButtonWidgetState();
}

class _RecordButtonWidgetState extends State<RecordButtonWidget> {
  int totalSecs = 5;
  bool startRecording = false;


  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Styled.widget(
        child: startRecording
            ? TweenAnimationBuilder<double>(
          tween: Tween(begin: 0, end: 1),
          duration: Duration(seconds: totalSecs),
          builder: (context, value, _) =>
              CircularProgressIndicator(value: value),
        )
            : Container()) // red circle
        .decorated(
        color: Colors.red,
        border: Border.all(color: Colors.white, width: 5),
        borderRadius: BorderRadius.circular(50))
        .gestures(
      onTap: () {
        _startRecording();
        Future.delayed(Duration(seconds: totalSecs + 1))
            .then(_stopRecording);
      },
    ).gestures(
      onTap: () {},
    ).positioned(height: 80, width: 80, bottom: 140);
  }

  _startRecording() {
    widget.cameraController.startVideoRecording();

    setState(() {
      startRecording = true;
    });
  }

  _stopRecording(value) async {
    XFile video = await widget.cameraController.stopVideoRecording();
    List<File> files = await FrameExtractor(path: video.path).getBySeconds(seconds: totalSecs);
    setState(() {
      startRecording = false;
    });
    _openAudioModal();
  }

  _openAudioModal() {
    showDialog<void>(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return const AudioPlayer();
        },
    );
  }
}
