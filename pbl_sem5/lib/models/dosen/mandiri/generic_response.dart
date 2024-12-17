// models/generic_response.dart
import 'package:equatable/equatable.dart';

class GenericResponse extends Equatable {
  final String message;
  final dynamic data;
  final String? error;

  const GenericResponse({
    required this.message,
    this.data,
    this.error,
  });

  factory GenericResponse.fromJson(Map<String, dynamic> json) {
    return GenericResponse(
      message: json['message'],
      data: json['data'],
      error: json['error'],
    );
  }

  @override
  List<Object?> get props => [message, data, error];
}