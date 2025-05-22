import 'package:flutter/material.dart';

void main()
{
  runApp(const MyAppForZadanye3());
}

class MyAppForZadanye3 extends StatelessWidget
{
  const MyAppForZadanye3({super.key});

  @override
  Widget build(BuildContext context)
  {
    return MaterialApp(
      title: 'Задание 3',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      home: const Zadanye3(),
    );
  }
}

Widget _buildBorderedContainer({
  double? width,
  double? height,
  Widget? child,
  Color color = Colors.white,
  EdgeInsetsGeometry? padding,
  AlignmentGeometry? alignment,
})
{
  return Container(
    width: width,
    height: height,
    padding: padding,
    alignment: alignment,
    decoration: BoxDecoration(
      color: color,
      border: Border.all(color: Colors.black, width: 1.0),
    ),
    child: child,
  );
}

class Zadanye3 extends StatelessWidget
{
  const Zadanye3({super.key});

  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Задание 3"),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Center(
        child: _buildBorderedContainer(
          width: 300,
          height: 400,
          color: Colors.white,
          child: Column(
            children: [
              Expanded(
                flex: 2,
                child: _buildBorderedContainer(),
              ),
              Expanded(
                flex: 2,
                child: _buildBorderedContainer(
                  child: Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: _buildBorderedContainer(),
                      ),
                      Expanded(
                        flex: 3,
                        child: _buildBorderedContainer(
                          color: Colors.blue,
                          height: double.infinity,
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: _buildBorderedContainer(),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: _buildBorderedContainer(
                  child: Row(
                    children: [
                      Expanded(child: _buildBorderedContainer()),
                      _buildBorderedContainer(width: 1, color: Colors.black),
                      Expanded(child: _buildBorderedContainer()),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: _buildBorderedContainer(
                  child: Row(
                    children: List.generate(7, (index) => Expanded(
                      flex: 1,
                      child: _buildBorderedContainer(),
                    )),
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: _buildBorderedContainer(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 15.0),
                    child: Center(
                      child: _buildBorderedContainer(
                        color: Colors.red,
                        width: 180,
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: _buildBorderedContainer(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
