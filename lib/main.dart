import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'injection.dart' as di;
import 'package:md_detection/md_detection.dart';

late List<CameraDescription> cameras;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  di.init();
  cameras = await availableCameras();

  runApp(const MdDetection());
}
