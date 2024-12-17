// models/dropdown_item.dart
import 'package:equatable/equatable.dart';

class DropdownItem extends Equatable {
  final String value;
  final String label;

  const DropdownItem({
    required this.value,
    required this.label,
  });

  factory DropdownItem.fromJson(Map<String, dynamic> json) {
    return DropdownItem(
      value: json['value'].toString(),
      label: json['label'],
    );
  }

  @override
  List<Object?> get props => [value, label];
}