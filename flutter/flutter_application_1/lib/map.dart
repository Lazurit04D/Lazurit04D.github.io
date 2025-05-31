import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

void main()
{
  runApp(const MapTaskApp());
}

class MapTaskApp extends StatelessWidget
{
  const MapTaskApp({super.key});

  @override
  Widget build(BuildContext context)
  {
    return const MaterialApp
    (
      home: MapTask(),
    );
  }
}

class MapTask extends StatefulWidget
{
  const MapTask({super.key});

  @override
  State<MapTask> createState() => _MapTaskState();
}

class _MapTaskState extends State<MapTask>
{
  final Map<String, LatLng> cities =
  {
    'Москва': LatLng(55.7558, 37.6173),
    'Санкт-Петербург': LatLng(59.9343, 30.3351),
    'Нижний Новгород': LatLng(56.2965, 43.9361),
    'Екатеринбург': LatLng(56.8389, 60.6057),
    'Казань': LatLng(55.7963, 49.1088),
  };

  String selectedCity = 'Нижний Новгород';
  final MapController _mapController = MapController();

  @override
  Widget build(BuildContext context)
  {
    return Scaffold
    (
      appBar: AppBar
      (
        title: const Text('Карта'),
        actions:
        [
          Padding
          (
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: DropdownButton<String>
            (
              value: selectedCity,
              dropdownColor: Colors.white,
              underline: const SizedBox(),
              iconEnabledColor: Colors.white,
              items: cities.keys.map((city)
              {
                return DropdownMenuItem<String>
                (
                  value: city,
                  child: Text(city),
                );
              }).toList(),
              onChanged: (value)
              {
                if (value != null)
                {
                  setState(()
                  {
                    selectedCity = value;
                  });
                  _mapController.move(cities[value]!, 13.0);
                }
              },
            ),
          ),
        ],
      ),
      body: FlutterMap
      (
        mapController: _mapController,
        options: MapOptions
        (
          initialCenter: cities[selectedCity]!,
          initialZoom: 13.0,
        ),
        children:
        [
          TileLayer
          (
            urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
            subdomains: const ['a', 'b', 'c'],
          ),
          MarkerLayer
          (
            markers:
            [
              Marker
              (
                point: cities[selectedCity]!,
                width: 80,
                height: 80,
                child: const Icon
                (
                  Icons.location_on,
                  color: Colors.red,
                  size: 40,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}