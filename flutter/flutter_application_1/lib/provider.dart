import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:async';

void main()
{
  runApp
  (
    ChangeNotifierProvider
    (
      create: (context) => TimerService(),
      child: const ProviderApp(),
    ),
  );
}

class ProviderApp extends StatelessWidget
{
  const ProviderApp({super.key});

  @override
  Widget build(BuildContext context)
  {
    return MaterialApp
    (
      title: 'Provider',
      theme: ThemeData
      (
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes:
      {
        '/': (context) => const HomeScreen(),
        '/secondScreen': (context) => const SecondScreen(),
      },
    );
  }
}

class TimerService extends ChangeNotifier
{
  int _secondsElapsed = 0;
  Timer? _timer;
  bool _isRunning = false;

  int get secondsElapsed => _secondsElapsed;
  bool get isRunning => _isRunning;

  void startTimer()
  {
    if (!_isRunning)
    {
      _isRunning = true;
      _timer = Timer.periodic(const Duration(seconds: 1), (timer)
      {
        _secondsElapsed++;
        notifyListeners();
      });
      notifyListeners();
    }
  }

  void stopTimer()
  {
    if (_isRunning)
    {
      _isRunning = false;
      _timer?.cancel();
      _timer = null;
      notifyListeners();
    }
  }

  void resetTimer()
  {
    stopTimer();
    _secondsElapsed = 0;
    notifyListeners();
  }

  @override
  void dispose()
  {
    _timer?.cancel();
    super.dispose();
  }
}

class HomeScreen extends StatelessWidget
{
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context)
  {
    final timerService = Provider.of<TimerService>(context);

    return Scaffold
    (
      appBar: AppBar
      (
        title: const Text('Экран 1'),
      ),
      body: Center
      (
        child: Column
        (
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>
          [
            Consumer<TimerService>
            (
              builder: (context, timerService, child)
              {
                return Text
                (
                  'Время: ${timerService.secondsElapsed} секунд',
                  style: const TextStyle(fontSize: 48),
                );
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton
            (
              onPressed: ()
              {
                Navigator.pushNamed(context, '/secondScreen');
              },
              child: const Text('Экран 2'),
            ),
            const SizedBox(height: 20),
            Row
            (
              mainAxisAlignment: MainAxisAlignment.center,
              children:
              [
                ElevatedButton
                (
                  onPressed: timerService.isRunning ? timerService.stopTimer : timerService.startTimer,
                  child: Text(timerService.isRunning ? 'Стоп' : 'Старт'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class SecondScreen extends StatelessWidget
{
  const SecondScreen({super.key});

  @override
  Widget build(BuildContext context)
  {
    return Scaffold
    (
      appBar: AppBar
      (
        title: const Text('Экран 2'),
      ),
      body: Center
      (
        child: Column
        (
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>
          [
            Consumer<TimerService>
            (
              builder: (context, timerService, child)
              {
                return Text
                (
                  'Время: ${timerService.secondsElapsed} секунд',
                  style: const TextStyle(fontSize: 48),
                  textAlign: TextAlign.center,
                );
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton
            (
              onPressed: ()
              {
                Navigator.pop(context);
              },
              child: const Text('Экран 1'),
            ),
          ],
        ),
      ),
    );
  }
}