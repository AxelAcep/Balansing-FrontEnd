// lib/models/recap_anak_model.dart

import 'package:balansing/card/RiwayatIbuCard.dart'; // Import StuntingStatus

class RecapAnak {
  final String namaAnak;
  final String tanggalLahir;
  final String jenisKelamin;
  final double beratBadan;
  final double tinggiBadan;
  final String statusStunting;
  final bool isAnemia;
  final int childNumber;
  final String id;
  final String anakId;

  RecapAnak({
    required this.namaAnak,
    required this.tanggalLahir,
    required this.jenisKelamin,
    required this.beratBadan,
    required this.tinggiBadan,
    required this.statusStunting,
    required this.isAnemia,
    required this.childNumber,
    required this.id,
    required this.anakId,
  });

  factory RecapAnak.fromJson(Map<String, dynamic> json, int index) {
    return RecapAnak(
      namaAnak: json['namaAnak'] as String,
      tanggalLahir: json['tanggalLahir'] as String,
      jenisKelamin: json['jenisKelamin'] as String,
      beratBadan: json['beratBadan']?.toDouble() ?? 0.0,
      tinggiBadan: json['tinggiBadan']?.toDouble() ?? 0.0,
      statusStunting: json['statusStunting'] as String,
      isAnemia: json['isAnemia'] as bool,
      id : json ['kodeRecap'] as String,
      childNumber: index + 1,
      anakId: json ['id'],
    );
  }
}

// Tambahkan ekstensi untuk mengonversi RecapAnak ke ChildData
extension RecapAnakExtension on RecapAnak {
  ChildData toChildData() {

    return ChildData(
      name: namaAnak,
      age: tanggalLahir, // Anda mungkin perlu mengolah ini
      gender: jenisKelamin,
      weight: beratBadan,
      height: tinggiBadan,
      stuntingStatus: statusStunting,
      hasAnemia: isAnemia,
      childNumber: childNumber,
      id : id,
      anakId: anakId,
    );
  }
}