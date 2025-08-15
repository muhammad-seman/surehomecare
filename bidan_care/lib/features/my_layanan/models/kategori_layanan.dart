class KategoriLayanan {
  final String id;
  final String nama;

  const KategoriLayanan({
    required this.id,
    required this.nama,
  });

  factory KategoriLayanan.fromJson(Map<String, dynamic> json) {
    return KategoriLayanan(
      id: json["id"],
      nama: json["nama"],
    );
  }
}
