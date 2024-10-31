// sertifikasi_form.dart
import 'package:flutter/material.dart';
import 'base_form.dart';
import 'form_data.dart';
import 'navbar.dart';

class SertifikasiForm extends BaseForm {
  const SertifikasiForm({Key? key}) : super(key: key);

  @override
  State<SertifikasiForm> createState() => _SertifikasiFormState();
}

class _SertifikasiFormState extends BaseFormState<SertifikasiForm> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pengajuan Sertifikasi'),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              buildTextField(
                label: 'Judul',
                controller: judulController,
              ),
              buildTextField(
                label: 'Biaya',
                controller: biayaController,
                keyboardType: TextInputType.number,
              ),
              buildDropdownField(
                label: 'Pilih Vendor',
                items: FormData.vendors,
                value: selectedVendor,
                onChanged: (value) {
                  setState(() {
                    selectedVendor = value;
                  });
                },
              ),
              buildTextField(
                label: 'Tempat',
                controller: tempatController,
              ),
              buildTextField(
                label: 'Tanggal',
                controller: tanggalController,
              ),
              buildTextField(
                label: 'Waktu',
                controller: waktuController,
              ),
              buildDropdownField(
                label: 'Pilih Jenis',
                items: FormData.jenis,
                value: selectedJenis,
                onChanged: (value) {
                  setState(() {
                    selectedJenis = value;
                  });
                },
              ),
              buildDropdownField(
                label: 'Pilih Tag Bidang Minat',
                items: FormData.bidangMinat,
                value: selectedBidangMinat,
                onChanged: (value) {
                  setState(() {
                    selectedBidangMinat = value;
                  });
                },
              ),
              buildDropdownField(
                label: 'Pilih Tag Mata Kuliah',
                items: FormData.mataKuliah,
                value: selectedMataKuliah,
                onChanged: (value) {
                  setState(() {
                    selectedMataKuliah = value;
                  });
                },
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      // Create certification data object
                      final certificationData = {
                        'judul': judulController.text,
                        'biaya': biayaController.text,
                        'vendor': selectedVendor,
                        'tempat': tempatController.text,
                        'tanggal': tanggalController.text,
                        'waktu': waktuController.text,
                        'jenis': selectedJenis,
                        'bidangMinat': selectedBidangMinat,
                        'mataKuliah': selectedMataKuliah,
                      };
                      
                      // Here you can handle the form submission
                      print('Certification Data: $certificationData');
                      
                      // Show success message
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Form Sertifikasi berhasil disimpan'),
                          backgroundColor: Colors.green,
                        ),
                      );
                      
                      // Navigate back
                      Navigator.pop(context);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0D47A1),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Simpan',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const Navbar(selectedIndex: 2),
    );
  }
}