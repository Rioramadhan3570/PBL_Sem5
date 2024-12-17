// lib/models/monitoring/detail_response_model.dart
import 'package:pbl_sem5/models/pimpinan/pimpinan_monitoring/detail_monitoring_model.dart';

class DetailResponseModel {
  final bool status;
  final String message;
  final List<DetailMonitoringModel> data;

  DetailResponseModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory DetailResponseModel.fromJson(Map<String, dynamic> json) {
    return DetailResponseModel(
      status: json['status'] ?? false,
      message: json['message'] ?? '',
      data: (json['data'] as List? ?? [])
          .map((item) => DetailMonitoringModel.fromJson(item))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'data': data.map((item) => item.toJson()).toList(),
    };
  }
}