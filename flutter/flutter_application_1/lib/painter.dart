import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

void main()
{
  runApp(const PainterApp());
}

class PainterApp extends StatelessWidget
{
  const PainterApp({super.key});

  @override
  Widget build(BuildContext context)
  {
    return MaterialApp
    (
      title: 'Рисовалка',
      theme: ThemeData
      (
        primarySwatch: Colors.blue,
      ),
      home: PainterScreen(key: UniqueKey()),
    );
  }
}

class PainterScreen extends StatefulWidget
{
  const PainterScreen({super.key});

  @override
  PainterScreenState createState() => PainterScreenState();
}

class PainterScreenState extends State<PainterScreen>
{
  List<DrawingPath> _paths = [];
  DrawingPath? _currentPath;

  double _strokeWidth = 5.0;
  Color _selectedColor = Colors.black;

  final GlobalKey _painterCanvasKey = GlobalKey();

  void _updateStrokeWidth(double increment)
  {
    setState(()
    {
      _strokeWidth += increment;
      if (_strokeWidth < 1)
      {
        _strokeWidth = 1;
      }
      if (_strokeWidth > 50)
      {
        _strokeWidth = 50;
      }
    });
  }

  void _clearCanvas()
  {
    setState(()
    {
      _paths = [];
      _currentPath = null;
    });
  }

  void _showColorPickerDialog(BuildContext context)
  {
    showDialog
    (
      context: context,
      builder: (BuildContext context)
      {
        return AlertDialog
        (
          title: const Text('Выберите цвет'),
          content: SingleChildScrollView
          (
            child: ColorPicker
            (
              pickerColor: _selectedColor,
              onColorChanged: (color)
              {
                setState(()
                {
                  _selectedColor = color;
                });
              },
              labelTypes: const [],
              pickerAreaHeightPercent: 0.8,
            ),
          ),
          actions: <Widget>
          [
            TextButton
            (
              child: const Text('OK'),
              onPressed: ()
              {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context)
  {
    return Scaffold
    (
      appBar: AppBar
      (
        title: const Text('Рисовалка'),
        actions:
        [
          IconButton
          (
            icon: const Icon(Icons.palette),
            onPressed: () => _showColorPickerDialog(context),
          ),
          IconButton
          (
            icon: const Icon(Icons.remove),
            onPressed: () => _updateStrokeWidth(-1),
          ),
          Text('${_strokeWidth.toInt()}', style: const TextStyle(fontSize: 18)),
          IconButton
          (
            icon: const Icon(Icons.add),
            onPressed: () => _updateStrokeWidth(1),
          ),
          IconButton
          (
            icon: const Icon(Icons.clear),
            onPressed: _clearCanvas,
          ),
        ],
      ),
      body: LayoutBuilder
      (
        builder: (context, constraints)
        {
          return Stack
          (
            children:
            [
              CustomPaint
              (
                key: _painterCanvasKey,
                painter: Painter(_paths),
                size: Size(constraints.maxWidth, constraints.maxHeight),
              ),
              GestureDetector
              (
                onPanStart: (details)
                {
                  final RenderBox? renderBox =
                      _painterCanvasKey.currentContext?.findRenderObject() as RenderBox?;
                  if (renderBox == null)
                  {
                    return;
                  }
                  final Offset localPosition =
                      renderBox.globalToLocal(details.globalPosition);

                  setState(()
                  {
                    _currentPath = DrawingPath
                    (
                      points: [localPosition],
                      strokeWidth: _strokeWidth,
                      color: _selectedColor,
                    );
                    _paths = List.from(_paths)..add(_currentPath!);
                  });
                },
                onPanUpdate: (details)
                {
                  if (_currentPath == null) return;

                  final RenderBox? renderBox =
                      _painterCanvasKey.currentContext?.findRenderObject() as RenderBox?;
                  if (renderBox == null)
                  {
                    return;
                  }
                  final Offset localPosition =
                      renderBox.globalToLocal(details.globalPosition);

                  setState(()
                  {
                    _currentPath!.points.add(localPosition);
                    _paths = List.from(_paths);
                  });
                },
                onPanEnd: (details)
                {
                  setState(()
                  {
                    _currentPath = null;
                  });
                },
                child: Container
                (
                  color: Colors.transparent,
                  width: constraints.maxWidth,
                  height: constraints.maxHeight,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class DrawingPath
{
  List<Offset> points;
  final double strokeWidth;
  final Color color;

  DrawingPath({required this.points, required this.strokeWidth, required this.color});
}

class Painter extends CustomPainter
{
  final List<DrawingPath> paths;

  Painter(this.paths);

  @override
  void paint(Canvas canvas, Size size)
  {    
    for (var path in paths)
    {
      if (path.points.isEmpty) continue;

      Paint paint = Paint()
        ..color = path.color
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round
        ..strokeWidth = path.strokeWidth
        ..style = PaintingStyle.stroke;

      for (int i = 0; i < path.points.length - 1; i++)
      {
        canvas.drawLine(path.points[i], path.points[i + 1], paint);
      }

      if (path.points.length == 1)
      {
        paint.style = PaintingStyle.fill;
        canvas.drawCircle(path.points[0], path.strokeWidth / 2, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant Painter oldDelegate)
  {
    return oldDelegate.paths.length != paths.length ||
           (paths.isNotEmpty && oldDelegate.paths.isNotEmpty && oldDelegate.paths.last != paths.last);
  }
}