import 'package:scramjet/network_engine_snapshot.dart';
import 'package:scramjet/schema.dart';

final ProsumerInputStates states = Map.from({});

VaidyutiNetworkEngineSnapshot updateState(
  String prosumerId,
  ProsumerInputData data,
) {
  states.addAll({prosumerId: data});
  return VaidyutiNetworkEngineSnapshot(states);
}

VaidyutiNetworkEngineSnapshot updateStates(ProsumerInputStates states) {
  states.addAll(states);
  return VaidyutiNetworkEngineSnapshot(states);
}

ProsumerInputData? getInputStateOf(String prosumerId) => states[prosumerId];
