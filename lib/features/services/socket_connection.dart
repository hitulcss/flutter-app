import "package:socket_io_client/socket_io_client.dart" as io;

class SocketConnetion {
  static late io.Socket connection;

  static void initialize(String serverUrl) {
    connection = io.io(serverUrl, <String, dynamic>{
      'transports': [
        'websocket'
      ],
      'autoConnect': false,
    });
  }

  static Future<void> connect({required String url}) async {
    initialize(
      url,
      // "https://twoway-backend-prod.sdcampus.com/mediasoup",
      // "http://192.168.1.100:3000/mediasoup",
      // 'https://two-way.sdcampus.com/mediasoup',
      // 'https://s34b5jj9-3001.inc1.devtunnels.ms/mediasoup',
      // "https://s34b5jj9-3003.inc1.devtunnels.ms/mediasoup",
      // "https://jnp38464-4000.inc1.devtunnels.ms/mediasoup",
    );
    connection.connect();
  }

  static void disconnect() {
    connection.disconnect();
  }

  static void reConnect() {
    connection.connect();
  }
}
