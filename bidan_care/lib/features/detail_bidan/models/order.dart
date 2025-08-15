import 'dart:convert';

class Order {
  final String idBidan;
  final List<DetailOrder> detailOrder;

  const Order({
    required this.idBidan,
    required this.detailOrder,
  });

  String toJson() {
    return jsonEncode({
      "idBidan": idBidan,
      "detailOrder": detailOrder.map((e) => e.toMap()).toList(),
    });
  }
}

class DetailOrder {
  final String idLayanan;
  final String namaLayanan;
  final int jlhBayar;
  final String gambar;

  const DetailOrder({
    required this.idLayanan,
    required this.namaLayanan,
    required this.jlhBayar,
    required this.gambar,
  });

  Map<String, dynamic> toMap() {
    return {
      "idLayanan": idLayanan,
      "namaLayanan": namaLayanan,
      "jlhBayar": jlhBayar,
      "gambar": gambar,
    };
  }
}
