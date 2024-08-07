class ModelDatabase {
  int? id;
  String? tipe;
  String? keterangan;
  int? jumlah_uang;
  String? tanggal;

  ModelDatabase(
      {this.id, this.tipe, this.keterangan, this.jumlah_uang, this.tanggal});

  factory ModelDatabase.fromJson(Map<String, dynamic> json) {
    return ModelDatabase(
      id: json['id'],
      tipe: json['tipe'],
      keterangan: json['keterangan'],
      jumlah_uang: json['jumlah_uang'],
      tanggal: json['tanggal'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'tipe': tipe,
      'keterangan': keterangan,
      'jumlah_uang': jumlah_uang,
      'tanggal': tanggal,
    };
  }
}
