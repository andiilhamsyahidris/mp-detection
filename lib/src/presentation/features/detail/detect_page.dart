import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:md_detection/core/constant/app_route.dart';
import 'package:md_detection/core/constant/color_const.dart';
import 'package:md_detection/core/constant/text_const.dart';
import 'package:md_detection/src/domain/entities/bounding_box.dart';
import 'package:md_detection/src/domain/entities/detection.dart';
import 'package:md_detection/src/presentation/features/home/homepage.dart';
import 'package:md_detection/src/presentation/states/detection_result_helper.dart';
import 'package:md_detection/src/presentation/states/mp_notifier.dart';
import 'package:provider/provider.dart';

void showResult(
    {required BuildContext context, required HelperSection helper}) {
  Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => DetectPage(
          helper: helper,
        ),
        settings: const RouteSettings(
          name: AppRoute.resultPage,
        ),
      ),
      (route) => false);
}

class HelperSection {
  final File fileImage;

  HelperSection({required this.fileImage});
}

class DetectPage extends StatefulWidget {
  final HelperSection helper;

  const DetectPage({super.key, required this.helper});

  @override
  State<DetectPage> createState() => _DetectPageState();
}

class _DetectPageState extends State<DetectPage> {
  double imageWidth = 0;
  double imageHeight = 0;

  @override
  void initState() {
    Future.microtask(() {
      Provider.of<MpNotifier>(context, listen: false).startDetection(
        base64Encode(widget.helper.fileImage.readAsBytesSync()),
      );
      Provider.of<DetectionResultHelper>(context, listen: false)
          .changeResultIndex(0);
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _asyncMethod();
    });
    super.initState();
  }

  void _asyncMethod() async {
    var decodedImage =
        await decodeImageFromList(widget.helper.fileImage.readAsBytesSync());
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    imageWidth = decodedImage.width.toDouble();
    imageHeight = decodedImage.height.toDouble();

    imageHeight = screenWidth * imageHeight / imageWidth;
    imageWidth = screenWidth;

    if (imageHeight > (screenHeight - 130)) {
      double temp = imageHeight;
      imageHeight = screenHeight - 180;
      imageWidth = imageHeight * imageWidth / temp;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<MpNotifier>(
        builder: (context, value, child) {
          if (value.detectionState == RequestState.loading) {
            return const Center(
              child: CircularProgressIndicator(
                color: Palette.purple,
              ),
            );
          } else if (value.detectionState == RequestState.error) {
            return Stack(
              children: [
                Positioned.fill(
                  child: Container(
                    width: imageWidth,
                    height: imageHeight,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: FileImage(widget.helper.fileImage),
                      ),
                    ),
                  ),
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
            );
          } else if (value.detectionState == RequestState.success) {
            if (value.detection.status == 'failed') {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Deteksi Gagal"),
                    GestureDetector(
                      onTap: () => showHomePage(context: context),
                      child: Container(
                        decoration: const BoxDecoration(
                          color: Palette.purple,
                        ),
                        padding: const EdgeInsets.all(8),
                        child: const Icon(
                          Icons.arrow_back,
                          color: Palette.white,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            } else {
              return BuildResult(
                  imageWidth: imageWidth,
                  imageHeight: imageHeight,
                  detection: value.detection,
                  fileImage: widget.helper.fileImage);
            }
          } else {
            return Container();
          }
        },
      ),
    );
  }
}

class BuildResult extends StatefulWidget {
  final double imageWidth;
  final double imageHeight;
  final Detection detection;
  final File fileImage;

  const BuildResult({
    super.key,
    required this.imageWidth,
    required this.imageHeight,
    required this.detection,
    required this.fileImage,
  });

  @override
  State<BuildResult> createState() => _BuildResultState();
}

class _BuildResultState extends State<BuildResult> {
  @override
  void initState() {
    final List<int> listIndex = [];
    for (var e in widget.detection.objectDetected) {
      if (!listIndex.contains(e.objectDetectedClass)) {
        listIndex.add(e.objectDetectedClass);
      }
    }
    String idx = '';
    for (int i = 0; i < listIndex.length; i++) {
      idx += '${listIndex[i]}';
      if (i < listIndex.length - 1) {
        idx += '-';
      }
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<DetectionResultHelper>();
    int currentIndex = provider.resultIndex;

    return Stack(
      children: [
        Positioned.fill(
          child: Container(
            width: widget.imageWidth,
            height: widget.imageHeight,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: FileImage(widget.fileImage),
              ),
            ),
          ),
        ),
        Builder(
          builder: (context) {
            return BuildBoundingBox(
              boundingBox:
                  widget.detection.objectDetected[currentIndex].boundingBox,
              imageHeight: widget.imageHeight,
              imageWidth: widget.imageWidth,
              confidence:
                  widget.detection.objectDetected[currentIndex].confidence,
              name: widget
                  .detection.objectDetected[currentIndex].objectDetectedClass
                  .toString(),
            );
          },
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
    );
  }
}

class BuildBoundingBox extends StatelessWidget {
  final BoundingBox boundingBox;
  final double imageWidth;
  final double imageHeight;
  final double confidence;
  final String name;
  const BuildBoundingBox({
    super.key,
    required this.boundingBox,
    required this.imageHeight,
    required this.imageWidth,
    required this.confidence,
    required this.name,
  });

  String buildTitle(String title) {
    switch (title) {
      case "0":
        return "Chickenpox";
      case "1":
        return "Measles";
      case "2":
        return "Monkeypox";
      case "3":
        return "Normal";
    }
    return "";
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Stack(
        children: [
          Positioned(
            top: boundingBox.ymin * imageHeight - 80,
            left: boundingBox.xmin * imageWidth,
            child: Container(
              decoration: BoxDecoration(
                color: Palette.purple,
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.all(8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Flexible(
                    child: Text(
                      buildTitle(name),
                      style: kTextTheme.titleMedium
                          ?.copyWith(color: Palette.white),
                    ),
                  ),
                  Flexible(
                    child: Text(
                      '${(confidence * 100).toStringAsFixed(2)}%',
                      style: kTextTheme.titleMedium
                          ?.copyWith(color: Palette.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: boundingBox.ymin * imageHeight,
            left: boundingBox.xmin * imageWidth,
            child: Container(
              width: (boundingBox.xmax * imageWidth) -
                  (boundingBox.xmin * imageWidth),
              height: (boundingBox.ymax * imageHeight) -
                  (boundingBox.ymin * imageHeight),
              decoration: BoxDecoration(
                  border: Border.all(
                width: 2,
                color: Palette.purple,
              )),
            ),
          ),
        ],
      ),
    );
  }
}
