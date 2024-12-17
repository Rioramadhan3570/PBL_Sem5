class PesertaRiwayatResponse {
  final String status;
  final PesertaRiwayatData data;

  PesertaRiwayatResponse({
    required this.status,
    required this.data,
  });

  factory PesertaRiwayatResponse.fromJson(Map<String, dynamic> json) {
    return PesertaRiwayatResponse(
      status: json['status'],
      data: PesertaRiwayatData.fromJson(json['data']),
    );
  }

  Map<String, dynamic> toJson() => {
    'status': status,
    'data': data.toJson(),
  };
}

class PesertaRiwayatData {
  final String judul;
  final String kategori;
  final List<PesertaData> peserta;

  PesertaRiwayatData({
    required this.judul,
    required this.kategori,
    required this.peserta,
  });

  factory PesertaRiwayatData.fromJson(Map<String, dynamic> json) {
    return PesertaRiwayatData(
      judul: json['judul'],
      kategori: json['kategori'],
      peserta: (json['peserta'] as List)
          .map((item) => PesertaData.fromJson(item))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    'judul': judul,
    'kategori': kategori,
    'peserta': peserta.map((item) => item.toJson()).toList(),
  };
}

class PesertaData {
  final String id;
  final String nama;

  PesertaData({
    required this.id,
    required this.nama,
  });

  factory PesertaData.fromJson(Map<String, dynamic> json) {
    return PesertaData(
      id: json['id'].toString(),
      nama: json['nama'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'nama': nama,
  };
}