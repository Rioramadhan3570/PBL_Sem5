// base_form.dart
import 'package:flutter/material.dart';
import 'form_data.dart';

abstract class BaseForm extends StatefulWidget {
  const BaseForm({Key? key}) : super(key: key);
}

abstract class BaseFormState<T extends BaseForm> extends State<T> {
  final formKey = GlobalKey<FormState>();
  final judulController = TextEditingController();
  final biayaController = TextEditingController();
  final tempatController = TextEditingController();
  final tanggalController = TextEditingController();
  final waktuController = TextEditingController();
  
  String? selectedVendor;
  String? selectedJenis;
  String? selectedLevel;
  String? selectedBidangMinat;
  String? selectedMataKuliah;

  Widget buildDropdownField({
    required String label,
    required List<String> items,
    required String? value,
    required void Function(String?) onChanged,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButtonFormField<String>(
        isExpanded: true,
        value: value,
        decoration: InputDecoration(
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16),
        ),
        hint: Text(label),
        items: items.map((String item) {
          return DropdownMenuItem<String>(
            value: item,
            child: Text(
              item,
              overflow: TextOverflow.ellipsis,
            ),
          );
        }).toList(),
        onChanged: onChanged,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Field ini harus diisi';
          }
          return null;
        },
      ),
    );
  }

  Widget buildTextField({
    required String label,
    required TextEditingController controller,
    TextInputType? keyboardType,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(8),
      ),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Field ini harus diisi';
          }
          return null;
        },
      ),
    );
  }

  @override
  void dispose() {
    judulController.dispose();
    biayaController.dispose();
    tempatController.dispose();
    tanggalController.dispose();
    waktuController.dispose();
    super.dispose();
  }
}