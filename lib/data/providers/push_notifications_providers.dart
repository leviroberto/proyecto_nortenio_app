import 'dart:async';
import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PushNotificatiosProviders {
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  final _mensajesStreamController = StreamController<String>.broadcast();

  Stream<String> get mensaje => _mensajesStreamController.stream;

  _agregarTokenCliente(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("token_usuario", token);
  }

  initNotifications() {
    _firebaseMessaging.requestNotificationPermissions();
    _firebaseMessaging.getToken().then((token) {
      print("=== FCM Token ====");
      _agregarTokenCliente(token);
      print(token);
    });

    _firebaseMessaging.configure(
      onMessage: (info) {
        print("====onMessage===");
        print(info);

        dynamic argumentos = '';
        dynamic data = '';
        dynamic title = '';
        dynamic body = '';
        if (Platform.isAndroid) {
          argumentos = info['notification'];
          data = info['data'];
          title = argumentos['title'];
          body = argumentos['body'];
        }

        _mensajesStreamController.sink.add(data);
        return;
      },
      onLaunch: (info) {
        print('====onLaunch===');
        print(info);
        return;
      },
      onResume: (info) {
        print("====onResume===");
        print(info);

        dynamic argumentos = info['data'];

        /*      final noti = info['data']['Bebidas']; */
        _mensajesStreamController.sink.add(argumentos);
        return;
      },
    );
  }

  dispose() {
    _mensajesStreamController?.close();
  }
}
