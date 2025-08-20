
class Ibu {
  String email;
  String password;
  String noTelp;
  String namaIbu;
  int usia;
  String provinsi;
  String kota;
  String kecamatan;
  String kelurahan;
  String rt; // Menggunakan String untuk RT karena bisa ada "001", "01A", dll.
  String rw; // Menggunakan String untuk RW karena bisa ada "001", "01B", dll.
  String alamat;


  Ibu({
    required this.email,
    required this.password,
    required this.noTelp,
    required this.namaIbu,
    required this.usia,
    required this.provinsi,
    required this.kota,
    required this.kecamatan,
    required this.kelurahan,
    required this.rt,
    required this.rw,
    required this.alamat,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
      'noTelp': noTelp,
      'nama': namaIbu,
      'usia': usia,
      'provinsi': provinsi,
      'kota': kota,
      'kecamatan': kecamatan,
      'kelurahan': kelurahan,
      'rt': rt,
      'rw': rw,
      'alamat': alamat,
    };
  }

  factory Ibu.fromJson(Map<String, dynamic> json) {
    return Ibu(
      email: json['email'] as String,
      password: json['password'] as String,
      noTelp : json['noTelp'] as String,
      namaIbu: json['nama'] as String,
      usia: json['usia'] as int,
      provinsi: json['provinsi'] as String,
      kota: json['kota'] as String,
      kecamatan: json['kecamatan'] as String,
      kelurahan: json['kelurahan'] as String,
      rt: json['rt'] as String,
      rw: json['rw'] as String,
      alamat: json['alamat'] as String
    );
  }
}