import 'package:scramjet/schema.dart';

class VaidyutiNetworkEngineSnapshot {
  final ProsumerStates prosumerStates;

  VaidyutiNetworkEngineSnapshot(this.prosumerStates);

  late ProsumerStates sellers = Map.fromEntries([
    for (final entry in prosumerStates.entries)
      if (entry.value.isExporter) entry,
  ]);

  late ProsumerStates internalSellers = Map.fromEntries([
    for (final entry in sellers.entries)
      if (!entry.value.isExternal) entry,
  ]);

  late ProsumerStates buyers = Map.fromEntries([
    for (final entry in prosumerStates.entries)
      if (entry.value.isImporter) entry,
  ]);

  late num networkGeneration =
      sellers.values.fold(0.0, (pg, state) => pg + state.exportPower);

  late num networkInternalGeneration =
      internalSellers.values.fold(0.0, (pg, state) => pg + state.exportPower);

  late num selfGenerationFactor = networkInternalGeneration / networkGeneration;

  late num energyMarketPrice = sellers.values
          .fold(0.0, (p, v) => p + v.exportPower * v.baseSellingPrice) /
      networkGeneration;

  late num sellersMarketPrice = internalSellers.values
          .fold(0.0, (p, v) => p + v.exportPower * v.baseSellingPrice) /
      networkInternalGeneration;

  late VaidyutiNetworkState networkState = VaidyutiNetworkState(
      networkGeneration,
      selfGenerationFactor,
      energyMarketPrice,
      sellersMarketPrice);
}
