import 'package:equatable/equatable.dart';
import 'package:md_detection/src/domain/entities/bounding_box.dart';

class ObjectDetected extends Equatable {
  final int objectDetectedClass;
  final double confidence;
  final BoundingBox boundingBox;

  const ObjectDetected({
    required this.objectDetectedClass,
    required this.confidence,
    required this.boundingBox,
  });

  @override
  List<Object?> get props => [objectDetectedClass, confidence, boundingBox];
}
