class Statistik {
  final int jlhPelayanan;
  final int pendapatan;

  const Statistik({
    required this.jlhPelayanan,
    required this.pendapatan,
  });

  factory Statistik.fromJson(Map<String, dynamic> json) {
    return Statistik(
      jlhPelayanan: json["jlhPelayanan"],
      pendapatan: json["pendapatan"],
    );
  }
}
