import 'package:json_annotation/json_annotation.dart';

part 'schema.g.dart';

typedef ProsumerInputStates = Map<String, ProsumerInputData>;
typedef ProsumerOutputStates = Map<String, ProsumerOutputData>;

@JsonSerializable(fieldRename: FieldRename.snake)
class ProsumerInputData {
  final num exportPower;
  final num baseTradePrice;
  final bool isExternal;

  const ProsumerInputData(
    this.exportPower,
    this.baseTradePrice,
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
    num baseTradePrice,
    bool isExternal,
  ) : super(exportPower, baseTradePrice, isExternal);

  factory ProsumerOutputData.fromJson(Map<String, dynamic> json) =>
      _$ProsumerOutputDataFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$ProsumerOutputDataToJson(this);

  num get cashInflow => tradePrice * exportPower;
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
