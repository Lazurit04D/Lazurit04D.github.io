import 'package:flutter/material.dart';

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
          title: Text('Картинка'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/Кот.jpg', width: 250, height: 250),
              
              const SizedBox(height: 30),

              Image.network(
                'https://ic.pics.livejournal.com/o_jivotnih/96279421/61886/61886_original.jpg',
                width: 250,
                height: 250,
              ),
            ],
          ),
        ),
      ),
    );
  }
}