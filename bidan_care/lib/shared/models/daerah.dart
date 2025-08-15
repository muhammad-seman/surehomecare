class Daerah {
  final String id;
  final String nama;

  Daerah({
    required this.id,
    required this.nama,
  });

  factory Daerah.fromJson(Map<String, dynamic> json) {
    return Daerah(
      id: json["id"],
      nama: json["nama"],
    );
  }
}
