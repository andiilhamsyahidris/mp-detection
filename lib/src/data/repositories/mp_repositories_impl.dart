import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:md_detection/core/utils/exception.dart';
import 'package:md_detection/core/utils/failure.dart';
import 'package:md_detection/src/data/datasources/mp_datasource.dart';
import 'package:md_detection/src/domain/entities/detection.dart';
import 'package:md_detection/src/domain/repositories/mp_repositories.dart';

class MpRepositoriesImpl implements MpRepositories {
  final MpDatasource mpDatasource;

  MpRepositoriesImpl({
    required this.mpDatasource,
  });

  @override
  Future<Either<Failure, Detection>> getDetectionResult(String image) async {
    try {
      final result = await mpDatasource.getDetectionResult(image);
      return Right(result.toEntity());
    } on ServerException {
      return const Left(ServerFailure(''));
    } on SocketException {
      return const Left(ConnectionFailure('Failed to connect to the network'));
    }
  }
}
