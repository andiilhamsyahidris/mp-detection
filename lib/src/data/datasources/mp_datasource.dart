import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:md_detection/core/utils/exception.dart';
import 'package:md_detection/src/data/models/detection_response.dart';

abstract class MpDatasource {
  Future<DetectionResponse> getDetectionResult(String image);
}

class MpDatasourceImpl implements MpDatasource {
  static const BASE_URL = 'http://34.101.191.172:8000';
  final http.Client client;

  MpDatasourceImpl({required this.client});

  @override
  Future<DetectionResponse> getDetectionResult(String image) async {
    Map data = {
      "image": image,
    };
    final response = await client.post(
      Uri.parse('$BASE_URL/detect'),
      body: json.encode(data),
    );

    if (response.statusCode == 200) {
      return DetectionResponse.fromJson(json.decode(response.body));
    } else {
      throw ServerException();
    }
  }
}
