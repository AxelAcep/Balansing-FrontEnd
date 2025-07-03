
class Kader {
  String email;
  String password;
  String namaPuskesmas;
  String namaPosyandu;
  String provinsi;
  String kota;
  String kecamatan;
  String kelurahan;
  String rt; // Menggunakan String untuk RT karena bisa ada "001", "01A", dll.
  String rw; // Menggunakan String untuk RW karena bisa ada "001", "01B", dll.


  Kader({
    required this.email,
    required this.password,
    required this.namaPuskesmas,
    required this.namaPosyandu,
    required this.provinsi,
    required this.kota,
    required this.kecamatan,
    required this.kelurahan,
    required this.rt,
    required this.rw,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
      'namaPuskesmas': namaPuskesmas,
      'namaPosyandu' : namaPosyandu,
      'provinsi': provinsi,
      'kota': kota,
      'kecamatan': kecamatan,
      'kelurahan': kelurahan,
      'rt': rt,
      'rw': rw,
    };
  }

  factory Kader.fromJson(Map<String, dynamic> json) {
    return Kader(
      email: json['email'] as String,
      password: json['password'] as String,
      namaPuskesmas: json['namaPuskesmas'] as String,
      provinsi: json['provinsi'] as String,
      kota: json['kota'] as String,
      namaPosyandu: json['namaPosyandu'] as String,
      kecamatan: json['kecamatan'] as String,
      kelurahan: json['kelurahan'] as String,
      rt: json['rt'] as String,
      rw: json['rw'] as String,
    );
  }
}