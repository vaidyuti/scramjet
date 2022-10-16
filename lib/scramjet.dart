import 'package:scramjet/network_engine_snapshot.dart';
import 'package:scramjet/schema.dart';

final ProsumerStates states = Map.from({});

VaidyutiNetworkState addEvent(String prosumerId, ProsumerInputData data) {
  states.update(prosumerId, (value) => data, ifAbsent: () => data);
  return VaidyutiNetworkEngineSnapshot(states).networkState;
}
