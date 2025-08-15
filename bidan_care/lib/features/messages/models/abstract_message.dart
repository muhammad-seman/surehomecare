class AbstractMessage {
  final String isi;
  final bool isPengirim;

  const AbstractMessage({
    required this.isi,
    this.isPengirim = true,
  });
}
