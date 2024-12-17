import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:pbl_sem5/models/dosen/mandiri/mandiri_detail_model.dart';
import 'package:pbl_sem5/models/dosen/mandiri/vendor.dart';
import 'package:pbl_sem5/services/dosen/api_mandiri_dosen.dart';
import 'package:pbl_sem5/widgets/dosen/mandiri/header_pelatihan_form.dart';
import 'package:pbl_sem5/widgets/dosen/navbar.dart';

const List<String> LEVEL_OPTIONS = ['Internasional', 'Nasional'];

class PelatihanForm extends StatefulWidget {
  final bool isEdit;
  final String? id;
  final MandiriDetail? initialData;

  const PelatihanForm({
    super.key,
    this.isEdit = false,
    this.id,
    this.initialData,
  });

  @override
  State<PelatihanForm> createState() => _PelatihanFormState();
}

class _PelatihanFormState extends State<PelatihanForm> {
  final _formKey = GlobalKey<FormState>();
  final ApiMandiriDosen _apiMandiriDosen = ApiMandiriDosen();

  // Controllers
  final _namaController = TextEditingController();
  final _tempatController = TextEditingController();
  final _biayaController = TextEditingController();

  // Selected values
  DateTime? _tanggalMulai;
  DateTime? _tanggalAkhir;
  String? _selectedJenisPelatihan;
  String? _selectedJenisKompetensi;
  String? _selectedLevel;
  String? _selectedVendorId;
  List<Map<String, dynamic>> _selectedBidangMinat = [];
  List<Map<String, dynamic>> _selectedMataKuliah = [];

  // Data lists for dropdowns
  List<Map<String, dynamic>> _jenisKompetensiList = [];
  List<Vendor> _vendorList = [];
  List<Map<String, dynamic>> _bidangMinatList = [];
  List<Map<String, dynamic>> _mataKuliahList = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      setState(() => _isLoading = true);

      // Deklarasikan tipe data yang jelas untuk setiap future
      final jenisKompetensiFuture = _apiMandiriDosen.getJenisKompetensi();
      final vendorsFuture = _apiMandiriDosen.getVendors();
      final bidangMinatFuture = _apiMandiriDosen.getBidangMinat();
      final mataKuliahFuture = _apiMandiriDosen.getMataKuliah();

      // Tunggu semua future selesai
      final results = await Future.wait([
        jenisKompetensiFuture,
        vendorsFuture,
        bidangMinatFuture,
        mataKuliahFuture,
      ]);

      // Set state dengan explicit casting
      setState(() {
        _jenisKompetensiList = List<Map<String, dynamic>>.from(results[0]);
        _vendorList = List<Vendor>.from(results[1]);
        _bidangMinatList = List<Map<String, dynamic>>.from(results[2]);
        _mataKuliahList = List<Map<String, dynamic>>.from(results[3]);
        _isLoading = false;
      });

