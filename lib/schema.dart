import 'package:json_annotation/json_annotation.dart';

part 'schema.g.dart';

typedef ProsumerStates = Map<String, ProsumerInputData>;

@JsonSerializable(fieldRename: FieldRename.snake)
class ProsumerInputData {
  final num exportPower;
  final num baseSellingPrice;
  final String category;
  final bool isExternal;

  const ProsumerInputData(
    this.exportPower,
    this.baseSellingPrice,
    this.category,
    this.isExternal,
  );

  factory ProsumerInputData.fromJson(Map<String, dynamic> json) =>
      _$ProsumerInputDataFromJson(json);

  Map<String, dynamic> toJson() => _$ProsumerInputDataToJson(this);

  bool get isExporter => exportPower >= 0.0;
  bool get isImporter => exportPower <= 0.0;
}

@JsonSerializable(fieldRename: FieldRename.snake)
class ProsumerOutputData extends ProsumerInputData {
  final num tradePrice;

  const ProsumerOutputData(
    this.tradePrice,
    num exportPower,
    num baseSellingPrice,
    String category,
    bool isExternal,
  ) : super(exportPower, baseSellingPrice, category, isExternal);

  factory ProsumerOutputData.fromJson(Map<String, dynamic> json) =>
      _$ProsumerOutputDataFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$ProsumerOutputDataToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class VaidyutiNetworkState {
  final num networkGeneration;
  final num selfGenerationFactor;
  final num energyMarketPrice;
  final num sellersMarketPrice;

  const VaidyutiNetworkState(
    this.networkGeneration,
    this.selfGenerationFactor,
    this.energyMarketPrice,
    this.sellersMarketPrice,
  );

  factory VaidyutiNetworkState.fromJson(Map<String, dynamic> json) =>
      _$VaidyutiNetworkStateFromJson(json);

  Map<String, dynamic> toJson() => _$VaidyutiNetworkStateToJson(this);
}
