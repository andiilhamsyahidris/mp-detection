import 'package:dartz/dartz.dart';
import 'package:md_detection/core/utils/failure.dart';
import 'package:md_detection/src/domain/entities/detection.dart';

abstract class MpRepositories {
  Future<Either<Failure, Detection>> getDetectionResult(String image);
}
