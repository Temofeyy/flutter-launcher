import 'package:flutter/services.dart';

abstract class FlutterAndroidBridge{
  static const _key = 'change.mode.event';

  static Future<void> sendData() async {
    final MethodChannel _channel = MethodChannel(_key);
    try {
      await _channel.invokeMethod('unlock');
    } catch (e) {
      print('Error sending data: $e');
    }
  }
}