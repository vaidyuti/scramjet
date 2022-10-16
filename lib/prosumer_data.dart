import 'dart:convert';

import 'package:meta/meta.dart';

@immutable
class ProsumerData {
  final num exportPower;
  final num baseSellingPrice;

  const ProsumerData({
    required this.exportPower,
    required this.baseSellingPrice,
  });

  factory ProsumerData.fromJson(String source) {
    final json = jsonDecode(source);

    final exportPower = json['export_power'];
    final baseSellingPrice =
        exportPower >= 0.0 ? json['base_selling_price'] : 0.0;

    return ProsumerData(
      exportPower: exportPower,
      baseSellingPrice: baseSellingPrice,
    );
  }
}
