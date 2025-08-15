import 'package:bidan_care/shared/models/daerah.dart';
import 'package:bidan_care/shared/services/daerah_service.dart';
import 'package:bidan_care/shared/widgets/app_drop_down.dart';
import 'package:flutter/material.dart';

class DaerahForm extends StatefulWidget {
  const DaerahForm({
    super.key,
    this.initProvinsi,
    this.initKecamatan,
    this.onProvinsiChanged,
    this.daerahService,
    required this.onKecamatanChanged,
  });

  final String? initProvinsi;
  final String? initKecamatan;
  final Function(String idProvinsi)? onProvinsiChanged;
  final Function(String idKecamatan) onKecamatanChanged;
  final DaerahService? daerahService;

  @override
  State<DaerahForm> createState() => _DaerahFormState();
}

class _DaerahFormState extends State<DaerahForm> {
  String? _idProvinsi;
  String? _idKecamatan;
  late DaerahService _service;
  late Future<List<Daerah>?> _provinsiFuture;
  Future<List<Daerah>?>? _kecamatanFuture;

  @override
  void initState() {
    super.initState();
    _service = widget.daerahService ?? DaerahService();
    _provinsiFuture = _service.getProvinsi();
  }

  @override
  Widget build(BuildContext context) {
    return _DaerahFutureBuilder(
      future: _provinsiFuture,
      builder: (data) {
        final List<Daerah> listProvinsi = data!;
        _idProvinsi ??= widget.initProvinsi ?? listProvinsi[0].id;
        (widget.onProvinsiChanged ?? (String idProvinsi) {})(_idProvinsi!);
        _kecamatanFuture ??= _service.getKecamatan(_idProvinsi!);

        return Column(
          children: [
            AppDropDown(
              initialValue: _idProvinsi!,
              label: "Provinsi:",
              items: listProvinsi.map((provinsi) {
                return DropdownMenuItem(
                  value: provinsi.id,
                  child: Text(provinsi.nama),
                );
              }).toList(),
              onChanged: (idProvinsi) async {
                _kecamatanFuture = _service.getKecamatan(idProvinsi!);
                await _kecamatanFuture;
                setState(() => _idProvinsi = idProvinsi);
              },
            ),
            _DaerahFutureBuilder(
              future: _kecamatanFuture!,
              builder: (data) {
                final listKecamatan = data!;
                final listIdKecamatan = listKecamatan.map((e) => e.id).toList();

                _idKecamatan = widget.initKecamatan ?? listKecamatan[0].id;
                if (!listIdKecamatan.contains(_idKecamatan!)) {
                  _idKecamatan = listKecamatan[0].id;
                }
                widget.onKecamatanChanged(_idKecamatan!);

                return AppDropDown(
                  initialValue: _idKecamatan!,
                  label: "Kota / Kabupaten:",
                  items: listKecamatan.map((kecamatan) {
                    return DropdownMenuItem(
                      value: kecamatan.id,
                      child: Text(kecamatan.nama),
                    );
                  }).toList(),
                  onChanged: (idKecamatan) {
                    widget.onKecamatanChanged(idKecamatan!);
                  },
                );
              },
            ),
          ],
        );
      },
    );
  }
}

class _DaerahFutureBuilder<T> extends StatelessWidget {
  const _DaerahFutureBuilder({
    required this.future,
    required this.builder,
  });

  final Future<T> future;
  final Widget Function(T data) builder;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
            height: 30,
            width: 30,
            margin: const EdgeInsets.all(12),
            child: const CircularProgressIndicator(),
          );
        }
        if (!snapshot.hasData) {
          return const Text("Terjadi kesalahan, silahkan coba lagi");
        }
        return builder(snapshot.data as T);
      },
    );
  }
}
