import 'dart:convert';

import 'package:dotenv/dotenv.dart';
import 'package:mqtt5_client/mqtt5_client.dart';
import 'package:mqtt5_client/mqtt5_server_client.dart';
import 'package:scramjet/schema.dart';
import 'package:scramjet/scramjet.dart' as scramjet;

void main(List<String> arguments) async {
  final env = DotEnv(includePlatformEnvironment: true)..load();
  print(env['MQTT_SERVER']);

  final mqttServer = env['MQTT_SERVER'] ?? 'tcp://localhost';
  final client = MqttServerClient(mqttServer, '');

  await client.connect();
  print('Connected to MQTT Server');

  final Map<String, Map<String, dynamic>> partialProsumerStates = {};

  // client.subscribe('prosumer/+/data', MqttQos.atMostOnce);
  client.subscribe('prosumer/+/export_power', MqttQos.atMostOnce);
  client.subscribe('prosumer/+/base_trade_price', MqttQos.atMostOnce);
  client.subscribe('prosumer/+/is_external', MqttQos.atMostOnce);

  client.updates.listen((event) {
    event.forEach((message) {
      final topicParts = message.topic!.split('/');
      final prosumerId = topicParts[1];
      final fieldName = topicParts[2];
      final fieldPayload = jsonDecode(
        MqttUtilities.bytesToStringAsString(
          (message.payload as MqttPublishMessage).payload.message!,
        ),
      );

      final fieldValue = fieldPayload['value'];
      final fieldTimestamp = fieldPayload['timestamp'];

      final previousInputState = scramjet.getInputStateOf(prosumerId);

      if (previousInputState == null) {
        partialProsumerStates.update(
          prosumerId,
          (initialState) => {...initialState, fieldName: fieldValue},
          ifAbsent: () => {fieldName: fieldValue},
        );

        if (partialProsumerStates[prosumerId]!['export_power'] == null ||
            partialProsumerStates[prosumerId]!['base_trade_price'] == null ||
            partialProsumerStates[prosumerId]!['is_external'] == null) return;
      }

      final prosumerData = previousInputState == null
          ? ProsumerInputData.fromJson(
              partialProsumerStates.remove(prosumerId)!,
            )
          : ProsumerInputData.fromJson({
              ...previousInputState.toJson(),
              fieldName: fieldValue,
            });

      final state = scramjet.updateState(prosumerId, prosumerData);
      print(state.toJson());
    });
  });
}
