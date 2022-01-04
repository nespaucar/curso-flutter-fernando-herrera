import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

enum ServerStatus {
  Online,
  Offline,
  Connecting
}

class SocketService with ChangeNotifier {
  ServerStatus _serverStatus = ServerStatus.Connecting;
  final IO.Socket _socket = IO.io('http://192.168.1.11:3000', {
    'transports': ['websocket'],
    'autoConnect': true
  });

  ServerStatus get serverStatus => this._serverStatus;
  IO.Socket get socket => this._socket;

  SocketService() {
    this._initConfig();
  }

  void _initConfig() {
    // Dart Client
    _socket.on('connect', ( _ ) {
      debugPrint('connected');
      this._serverStatus = ServerStatus.Online;
      notifyListeners();
    });
    this._socket.on('disconnect', ( _ ) {
      debugPrint('disconnect');
      this._serverStatus = ServerStatus.Offline;
      notifyListeners();
    });
    this._socket.on('emitir-mensaje', ( payload ) {
      // print('disconnect');
      debugPrint('emitir-mensaje: $payload');
    });
  }
}