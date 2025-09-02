class DashboardData {
    final String nama;
    final String tanggalPeriksaTerakhir;
    final double bb;
    final double tb;
    final int umur;
    final String statusStunting;
    final bool statusAnemia;
    final double zScore;
    final double? bbSebelumnya;
    final double? tbSebelumnya;
    final String rataRataBB12Bulan;
    final String rataRataTB12Bulan;
    final List<dynamic> dataBB12Bulan;
    final List<dynamic> dataTB12Bulan;

    DashboardData({
        required this.nama,
        required this.tanggalPeriksaTerakhir,
        required this.bb,
        required this.tb,
        required this.umur,
        required this.statusStunting,
        required this.statusAnemia,
        required this.zScore,
        this.bbSebelumnya,
        this.tbSebelumnya,
        required this.rataRataBB12Bulan,
        required this.rataRataTB12Bulan,
        required this.dataBB12Bulan,
        required this.dataTB12Bulan,
    });

    factory DashboardData.fromJson(Map<String, dynamic> json) {
        return DashboardData(
            nama: json['nama'],
            tanggalPeriksaTerakhir: json['tanggalPeriksaTerakhir'],
            bb: json['bb'].toDouble(),
            tb: json['tb'].toDouble(),
            umur: json['umur'],
            statusStunting: json['statusStunting'],
            statusAnemia: json['statusAnemia'],
            zScore: json['zScore'].toDouble(),
            bbSebelumnya: json['bbSebelumnya']?.toDouble(),
            tbSebelumnya: json['tbSebelumnya']?.toDouble(),
            rataRataBB12Bulan: json['rataRataBB12Bulan'],
            rataRataTB12Bulan: json['rataRataTB12Bulan'],
            dataBB12Bulan: json['data12BulanTerakhir']['bb'],
            dataTB12Bulan: json['data12BulanTerakhir']['tb'],
        );
    }
}