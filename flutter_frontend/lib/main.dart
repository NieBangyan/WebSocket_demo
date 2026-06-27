// main.dart
import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: WebSocketPage());
  }
}

class WebSocketPage extends StatefulWidget {
  @override
  _WebSocketPageState createState() => _WebSocketPageState();
}

class _WebSocketPageState extends State<WebSocketPage> {
  late WebSocketChannel channel;
  List<String> messages = [];
  TextEditingController controller = TextEditingController();
  bool isConnected = false;

  // connect
  void connect() {
    channel = WebSocketChannel.connect(
      Uri.parse('ws://127.0.0.1:8765'),
    );

    channel.stream.listen(
      (message) {
        setState(() {
          messages.add('recived: $message');
          isConnected = true;
        });
      },
      onDone: () {
        setState(() {
          isConnected = false;
          messages.add('Connection disconnected');
        });
      },
      onError: (error) {
        setState(() {
          messages.add('Error: $error');
        });
      },
    );

    setState(() {
      messages.add('Connected');
      isConnected = true;
    });
  }

  // send message
  void sendMessage() {
    final text = controller.text.trim();
    if (text.isEmpty) return;
    
    channel.sink.add(text);
    setState(() {
      messages.add('Sent: $text');
      controller.clear();
    });
  }

  // disconnect
  void disconnect() {
    channel.sink.close();
    setState(() {
      isConnected = false;
      messages.add('Connection disconnected');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('WebSocketTest'),
        backgroundColor: isConnected ? Colors.green : Colors.red,
        actions: [
          Icon(isConnected ? Icons.wifi : Icons.wifi_off),
          SizedBox(width: 16),
        ],
      ),
      body: Column(
        children: [
          // connect/disconnect buttons
          Padding(
            padding: EdgeInsets.all(16),
            child: Row(
              children: [
                ElevatedButton(
                  onPressed: isConnected ? null : connect,
                  child: Text('connect'),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: isConnected ? disconnect : null,
                  child: Text('disconnect'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                  ),
                ),
              ],
            ),
          ),
          
          // Message list
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(16),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final msg = messages[index];
                final isSend = msg.startsWith('Sent:');
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: 4),
                  child: Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isSend ? Colors.green[100] : Colors.blue[50],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(msg),
                  ),
                );
              },
            ),
          ),
          
          // Input field
          Container(
            padding: EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller,
                    decoration: InputDecoration(
                      hintText: isConnected ? 'Enter message...' : 'Please connect first',
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (_) => sendMessage(),
                  ),
                ),
                SizedBox(width: 10),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: isConnected ? sendMessage : null,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}