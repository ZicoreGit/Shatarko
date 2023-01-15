import 'dart:developer';
import 'dart:io';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

class MQTTClintManager {
  late MqttServerClient client;

  Future<int> connect(String username) async {
    client = MqttServerClient.withPort('180.92.224.170', username, 1883);
    client.logging(on: false);
    client.keepAlivePeriod = 60;
    client.onConnected = onConnected;
    client.onDisconnected = onDisconnected;
    // client.autoReconnect = true;

    // final connMessage =
    //     MqttConnectMessage().startClean().withWillQos(MqttQos.atMostOnce);
    // client.connectionMessage = connMessage;

    try {
      await client.connect('zicoremqtt', 'zicore12!!@@');
    } on NoConnectionException {
      client.disconnect();
    } on SocketException {
      client.disconnect();
    }

    return 0;
  }

  void onConnected() {
    log('Connected');
  }

  void onDisconnected() {
    log('Disconnected');
  }

  void publish(String username, String message) {
    final MqttClientPayloadBuilder builder = MqttClientPayloadBuilder();
    builder.addString(message);
    client.publishMessage('$username/shatarko', MqttQos.exactlyOnce, builder.payload!);
  }
}
