// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'schema.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProsumerInputData _$ProsumerInputDataFromJson(Map<String, dynamic> json) =>
    ProsumerInputData(
      json['export_power'] as num,
      json['base_selling_price'] as num,
      json['is_external'] as bool,
    );

Map<String, dynamic> _$ProsumerInputDataToJson(ProsumerInputData instance) =>
    <String, dynamic>{
      'export_power': instance.exportPower,
      'base_selling_price': instance.baseSellingPrice,
      'is_external': instance.isExternal,
    };

ProsumerOutputData _$ProsumerOutputDataFromJson(Map<String, dynamic> json) =>
    ProsumerOutputData(
      json['trade_price'] as num,
      json['export_power'] as num,
      json['base_selling_price'] as num,
      json['is_external'] as bool,
    );

Map<String, dynamic> _$ProsumerOutputDataToJson(ProsumerOutputData instance) =>
    <String, dynamic>{
      'export_power': instance.exportPower,
      'base_selling_price': instance.baseSellingPrice,
      'is_external': instance.isExternal,
      'trade_price': instance.tradePrice,
    };

VaidyutiNetworkState _$VaidyutiNetworkStateFromJson(
        Map<String, dynamic> json) =>
    VaidyutiNetworkState(
      json['network_generation'] as num,
      json['self_generation_factor'] as num,
      json['energy_market_price'] as num,
      json['sellers_market_price'] as num,
    );

Map<String, dynamic> _$VaidyutiNetworkStateToJson(
        VaidyutiNetworkState instance) =>
    <String, dynamic>{
      'network_generation': instance.networkGeneration,
      'self_generation_factor': instance.selfGenerationFactor,
      'energy_market_price': instance.energyMarketPrice,
      'sellers_market_price': instance.sellersMarketPrice,
    };
