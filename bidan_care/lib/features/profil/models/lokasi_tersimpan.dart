class LokasiTersimpan {
  final String id;
  final String nama;
  final double latitude;
  final double longitude;

  const LokasiTersimpan({
    required this.id,
    required this.nama,
    required this.latitude,
    required this.longitude,
  });
}

const List<LokasiTersimpan> dummyLokasiTersimpan = [
  LokasiTersimpan(
    id: "1",
    nama: "Contoh Lokasi 1",
    latitude: 5.207804988337941,
    longitude: 97.06890975745719,
  ),
  LokasiTersimpan(
    id: "2",
    nama: "Contoh Lokasi 2",
    latitude: 5.207804988337941,
    longitude: 97.06890975745719,
  ),
  LokasiTersimpan(
    id: "3",
    nama: "Contoh Lokasi 3",
    latitude: 5.207804988337941,
    longitude: 97.06890975745719,
  ),
  LokasiTersimpan(
    id: "4",
    nama: "Contoh Lokasi 4",
    latitude: 5.207804988337941,
    longitude: 97.06890975745719,
  ),
];
