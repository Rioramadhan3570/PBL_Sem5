// lib/models/monitoring/monitoring_response_model.dart
import 'package:pbl_sem5/models/pimpinan/pimpinan_monitoring/monitorng_model.dart';

class MonitoringResponseModel {
  final bool status;
  final String message;
  final List<MonitoringModel> data;

  MonitoringResponseModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory MonitoringResponseModel.fromJson(Map<String, dynamic> json) {
    return MonitoringResponseModel(
      status: json['status'] ?? false,
      message: json['message'] ?? '',
      data: (json['data'] as List? ?? [])
          .map((item) => MonitoringModel.fromJson(item))
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