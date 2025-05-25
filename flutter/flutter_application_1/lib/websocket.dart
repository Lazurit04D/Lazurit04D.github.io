import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

void main()
{
  runApp
  (
    MaterialApp
    (
      key: ValueKey('MaterialApp'),
      home: WebSocketHomePage(),
    ),
  );
}

class WebSocketHomePage extends StatefulWidget
{
  const WebSocketHomePage({super.key});

  @override
  WebSocketHomePageState createState() => WebSocketHomePageState();
}

class WebSocketHomePageState extends State<WebSocketHomePage>
{
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();
  final List<String> _messages = [];
  
  late WebSocketChannel _channel; 

  @override
  void initState()
  {
    super.initState();
    _channel = WebSocketChannel.connect(Uri.parse('wss://echo.websocket.org'));

    _channel.stream.listen
    (
      (message)
      {
        setState(()
        {
          _messages.add(message);
        });
      },
      onDone: ()
      {
        debugPrint('Соединение закрыто');
      },
      onError: (error)
      {
        debugPrint('Ошибка: $error');
      },
    );
  }

  void _sendMessage()
  {
    if (_messageController.text.isNotEmpty)
    {
      final String username = _usernameController.text.isNotEmpty
          ? _usernameController.text
          : 'NoName';
      _channel.sink.add('$username: ${_messageController.text}');
      _messageController.clear();
    }
  }

  @override
  void dispose()
  {
    _channel.sink.close();
    _usernameController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context)
  {
    return Scaffold
    (
      appBar: AppBar
      (
        title: const Text('WebSocket'),
      ),
      body: Padding
      (
        padding: const EdgeInsets.all(16.0),
        child: Column
        (
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>
          [
            Text('Кол-во сообщений: ${_messages.length}'),
            const SizedBox(height: 16),
            const Text('Введите имя:'),
            TextField
            (
              controller: _usernameController,
              decoration: const InputDecoration
              (
                hintText: 'Имя',
              ),
            ),
            const SizedBox(height: 16),
            const Text('Введите сообщение:'),
            TextField
            (
              controller: _messageController,
              decoration: const InputDecoration
              (
                hintText: 'Сообщение',
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton
            (
              onPressed: _sendMessage,
              child: const Text('Отправить'),
            ),
            const SizedBox(height: 16),
            Expanded
            (
              child: ListView.builder
              (
                itemCount: _messages.length,
                itemBuilder: (context, index)
                {
                  return Text(_messages[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}