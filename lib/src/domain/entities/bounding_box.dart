import 'package:equatable/equatable.dart';

class BoundingBox extends Equatable {
  final double xmin;
  final double xmax;
  final double ymin;
  final double ymax;

  const BoundingBox({
    required this.xmin,
    required this.xmax,
    required this.ymin,
    required this.ymax,
  });

  @override
  List<Object?> get props => [xmin, xmax, ymin, ymax];
}
