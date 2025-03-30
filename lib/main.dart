import 'package:controll_me_daddy/components/websocket_endpoint_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

void main() {
  runApp(const ControllMeDaddy());
}

class ControllMeDaddy extends StatelessWidget {
  const ControllMeDaddy({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const ControllMeDaddyState(),
    );
  }
}

class ControllMeDaddyState extends StatefulWidget {
  const ControllMeDaddyState({super.key});

  @override
  State<ControllMeDaddyState> createState() => _ControllMeDaddyState();
}

class _ControllMeDaddyState extends State<ControllMeDaddyState> {
  final urlController = TextEditingController();

  @override
  void dispose() {
    urlController.dispose();
    _channel.sink.close();
    super.dispose();
  }

  late WebSocketChannel _channel;

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [WebsocketEndpointForm()],
        ),
      ),
    );
  }
}
