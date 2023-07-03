import 'package:equatable/equatable.dart';
import 'package:md_detection/src/data/models/bounding_box_model.dart';
import 'package:md_detection/src/domain/entities/object_detected.dart';

class ObjectDetectionModel extends Equatable {
  final int objectDetectedClass;
  final double confidence;
  final BoundingBoxModel boundingBox;

  const ObjectDetectionModel({
    required this.objectDetectedClass,
    required this.confidence,
    required this.boundingBox,
  });

  factory ObjectDetectionModel.fromJson(Map<String, dynamic> json) =>
      ObjectDetectionModel(
        objectDetectedClass: json["class"],
        confidence: json["confidence"].toDouble(),
        boundingBox: BoundingBoxModel.fromJson(json["bounding_box"]),
      );
  Map<String, dynamic> toJson() => {
        "class": objectDetectedClass,
        "confidence": confidence,
        "bounding_box": boundingBox.toJson(),
      };

  ObjectDetected toEntity() {
    return ObjectDetected(
      objectDetectedClass: objectDetectedClass,
      confidence: confidence,
      boundingBox: boundingBox.toEntity(),
    );
  }

  @override
  List<Object?> get props => [objectDetectedClass, confidence, boundingBox];
}
