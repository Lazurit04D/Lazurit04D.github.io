import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:fl_chart/fl_chart.dart';
part 'mood_tracker.g.dart';

void main() async
{
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(MoodEntryAdapter());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget
{
  const MyApp({super.key});
  @override
  Widget build(BuildContext context)
  {
    return MaterialApp
    (
      title: 'Mood Tracker',
      theme: ThemeData
      (
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const MoodTrackerScreen(),
    );
  }
}

@HiveType(typeId: 0)
class MoodEntry extends HiveObject
{
  @HiveField(0)
  final int mood;
  @HiveField(1)
  final DateTime timestamp;

  MoodEntry({required this.mood, required this.timestamp});
}

class MoodService extends ChangeNotifier
{
  static const String _moodBoxName = 'moodBox';
  late Box<MoodEntry> _moodBox;

  MoodService()
  {
    _initHive();
  }

  Future<void> _initHive() async
  {
    if (!Hive.isBoxOpen(_moodBoxName))
    {
      _moodBox = await Hive.openBox<MoodEntry>(_moodBoxName);
    }
    else
    {
      _moodBox = Hive.box<MoodEntry>(_moodBoxName);
    }
    notifyListeners();
  }

  Future<void> addMoodEntry(int mood) async
  {
    if (!_moodBox.isOpen)
    {
      await _initHive();
    }
    await _moodBox.add(MoodEntry(mood: mood, timestamp: DateTime.now()));
    notifyListeners();
  }

  List<MoodEntry> getMoodEntries()
  {
    if (!_moodBox.isOpen)
    {
      return [];
    }
    return _moodBox.values.toList();
  }
}

class MoodTrackerScreen extends StatefulWidget
{
  const MoodTrackerScreen({super.key});
  @override
  State<MoodTrackerScreen> createState() => _MoodTrackerScreenState();
}

class _MoodTrackerScreenState extends State<MoodTrackerScreen>
{
  @override
  void initState()
  {
    super.initState();
  }

  IconData _getMoodIcon(int mood)
  {
    switch (mood)
    {
      case 1: return Icons.sentiment_very_satisfied;
      case 2: return Icons.sentiment_neutral;
      case 3: return Icons.sentiment_dissatisfied;
      default: return Icons.help_outline;
    }
  }

  String _getMoodText(int mood)
  {
    switch (mood)
    {
      case 1: return 'Счастливое';
      case 2: return 'Нейтральное';
      case 3: return 'Грустное';
      default: return 'Неизвестное';
    }
  }

  @override
  Widget build(BuildContext context)
  {
    return Scaffold
    (
      appBar: AppBar
      (
        title: const Text('Mood Tracker'),
      ),
      body: ChangeNotifierProvider<MoodService>
      (
        create: (context) => MoodService(),
        child: Consumer<MoodService>
        (
          builder: (context, moodService, child)
          {
            final moodEntries = moodService.getMoodEntries();

            return SingleChildScrollView
            (
              padding: const EdgeInsets.all(16.0),
              child: Column
              (
                crossAxisAlignment: CrossAxisAlignment.start,
                children:
                [
                  Row
                  (
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children:
                    [
                      GestureDetector(onTap: () => moodService.addMoodEntry(1), child: Column(children: [Icon(Icons.sentiment_very_satisfied, size: 60, color: Colors.green), const Text('Счастливое')])),
                      GestureDetector(onTap: () => moodService.addMoodEntry(2), child: Column(children: [Icon(Icons.sentiment_neutral, size: 60, color: Colors.yellow), const Text('Нейтральное')])),
                      GestureDetector(onTap: () => moodService.addMoodEntry(3), child: Column(children: [Icon(Icons.sentiment_dissatisfied, size: 60, color: Colors.red), const Text('Грустное')])),
                    ],
                  ),
                  const SizedBox(height: 30),

                  const Text('История:', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  moodEntries.isEmpty
                      ? const Text('Нет записей')
                      : SizedBox
                      (
                          height: 200,
                          child: ListView.builder
                          (
                            physics: const AlwaysScrollableScrollPhysics(),
                            itemCount: moodEntries.length,
                            itemBuilder: (context, index)
                            {
                              final entry = moodEntries[moodEntries.length - 1 - index];
                              return Card
                              (
                                margin: const EdgeInsets.symmetric(vertical: 5),
                                child: Padding
                                (
                                  padding: const EdgeInsets.all(10.0),
                                  child: Row
                                  (
                                    children:
                                    [
                                      Icon(_getMoodIcon(entry.mood), size: 30),
                                      const SizedBox(width: 10),
                                      Text('${_getMoodText(entry.mood)} - ${entry.timestamp.toLocal().toString().split('.')[0]}', style: const TextStyle(fontSize: 16)),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                  const SizedBox(height: 30),

                  const Text('График:', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  SizedBox
                  (
                    height: 200,
                    child: BarChart
                    (
                      BarChartData
                      (
                        barGroups: _getBarGroups(moodEntries),
                        titlesData: FlTitlesData
                        (
                          show: true,
                          bottomTitles: AxisTitles
                          (
                            sideTitles: SideTitles
                            (
                              showTitles: true,
                              getTitlesWidget: _getBottomTitles,
                              reservedSize: 30,
                            ),
                          ),
                          leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        ),
                        borderData: FlBorderData(show: false),
                        gridData: const FlGridData(show: false),
                        barTouchData: BarTouchData(enabled: false),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  List<BarChartGroupData> _getBarGroups(List<MoodEntry> entries)
  {
    final Map<int, int> moodCounts = {1: 0, 2: 0, 3: 0};
    for (var entry in entries)
    {
      moodCounts[entry.mood] = (moodCounts[entry.mood] ?? 0) + 1;
    }
    List<BarChartGroupData> barGroups = [];
    moodCounts.forEach((mood, count)
    {
      barGroups.add
      (
        BarChartGroupData
        (
          x: mood,
          barRods:
          [
            BarChartRodData
            (
              toY: count.toDouble(),
              color: _getBarColor(mood),
              width: 20,
              borderRadius: BorderRadius.circular(4),
            ),
          ],
        ),
      );
    });
    barGroups.sort((a, b) => a.x.compareTo(b.x));
    return barGroups;
  }

  Color _getBarColor(int mood)
  {
    switch (mood)
    {
      case 1: return Colors.green;
      case 2: return Colors.yellow;
      case 3: return Colors.red;
      default: return Colors.black;
    }
  }

  Widget _getBottomTitles(double value, TitleMeta meta)
  {
    Widget text;
    switch (value.toInt())
    {
      case 1: text = Icon(Icons.sentiment_very_satisfied, size: 20, color: Colors.green); break;
      case 2: text = Icon(Icons.sentiment_neutral, size: 20, color: Colors.yellow); break;
      case 3: text = Icon(Icons.sentiment_dissatisfied, size: 20, color: Colors.red); break;
      default: text = const Text(''); break;
    }
    return SideTitleWidget
    (
      meta: meta,
      space: 4,
      child: text,
    );
  }
}