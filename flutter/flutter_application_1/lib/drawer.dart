import 'package:flutter/material.dart';

void main()
{
  runApp(const DrawerApp());
}

class DrawerApp extends StatelessWidget
{
  const DrawerApp({super.key});

  @override
  Widget build(BuildContext context)
  {
    return MaterialApp
    (
      title: 'Drawer',
      theme: ThemeData
      (
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes:
      {
        '/': (context) => const HomePageWithDrawer(),
        '/screen1': (context) => const ScreenOne(),
        '/screen2': (context) => const ScreenTwo(),
        '/screen3': (context) => const ScreenThree(),
      },
    );
  }
}

class HomePageWithDrawer extends StatelessWidget
{
  const HomePageWithDrawer({super.key});

  @override
  Widget build(BuildContext context)
  {
    return Scaffold
    (
      appBar: AppBar
      (
        title: const Text('Главная страница'),
      ),
      drawer: AppDrawer(),
      body: const Center
      (
        child: Text
        (
          'Главная страница',
          style: TextStyle(fontSize: 22),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

class AppDrawer extends StatelessWidget
{
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context)
  {
    return Drawer
    (
      child: ListView
      (
        padding: EdgeInsets.zero,
        children: <Widget>
        [
          ListTile
          (
            title: const Text('Главная страница'),
            onTap: ()
            {
              Navigator.pop(context);
              Navigator.pushReplacementNamed(context, '/');
            },
          ),
          ListTile
          (
            title: const Text('Экран 1'),
            onTap: ()
            {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/screen1');
            },
          ),
          ListTile
          (
            title: const Text('Экран 2'),
            onTap: ()
            {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/screen2');
            },
          ),
          ListTile
          (
            title: const Text('Экран 3'),
            onTap: ()
            {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/screen3');
            },
          ),
        ],
      ),
    );
  }
}

class ScreenOne extends StatelessWidget
{
  const ScreenOne({super.key});

  @override
  Widget build(BuildContext context)
  {
    return Scaffold
    (
      appBar: AppBar
      (
        title: const Text('Экран 1'),
      ),
      body: const Center
      (
        child: Text
        (
          'Экран 1',
          style: TextStyle(fontSize: 24),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

class ScreenTwo extends StatelessWidget
{
  const ScreenTwo({super.key});

  @override
  Widget build(BuildContext context)
  {
    return Scaffold
    (
      appBar: AppBar
      (
        title: const Text('Экран 2'),
      ),
      body: const Center
      (
        child: Text
        (
          'Экран 2',
          style: TextStyle(fontSize: 24),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

class ScreenThree extends StatelessWidget
{
  const ScreenThree({super.key});

  @override
  Widget build(BuildContext context)
  {
    return Scaffold
    (
      appBar: AppBar
      (
        title: const Text('Экран 3'),
      ),
      body: const Center
      (
        child: Text
        (
          'Экран 3',
          style: TextStyle(fontSize: 24),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}