import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:md_detection/core/constant/app_route.dart';
import 'package:md_detection/core/constant/color_const.dart';
import 'package:md_detection/main.dart';
import 'package:md_detection/src/presentation/features/detail/detect_page.dart';
import 'package:md_detection/src/presentation/features/home/homepage.dart';

void showCamera({required BuildContext context}) {
  Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => const CameraDetail(),
        settings: const RouteSettings(
          name: AppRoute.detailPage,
        ),
      ),
      (route) => false);
}

class CameraDetail extends StatefulWidget {
  const CameraDetail({super.key});

  @override
  State<CameraDetail> createState() => _CameraDetailState();
}

class _CameraDetailState extends State<CameraDetail> {
  late CameraController controller;

  @override
  void initState() {
    super.initState();
    controller = CameraController(
      cameras[0],
      ResolutionPreset.high,
    );
    controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    }).catchError((Object e) {
      if (e is CameraException) {
        switch (e.code) {
          case 'CameraAccessDenied':
            // Handle access errors here.
            break;
          default:
            // Handle other errors here.
            break;
        }
      }
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: Stack(
        children: [
          Positioned.fill(
            child: CameraPreview(controller),
          ),
          Positioned(
            top: 50,
            left: 20,
            child: GestureDetector(
              onTap: () => showHomePage(context: context),
              child: Container(
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Palette.purple,
                ),
                padding: const EdgeInsets.all(8),
                child: const Icon(
                  Icons.arrow_back,
                  color: Palette.white,
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          try {
            controller.setFlashMode(FlashMode.off);
            final image = await controller.takePicture();
            if (!mounted) return;

            showResult(
                context: context,
                helper: HelperSection(fileImage: File(image.path)));
          } catch (e) {
            throw Exception(e);
          }
        },
        backgroundColor: Colors.transparent,
        splashColor: Colors.transparent,
        elevation: 0,
        child: Container(
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Palette.purple,
          ),
          padding: const EdgeInsets.all(16),
          child: const Icon(
            Icons.camera_alt_outlined,
            color: Palette.white,
          ),
        ),
      ),
    );
  }
}
