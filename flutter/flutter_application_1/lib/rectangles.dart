// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'dart:convert';

void main()
{
  runApp
  (
    MaterialApp
    (
      key: ValueKey('MaterialApp'),
      home: LoginScreen(),
    ),
  );
}

class LoginScreen extends StatefulWidget
{
  const LoginScreen({super.key});

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen>
{
  final TextEditingController _usernameController = TextEditingController();

  void _login()
  {
    if (_usernameController.text.isNotEmpty)
    {
      Navigator.push
      (
        context,
        MaterialPageRoute
        (
          builder: (context) => WebSocketGridPage
          (
            username: _usernameController.text,
          ),
        ),
      );
    }
  }

  @override
  void dispose()
  {
    _usernameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context)
  {
    return Scaffold
    (
      appBar: AppBar
      (
        title: const Text('Вход'),
      ),
      body: Padding
      (
        padding: const EdgeInsets.all(16.0),
        child: Column
        (
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>
          [
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
            ElevatedButton
            (
              onPressed: _login,
              child: const Text('Вход'),
            ),
          ],
        ),
      ),
    );
  }
}

class WebSocketGridPage extends StatefulWidget
{
  final String username;

  const WebSocketGridPage
  ({
    super.key,
    required this.username,
  });

  @override
  WebSocketGridPageState createState() => WebSocketGridPageState();
}

class WebSocketGridPageState extends State<WebSocketGridPage>
{
  late WebSocketChannel _channel;
  final List<Map<String, dynamic>> _boxes = List.generate
  (
    6,
    (index) =>
    {
      'id': index,
      'color': Colors.green.value,
      'lastClickedBy': '',
    },
  );

  @override
  void initState()
  {
    super.initState();
    _channel = WebSocketChannel.connect(Uri.parse('wss://echo.websocket.org'));

    _channel.stream.listen
    (
      (message)
      {
        try
        {
          final decodedMessage = jsonDecode(message);
          if (decodedMessage is Map &&
              decodedMessage.containsKey('id') &&
              decodedMessage.containsKey('color') &&
              decodedMessage.containsKey('lastClickedBy'))
              {
                setState(()
                {
                  final int clickedId = decodedMessage['id'];
                  final int clickedColor = decodedMessage['color'] as int;
                  final String clickedBy = decodedMessage['lastClickedBy'];

                  if (clickedId >= 0 && clickedId < _boxes.length)
                  {
                    _boxes[clickedId]['color'] = clickedColor;
                    _boxes[clickedId]['lastClickedBy'] = clickedBy;
                  }
                });
              }
        }
        catch (e)
        {
          debugPrint('Ошибка: $e');
        }
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

  void _handleBoxTap(int id)
  {
    final Map<String, dynamic> clickData =
    {
      'id': id,
      'color': Colors.red.value,
      'lastClickedBy': widget.username,
    };
    _channel.sink.add(jsonEncode(clickData));

    setState(()
    {
      _boxes[id]['color'] = Colors.red.value;
      _boxes[id]['lastClickedBy'] = widget.username;
    });
  }

  @override
  void dispose()
  {
    _channel.sink.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context)
  {
    return Scaffold
    (
      appBar: AppBar
      (
        title: const Text('Прямоугольники'),
      ),
      body: Column
      (
        children:
        [
          Expanded
          (
            child: GridView.builder
            (
              padding: const EdgeInsets.all(16.0),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount
              (
                crossAxisCount: 3,
                crossAxisSpacing: 4.0,
                mainAxisSpacing: 4.0,
                childAspectRatio: 2.0,
              ),
              itemCount: _boxes.length,
              itemBuilder: (context, index)
              {
                final box = _boxes[index];
                return GestureDetector
                (
                  onTap: () => _handleBoxTap(box['id']),
                  child: Container
                  (
                    decoration: BoxDecoration
                    (
                      color: Color(box['color']),
                      border: Border.all(color: Colors.black),
                    ),
                    child: Center
                    (
                      child: Text
                      (
                        box['lastClickedBy'].isNotEmpty
                            ? '${box['lastClickedBy']}'
                            : '${box['id']}',
                        textAlign: TextAlign.center,
                        style: TextStyle
                        (
                          color: box['color'] == Colors.green.value ? Colors.black : Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}