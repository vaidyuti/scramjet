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

  client.subscribe('prosumer/+/data', MqttQos.atMostOnce);

  client.updates.listen((event) {
    event.forEach((message) {
      final topic = message.topic!;
      final payload = MqttUtilities.bytesToStringAsString(
          (message.payload as MqttPublishMessage).payload.message!);

      final prosumerId = topic.split('/')[1];
      final prosumerData = ProsumerInputData.fromJson(jsonDecode(payload));

      final state = scramjet.addEvent(prosumerId, prosumerData);
      print(state.toJson());
    });
  });
}