      // If editing, populate form with initial data
      if (widget.isEdit && widget.initialData != null) {
        _loadInitialData();
      }
    } catch (e) {
      setState(() => _isLoading = false);
      _showErrorDialog('Error loading data: $e');
    }
  }

  void _loadInitialData() {
    final data = widget.initialData!;

    setState(() {
      // Basic fields
      _namaController.text = data.judul;
      _tempatController.text = data.tempat;
      _biayaController.text = NumberFormat.currency(
        locale: 'id',
        symbol: 'Rp ',
        decimalDigits: 0,
      ).format(data.biaya);

      // Selected values
      _selectedJenisKompetensi = data.jenisId;
      _selectedLevel = data.level;
      _selectedVendorId = data.vendorId;

      // Complex fields
      _selectedBidangMinat = data.bidangMinat;
      _selectedMataKuliah = data.mataKuliah;

      // Parse dates
      try {
        final timeStr = data.waktu;
        final dateTime =
            DateFormat("dd MMMM yyyy HH:mm").parse("${data.tanggal} $timeStr");
        _tanggalMulai = dateTime;
        _tanggalAkhir = dateTime; // Adjust if you have end date
      } catch (e) {
        debugPrint('Error parsing date: $e');
      }
    });
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedVendorId == null) {
      _showErrorDialog('Vendor harus dipilih');
      return;
    }
    if (_selectedBidangMinat.isEmpty) {
      _showErrorDialog('Minimal satu bidang minat harus dipilih');
      return;
    }
    if (_selectedMataKuliah.isEmpty) {
      _showErrorDialog('Minimal satu mata kuliah harus dipilih');
      return;
    }

    try {
      final dosenId = await _apiMandiriDosen.getDosenId();
      if (dosenId == null) {
        throw Exception('Dosen ID tidak ditemukan');
      }

      final data = {
        'jenis_id': _selectedJenisKompetensi,
        'vendor_id': int.parse(_selectedVendorId!),
        'pelatihan_nama': _namaController.text,
        'pelatihan_start': _tanggalMulai!.toIso8601String(),
        'pelatihan_end': _tanggalAkhir!.toIso8601String(),
        'pelatihan_tempat': _tempatController.text,
        'pelatihan_biaya':
            int.parse(_biayaController.text.replaceAll(RegExp(r'[^0-9]'), '')),
        'pelatihan_jenis': _selectedJenisPelatihan,
        'pelatihan_level': _selectedLevel,
        'keahlian': _selectedBidangMinat
            .map((e) => int.parse(e['id'].toString()))
            .toList(),
        'matkul': _selectedMataKuliah
            .map((e) => int.parse(e['id'].toString()))
            .toList(),
        'dosen_id': int.parse(dosenId),
      };

      if (widget.isEdit && widget.id != null) {
        await _apiMandiriDosen.updatePelatihan(widget.id!, data);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Pelatihan berhasil diperbarui')),
          );
          Navigator.pop(context);
        }
      } else {
        await _apiMandiriDosen.createPelatihan(data);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Pelatihan berhasil dibuat')),
          );
          Navigator.pop(context);
        }
      }
    } catch (e) {
      _showErrorDialog('Error: ${e.toString()}');
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      validator: validator,
    );
  }

  Widget _buildDropdown({
    required String label,
    required String? value,
    required List<String> items,
    required void Function(String?) onChanged,
  }) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      value: value,
      items: items.map((String item) {
        return DropdownMenuItem<String>(
          value: item,
          child: Text(item),
        );
      }).toList(),
      onChanged: onChanged,
      validator: (v) => v == null ? '$label harus dipilih' : null,
    );
  }

  Widget _buildDatePicker({
    required String label,
    required DateTime? value,
    required void Function(DateTime) onChanged,
  }) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: const BorderSide(color: Colors.blue),
        ),
        suffixIcon: const Icon(Icons.calendar_today, color: Colors.blue),
      ),
      readOnly: true,
      controller: TextEditingController(
        text: value != null ? DateFormat('dd/MM/yyyy HH:mm').format(value) : '',
      ),
      onTap: () async {
        final date = await showDatePicker(
          context: context,
          initialDate: value ?? DateTime.now(),
          firstDate: DateTime(2000),
          lastDate: DateTime(2100),
        );
        if (date != null) {
          final time = await showTimePicker(
            context: context,
            initialTime: TimeOfDay.fromDateTime(value ?? DateTime.now()),
          );
          if (time != null) {
            onChanged(DateTime(
              date.year,
              date.month,
              date.day,
              time.hour,
              time.minute,
            ));
          }
        }
      },
      validator: (v) => v?.isEmpty ?? true ? '$label harus diisi' : null,
    );
  }

  Widget _buildVendorSelector() {
    final selectedVendor = _vendorList.firstWhere(
      (v) => v.vendorId == _selectedVendorId,
      orElse: () => Vendor(vendorId: '', vendorNama: ''),
    );

    return FormField<String>(
      builder: (state) {
        return InkWell(
          onTap: _showVendorDialog,
          child: InputDecorator(
            decoration: const InputDecoration(
              labelText: 'Vendor',
              floatingLabelBehavior: FloatingLabelBehavior.always,
              border: OutlineInputBorder(),
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
            isEmpty: selectedVendor.vendorId.isEmpty,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  selectedVendor.vendorId.isNotEmpty
                      ? selectedVendor.vendorNama
                      : 'Pilih Vendor',
                  style: TextStyle(
                    color: selectedVendor.vendorId.isNotEmpty
                        ? Colors.black
                        : Colors.grey[600],
                  ),
                ),
                const Icon(Icons.arrow_drop_down),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _showVendorDialog() async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Pilih Vendor'),
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () => _showAddVendorDialog(),
            ),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: _vendorList
                .map((vendor) => ListTile(
                      title: Text(vendor.vendorNama),
                      subtitle: Text(vendor.vendorKota ?? ''),
                      onTap: () {
                        setState(() => _selectedVendorId = vendor.vendorId);
                        Navigator.pop(context);
                      },
                    ))
                .toList(),
          ),
        ),
      ),
    );
  }

  Future<void> _showAddVendorDialog() async {
    final formKey = GlobalKey<FormState>();
    final namaController = TextEditingController();
    final alamatController = TextEditingController();
    final kotaController = TextEditingController();
    final teleponController = TextEditingController();
    final webController = TextEditingController();

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Tambah Vendor Baru'),
        content: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: namaController,
                  decoration: const InputDecoration(labelText: 'Nama Vendor'),
                  validator: (v) =>
                      v?.isEmpty ?? true ? 'Nama harus diisi' : null,
                ),
                TextFormField(
                  controller: alamatController,
                  decoration: const InputDecoration(labelText: 'Alamat'),
                  validator: (v) =>
                      v?.isEmpty ?? true ? 'Alamat harus diisi' : null,
                ),
                TextFormField(
                  controller: kotaController,
                  decoration: const InputDecoration(labelText: 'Kota'),
                  validator: (v) =>
                      v?.isEmpty ?? true ? 'Kota harus diisi' : null,
                ),
                TextFormField(
                  controller: teleponController,
                  decoration: const InputDecoration(labelText: 'Telepon'),
                  validator: (v) =>
                      v?.isEmpty ?? true ? 'Telepon harus diisi' : null,
                ),
                TextFormField(
                  controller: webController,
                  decoration: const InputDecoration(labelText: 'Alamat Web'),
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () async {
              if (formKey.currentState?.validate() ?? false) {
                try {
                  final newVendor = await _apiMandiriDosen.createVendor({
                    'vendor_nama': namaController.text,
                    'vendor_alamat': alamatController.text,
                    'vendor_kota': kotaController.text,
                    'vendor_telepon': teleponController.text,
                    'vendor_alamat_web': webController.text,
                  });
                  setState(() {
                    _vendorList.add(newVendor);
                    _selectedVendorId = newVendor.vendorId;
                  });
                  Navigator.pop(context);
                  Navigator.pop(context);
                } catch (e) {
                  _showErrorDialog('Error creating vendor: $e');
                }
              }
            },
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }

  Widget _buildMultiSelector({
    required String title,
    required List<Map<String, dynamic>> selectedItems,
    required List<Map<String, dynamic>> allItems,
    required Function(List<Map<String, dynamic>>) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontSize: 16)),
        const SizedBox(height: 8),
        InkWell(
          onTap: () => _showMultiSelectDialog(
            title: 'Pilih $title',
            items: allItems,
            selectedItems: selectedItems,
            onChanged: onChanged,
          ),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ...selectedItems.map((item) => Chip(
                      label: Text(item['nama'] ?? ''),
                      onDeleted: () {
                        setState(() {
                          selectedItems.removeWhere(
                            (selected) => selected['id'] == item['id'],
                          );
                        });
                      },
                    )),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () => _showMultiSelectDialog(
                    title: 'Pilih $title',
                    items: allItems,
                    selectedItems: selectedItems,
                    onChanged: onChanged,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _showMultiSelectDialog({
    required String title,
    required List<Map<String, dynamic>> items,
    required List<Map<String, dynamic>> selectedItems,
    required Function(List<Map<String, dynamic>>) onChanged,
  }) async {
    final List<Map<String, dynamic>> tempSelected = [...selectedItems];
    await showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text(title),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: items.map((item) {
                final isSelected = tempSelected.any(
                  (selected) => selected['id'] == item['id'],
                );
                return CheckboxListTile(
                  title: Text(item['nama'] ?? 'Unnamed'),
                  value: isSelected,
                  onChanged: (bool? value) {
                    setState(() {
                      if (value ?? false) {
                        if (!tempSelected
                            .any((selected) => selected['id'] == item['id'])) {
                          tempSelected.add(item);
                        }
                      } else {
                        tempSelected.removeWhere(
                          (selected) => selected['id'] == item['id'],
                        );
                      }
                    });
                  },
                );
              }).toList(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal'),
            ),
            TextButton(
              onPressed: () {
                onChanged(tempSelected);
                Navigator.pop(context);
              },
              child: const Text('Selesai'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: HeaderPelatihanForm(
          showBackButton: true,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTextField(
                controller: _namaController,
                label: 'Nama Pelatihan',
                validator: (v) =>
                    v?.isEmpty ?? true ? 'Nama harus diisi' : null,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _buildDatePicker(
                      label: 'Tanggal Mulai',
                      value: _tanggalMulai,
                      onChanged: (date) => setState(() => _tanggalMulai = date),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildDatePicker(
                      label: 'Tanggal Selesai',
                      value: _tanggalAkhir,
                      onChanged: (date) => setState(() => _tanggalAkhir = date),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _tempatController,
                label: 'Tempat',
                validator: (v) =>
                    v?.isEmpty ?? true ? 'Tempat harus diisi' : null,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _biayaController,
                label: 'Biaya',
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  TextInputFormatter.withFunction((oldValue, newValue) {
                    if (newValue.text.isEmpty) return newValue;
                    final number = int.parse(newValue.text);
                    final formatted = NumberFormat.currency(
                      locale: 'id',
                      symbol: 'Rp ',
                      decimalDigits: 0,
                    ).format(number);
                    return TextEditingValue(
                      text: formatted,
                      selection:
                          TextSelection.collapsed(offset: formatted.length),
                    );
                  }),
                ],
                validator: (v) =>
                    v?.isEmpty ?? true ? 'Biaya harus diisi' : null,
              ),
              const SizedBox(height: 16),
              _buildVendorSelector(),
              const SizedBox(height: 16),
              _buildDropdown(
                label: 'Level',
                value: _selectedLevel,
                items: LEVEL_OPTIONS,
                onChanged: (value) => setState(() => _selectedLevel = value),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Jenis Kompetensi',
                  border: OutlineInputBorder(),
                ),
                value: _selectedJenisKompetensi,
                items: _jenisKompetensiList.map((jenis) {
                  return DropdownMenuItem<String>(
                    value: jenis['jenis_id'].toString(),
                    child: Text(jenis['jenis_nama']),
                  );
                }).toList(),
                onChanged: (value) =>
                    setState(() => _selectedJenisKompetensi = value),
                validator: (v) =>
                    v == null ? 'Jenis kompetensi harus dipilih' : null,
              ),
              const SizedBox(height: 16),
              _buildMultiSelector(
                title: 'Bidang Minat',
                selectedItems: _selectedBidangMinat,
                allItems: _bidangMinatList,
                onChanged: (items) =>
                    setState(() => _selectedBidangMinat = items),
              ),
              const SizedBox(height: 16),
              _buildMultiSelector(
                title: 'Mata Kuliah',
                selectedItems: _selectedMataKuliah,
                allItems: _mataKuliahList,
                onChanged: (items) =>
                    setState(() => _selectedMataKuliah = items),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submitForm,
                  child: Text(
                      widget.isEdit ? 'Edit Pelatihan' : 'Simpan Pelatihan'),
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
