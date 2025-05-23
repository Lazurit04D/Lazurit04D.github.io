import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

void main()
{
  runApp(const PermissionApp());
}

class PermissionApp extends StatelessWidget
{
  const PermissionApp({super.key});

  @override
  Widget build(BuildContext context)
  {
    return MaterialApp
    (
      title: 'Permission Handler',
      theme: ThemeData
      (
        primarySwatch: Colors.blue,
      ),
      home: const PermissionExample(),
    );
  }
}

class PermissionExample extends StatefulWidget
{
  const PermissionExample({super.key});

  @override
  PermissionExampleState createState() => PermissionExampleState();
}

class PermissionExampleState extends State<PermissionExample>
{
  Future<void> _requestPermission(Permission permission) async
  {
    final status = await permission.request();

    if (status.isGranted)
    {
      debugPrint('Разрешение получено!');
    }
    else if (status.isDenied)
    {
      debugPrint('Разрешение отклонено');
    }
    else if (status.isPermanentlyDenied)
    {
      debugPrint('Разрешение отклонено навсегда');
    }
  }

  @override
  Widget build(BuildContext context)
  {
    return Scaffold
    (
      appBar: AppBar
      (
        title: const Text('Permission Handler'),
      ),
      body: Center
      (
        child: Column
        (
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>
          [
            ElevatedButton
            (
              onPressed: ()
              {
                _requestPermission(Permission.location);
              },
              child: const Text('Местоположение'),
            ),

            const SizedBox(height: 10),

            ElevatedButton
            (
              onPressed: ()
              {
                _requestPermission(Permission.microphone);
              },
              child: const Text('Микрофон'),
            ),
          ],
        ),
      ),
    );
  }
}