import 'package:scramjet/schema.dart';

class VaidyutiNetworkEngineSnapshot {
  final ProsumerInputStates inputStates;

  VaidyutiNetworkEngineSnapshot(this.inputStates);

  late ProsumerInputStates sellers = Map.fromEntries([
    for (final entry in inputStates.entries)
      if (entry.value.isExporter) entry,
  ]);
  late ProsumerInputStates buyers = Map.fromEntries([
    for (final entry in inputStates.entries)
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
    (prosumerId, state) => MapEntry(
      prosumerId,
      ProsumerOutputData(
        state.isExternal ? state.baseTradePrice : sellersMarketPrice,
        state.exportPower,
        state.baseTradePrice,
        state.isExternal,
      ),
    ),
  );

  late num networkCashInflow =
      sellerOutputStates.values.fold(0.0, (ci, state) => ci + state.cashInflow);

  late num networkBaseCashOutflow =
      buyers.values.fold(0.0, (co, state) => co - state.baseCashInflow);

  late num networkBaseCashLoss = networkCashInflow - networkBaseCashOutflow;

  num evaluateBuyerTradePrice(ProsumerInputData state) {
    if (state.exportPower == 0.0) return 0.0;
    if (state.isExternal) return state.baseCashInflow / state.exportPower;
    final cashLossCompensation =
        networkBaseCashLoss * state.exportPower / networkInternalDemand;
    return (state.baseCashInflow + cashLossCompensation) / state.exportPower;
  }

  late ProsumerOutputStates buyerOutputStates = buyers.map(
    (prosumerId, state) => MapEntry(
      prosumerId,
      ProsumerOutputData(
        evaluateBuyerTradePrice(state),
        state.exportPower,
        state.baseTradePrice,
        state.isExternal,
      ),
    ),
  );

  late num networkCashOutflow =
      buyerOutputStates.values.fold(0.0, (co, state) => co - state.cashInflow);

  late ProsumerOutputStates outputStates = {
    ...sellerOutputStates,
    ...buyerOutputStates,
  };

  late VaidyutiNetworkState networkState = VaidyutiNetworkState(
    networkGeneration,
    selfGenerationFactor,
    energyMarketPrice,
    sellersMarketPrice,
  );
}
