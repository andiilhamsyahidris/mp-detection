import 'package:dartz/dartz.dart';
import 'package:md_detection/core/utils/failure.dart';
import 'package:md_detection/src/domain/entities/detection.dart';
import 'package:md_detection/src/domain/repositories/mp_repositories.dart';

class DetectionUsecase {
  final MpRepositories repositories;

  DetectionUsecase({required this.repositories});

  Future<Either<Failure, Detection>> execute(String image) {
    return repositories.getDetectionResult(image);
  }
}
