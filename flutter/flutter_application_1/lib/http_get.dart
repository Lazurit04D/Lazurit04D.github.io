import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main()
{
  runApp(MyApp());
}

class MyApp extends StatelessWidget
{
  const MyApp({super.key});

  @override
  Widget build(BuildContext context)
  {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('http.get()'),
        ),
        body: Center(
          child: ElevatedButton(
            onPressed: ()
            {
              fetchData();
            },
            child: const Text('http.get()'),
          ),
        ),
      ),
    );
  }

  Future<void> fetchData() async
  {
    final uri = Uri.parse('https://jsonplaceholder.typicode.com/posts');
    try
    {
      final response = await http.get(uri);

      if (response.statusCode == 200)
      {
        debugPrint('Ответ от сервера: ${response.body}');
      }
      else
      {
        debugPrint('Ошибка запроса. Код ошибки: ${response.statusCode}');
      }
    }
    catch (e)
    {
      debugPrint('Произошла ошибка: $e');
    }
  }
}