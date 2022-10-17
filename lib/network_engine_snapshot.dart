import 'package:scramjet/schema.dart';

class VaidyutiNetworkEngineSnapshot {
  final ProsumerInputStates prosumerInputStates;

  VaidyutiNetworkEngineSnapshot(this.prosumerInputStates);

  late ProsumerInputStates sellers = Map.fromEntries([
    for (final entry in prosumerInputStates.entries)
      if (entry.value.isExporter) entry,
  ]);

  late ProsumerInputStates buyers = Map.fromEntries([
    for (final entry in prosumerInputStates.entries)
      if (entry.value.isImporter) entry,
  ]).map(
    (prosumerId, state) => MapEntry(
      prosumerId,
      ProsumerInputData(
        state.exportPower,
        state.isExternal ? state.baseTradePrice : energyMarketPrice,
        state.isExternal,
      ),
    ),
  );

  late ProsumerInputStates internalSellers = Map.fromEntries([
    for (final entry in sellers.entries)
      if (!entry.value.isExternal) entry,
  ]);

  late ProsumerInputStates internalBuyers = Map.fromEntries([
    for (final entry in buyers.entries)
      if (!entry.value.isExternal) entry,
  ]);

  late num networkGeneration =
      sellers.values.fold(0.0, (pg, state) => pg + state.exportPower);

  late num networkDemand =
      buyers.values.fold(0.0, (pd, state) => pd - state.exportPower);

  late num networkInternalGeneration =
      internalSellers.values.fold(0.0, (pg, state) => pg + state.exportPower);

  late num networkInternalDemand =
      internalBuyers.values.fold(0.0, (pd, state) => pd - state.exportPower);

  late num selfGenerationFactor = networkInternalGeneration / networkGeneration;

  late num selfDemandFactor = networkInternalDemand / networkDemand;

  late num energyMarketPrice =
      sellers.values.fold(0.0, (p, v) => p + v.exportPower * v.baseTradePrice) /
          networkGeneration;

  late num sellersMarketPrice = internalSellers.values
          .fold(0.0, (p, v) => p + v.exportPower * v.baseTradePrice) /
      networkInternalGeneration;

  late ProsumerOutputStates sellerOutputStates = sellers.map(
    (key, value) => MapEntry(
      key,
      ProsumerOutputData(
        value.isExternal ? value.baseTradePrice : sellersMarketPrice,
        value.exportPower,
        value.baseTradePrice,
        value.isExternal,
      ),
    ),
  );

  late num networkCashInflow =
      sellerOutputStates.values.fold(0.0, (ci, state) => ci + state.cashInflow);

  late VaidyutiNetworkState networkState = VaidyutiNetworkState(
    networkGeneration,
    selfGenerationFactor,
    energyMarketPrice,
    sellersMarketPrice,
  );
}
