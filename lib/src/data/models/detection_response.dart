import 'package:equatable/equatable.dart';
import 'package:md_detection/src/data/models/object_detection_model.dart';
import 'package:md_detection/src/domain/entities/detection.dart';
import 'package:md_detection/src/domain/entities/object_detected.dart';

class DetectionResponse extends Equatable {
  final String status;
  final int detectionCount;
  final List<ObjectDetectionModel> objectDetected;

  const DetectionResponse({
    required this.status,
    required this.detectionCount,
    required this.objectDetected,
  });

  factory DetectionResponse.fromJson(Map<String, dynamic> json) =>
      DetectionResponse(
        status: json["status"],
        detectionCount: json["detection_count"],
        objectDetected: List<ObjectDetectionModel>.from(
          json["object_detected"].map(
            (x) => ObjectDetectionModel.fromJson(x),
          ),
        ),
      );
  Map<String, dynamic> toJson() => {
        "status": status,
        "detection_count": detectionCount,
        "object_detected":
            List<dynamic>.from(objectDetected.map((e) => e.toJson())),
      };
  Detection toEntity() {
    return Detection(
      status: status,
      detectionCount: detectionCount,
      objectDetected: objectDetected.map((e) => e.toEntity()).toList(),
    );
  }

  @override
  List<Object?> get props => [status, detectionCount, objectDetected];
}
