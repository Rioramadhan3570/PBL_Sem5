// lib/models/dosen/pelatihan_rekomendasi_model.dart
class Pelatihan {
  final String id;
  final String? disukaiId;
  final String nama;
  final String tempat;
  final DateTime? pelatihanStart;
  final DateTime? pelatihanEnd;
  final String? waktuPelaksanaan; // Tambahkan field baru
  final int kuota;
  final double biaya;
  final String level;
  final Map<String, dynamic> vendor;
  final Map<String, dynamic> jenis;
  final List<Map<String, dynamic>> bidangMinat;
  final List<Map<String, dynamic>> mataKuliah;
  final String type;

  Pelatihan({
    required this.id,
    this.disukaiId,
    required this.nama,
    required this.tempat,
    this.pelatihanStart,
    this.pelatihanEnd,
    this.waktuPelaksanaan,
    required this.kuota,
    required this.biaya,
    required this.level,
    required this.vendor,
    required this.jenis,
    required this.bidangMinat,
    required this.mataKuliah,
    this.type = 'pelatihan',
  });

  factory Pelatihan.fromJson(Map<String, dynamic> json) {
    // Helper function untuk mengkonversi list ke format yang diinginkan
    List<Map<String, dynamic>> convertToMapList(dynamic value) {
      if (value == null) return [];
      if (value is! List) return [];

      return value.map((item) {
        if (item is Map<String, dynamic>) return item;
        if (item is String) return {'keahlian_nama': item};
        return {'keahlian_nama': item.toString()};
      }).toList();
    }

    return Pelatihan(
      id: json['id']?.toString() ?? '',
      disukaiId: json['disukai_id']?.toString(),
      nama: json['nama']?.toString() ?? '',
      tempat: json['tempat']?.toString() ?? '',
      pelatihanStart: json['pelatihan_start'] != null
          ? DateTime.tryParse(json['pelatihan_start'].toString())
          : null,
      pelatihanEnd: json['pelatihan_end'] != null
          ? DateTime.tryParse(json['pelatihan_end'].toString())
          : null,
      waktuPelaksanaan: json['waktu']?.toString(),
      kuota: int.tryParse(json['kuota']?.toString() ?? '0') ?? 0,
      biaya: double.tryParse(json['biaya']?.toString() ?? '0') ?? 0.0,
      level: json['level']?.toString() ?? '',
      vendor: json['vendor'] is Map
          ? Map<String, dynamic>.from(json['vendor'])
          : {'vendor_nama': json['vendor']?.toString() ?? ''},
      jenis: json['jenis'] is Map
          ? Map<String, dynamic>.from(json['jenis'])
          : {'jenis_nama': json['jenis_kompetensi']?.toString() ?? ''},
      bidangMinat: convertToMapList(json['bidang_minat']),
      mataKuliah: convertToMapList(json['mata_kuliah']),
      type: json['type']?.toString().toLowerCase() ?? 'pelatihan',
    );
  }
}
