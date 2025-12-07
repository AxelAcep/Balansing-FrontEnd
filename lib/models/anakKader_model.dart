class AnakKader {
  String? email; // Tambahkan properti email
  DateTime? tanggalPemeriksaan;
  String? namaIbu;
  String? namaAnak;
  int? umurTahun;
  int? umurBulan;
  double? beratBadan;
  double? tinggiBadan;
  String? jenisKelamin;
  String? id;

  bool? konjungtivitaNormal;
  bool? kukuBersih;
  bool? tampakLemas;
  bool? tampakPucat;
  bool? riwayatAnemia;

  double? bbLahir; // Berat Badan Saat Lahir
  double? tbLahir; // Tinggi Badan Saat Lahir

  AnakKader({
    this.email, // Inisialisasi email
    this.tanggalPemeriksaan,
    this.namaIbu,
    this.namaAnak,
    this.umurTahun,
    this.umurBulan,
    this.beratBadan,
    this.tinggiBadan,
    this.jenisKelamin,
    this.konjungtivitaNormal,
    this.kukuBersih,
    this.tampakLemas,
    this.tampakPucat,
    this.riwayatAnemia,
    this.id,
    this.bbLahir,
    this.tbLahir,
  });

  void reset() {
    email = null; // Reset email
    tanggalPemeriksaan = null;
    namaIbu = null;
    namaAnak = null;
    umurTahun = null;
    umurBulan = null;
    beratBadan = null;
    tinggiBadan = null;
    jenisKelamin = null;
    konjungtivitaNormal = null;
    kukuBersih = null;
    tampakLemas = null;
    tampakPucat = null;
    riwayatAnemia = null;
    bbLahir = null;
    tbLahir = null;
    id = null; // Reset id
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email, // Sertakan email dalam JSON
      'tanggalPemeriksaan': tanggalPemeriksaan?.toIso8601String(),
      'namaIbu': namaIbu,
      'namaAnak': namaAnak,
      'umurTahun': umurTahun,
      'umurBulan': umurBulan,
      'beratBadan': beratBadan,
      'tinggiBadan': tinggiBadan,
      'jenisKelamin': jenisKelamin,
      'konjungtivitaNormal': konjungtivitaNormal,
      'kukuBersih': kukuBersih,
      'tampakLemas': tampakLemas,
      'tampakPucat': tampakPucat,
      'riwayatAnemia': riwayatAnemia,
      'id': id, // Sertakan id dalam JSON
      'bbLahir': bbLahir,
      'tbLahir': tbLahir,
    };
  }

  factory AnakKader.fromJson(Map<String, dynamic> json) {
    return AnakKader(
      email: json['email'], // Ambil email dari JSON
      tanggalPemeriksaan: json['tanggalPemeriksaan'] != null
          ? DateTime.parse(json['tanggalPemeriksaan'])
          : null,
      namaIbu: json['namaIbu'],
      namaAnak: json['namaAnak'],
      umurTahun: json['umurTahun'],
      umurBulan: json['umurBulan'],
      beratBadan: json['beratBadan']?.toDouble(),
      tinggiBadan: json['tinggiBadan']?.toDouble(),
      jenisKelamin: json['jenisKelamin'],
      konjungtivitaNormal: json['konjungtivitaNormal'],
      kukuBersih: json['kukuBersih'],
      tampakLemas: json['tampakLemas'],
      tampakPucat: json['tampakPucat'],
      riwayatAnemia: json['riwayatAnemia'],
      id: json['id'], // Ambil id dari JSON
      bbLahir: json['bbLahir']?.toDouble(),
      tbLahir: json['tbLahir']?.toDouble(),
    );
  }

  DateTime? get tanggalLahir => null;

  set tanggalLahir(DateTime? tanggalLahir) {}
}

class AnakKaderDataManager {
  static final AnakKaderDataManager _instance = AnakKaderDataManager._internal();

  factory AnakKaderDataManager() {
    return _instance;
  }

  AnakKaderDataManager._internal();

  AnakKader currentAnakKader = AnakKader();

  void clearData() {
    currentAnakKader = AnakKader();
  }

  AnakKader getData() {
    return currentAnakKader;
  }
}