import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/io.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WebSocket Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const WebSocketDemo(),
    );
  }
}

class WebSocketDemo extends StatefulWidget {
  const WebSocketDemo({super.key});

  @override
  _WebSocketDemoState createState() => _WebSocketDemoState();
}

class _WebSocketDemoState extends State<WebSocketDemo> {
  late WebSocketChannel _channel;
  String _message = '';

  @override
  void initState() {
    super.initState();
    // Connect to the WebSocket server
    _channel = IOWebSocketChannel.connect(
      'ws://21e0-102-217-76-205.ngrok-free.app',
    );
  }

  @override
  void dispose() {
    // Close the WebSocket connection when the widget is disposed
    _channel.sink.close();
    super.dispose();
  }

  void _sendMessage() {
    // Send "hello world" to the WebSocket server
    _channel.sink.add('hello world');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('WebSocket Demo')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
              onPressed: _sendMessage,
              child: const Text('Send "hello world"'),
            ),
            const SizedBox(height: 20),
            StreamBuilder(
              stream: _channel.stream,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  // Display messages received from the WebSocket server
                  _message = snapshot.data.toString();
                } else if (snapshot.hasError) {
                  _message = 'Error: ${snapshot.error}';
                } else {
                  _message = 'No message received yet';
                }
                return Text(_message, style: const TextStyle(fontSize: 18));
              },
            ),
          ],
        ),
      ),
    );
  }
}
