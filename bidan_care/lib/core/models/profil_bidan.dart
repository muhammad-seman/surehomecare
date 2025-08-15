class ProfilBidan {
  final String keterangan;
  final bool bersedia;

  const ProfilBidan({
    required this.keterangan,
    required this.bersedia,
  });

  factory ProfilBidan.fromJson(Map<String, dynamic> json) {
    return ProfilBidan(
      keterangan: json["keterangan"],
      bersedia: json["bersedia"],
    );
  }
}
