import 'package:equatable/equatable.dart';
import 'package:md_detection/src/domain/entities/bounding_box.dart';

class BoundingBoxModel extends Equatable {
  final double xmin;
  final double xmax;
  final double ymin;
  final double ymax;

  const BoundingBoxModel({
    required this.xmax,
    required this.xmin,
    required this.ymax,
    required this.ymin,
  });

  factory BoundingBoxModel.fromJson(Map<String, dynamic> json) =>
      BoundingBoxModel(
        xmax: json["xmax"].toDouble(),
        xmin: json["xmin"].toDouble(),
        ymax: json["ymax"].toDouble(),
        ymin: json["ymin"].toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "xmin": xmin,
        "xmax": xmax,
        "ymin": ymin,
        "ymax": ymax,
      };

  BoundingBox toEntity() {
    return BoundingBox(xmin: xmin, xmax: xmax, ymin: ymin, ymax: ymax);
  }

  @override
  List<Object?> get props => [xmax, xmin, ymax, ymin];
}
