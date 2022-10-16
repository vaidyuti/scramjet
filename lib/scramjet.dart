import 'package:scramjet/prosumer_data.dart';

final Map<String, ProsumerData> prosumerStates = Map.from({});

void addEvent(String prosumerId, ProsumerData data) {
  prosumerStates.update(
    prosumerId,
    (value) => data,
    ifAbsent: () {
      // print("New prosumer '$prosumerId' detected.");
      return data;
    },
  );

  // TODO: re-evaluate market price with new prosumer states
}
