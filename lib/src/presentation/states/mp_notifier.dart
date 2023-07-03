import 'package:flutter/material.dart';
import 'package:md_detection/src/domain/entities/detection.dart';
import 'package:md_detection/src/domain/usecases/detection_usecase.dart';

enum RequestState { init, loading, error, success }

class MpNotifier extends ChangeNotifier {
  final DetectionUsecase detectionUsecase;
  MpNotifier({required this.detectionUsecase});

  late Detection _detection;
  Detection get detection => _detection;

  RequestState _detectionState = RequestState.init;
  RequestState get detectionState => _detectionState;

  String _message = '';
  String get message => _message;

  Future<void> startDetection(String image) async {
    _detectionState = RequestState.loading;
    notifyListeners();

    final result = await detectionUsecase.execute(image);
    result.fold((failure) {
      _detectionState = RequestState.error;
      _message = failure.message;
      notifyListeners();
    }, (data) {
      _detectionState = RequestState.success;
      _detection = data;
      notifyListeners();
    });
  }
}
