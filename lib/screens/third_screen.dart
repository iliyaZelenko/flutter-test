import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../main.dart';

class ThirdScreen extends StatefulWidget {
  const ThirdScreen({super.key});

  @override
  State<ThirdScreen> createState() => _ThirdScreenState();
}

class _ThirdScreenState extends State<ThirdScreen> {
  @override
  Widget build(BuildContext context) {
    return const Layout(
      children: [
        WeatherScreen(),
      ],
    );
  }
}

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  WeatherScreenState createState() => WeatherScreenState();
}

class WeatherScreenState extends State<WeatherScreen> {
  static const String apiKey = '092696f789e08b9f1263936458909ab9';
  static const Duration autoUpdate = Duration(seconds: 2);

  final TextEditingController cityController = TextEditingController();

  String currentCity = 'Saratov';
  Map<String, dynamic>? weatherData;
  var loading = false;

  @override
  void initState() {
    super.initState();
    cityController.text = currentCity;
    fetchWeather(currentCity).then(
      (_) => Future.delayed(autoUpdate, updateWeatherAutomatically),
    );
  }

  Future<void> updateWeatherAutomatically() async {
    setState(() {
      loading = true;
    });
    await fetchWeather(currentCity);
    setState(() {
      loading = false;
    });
    Future.delayed(autoUpdate, updateWeatherAutomatically);
  }

  Future<void> fetchWeather(String cityName) async {
    final response = await http.get(
      Uri.parse(
        'https://api.openweathermap.org/data/2.5/weather?q=$cityName&appid=$apiKey&units=metric',
      ),
    );

    if (response.statusCode == 200) {
      setState(() {
        weatherData = jsonDecode(response.body);
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Ошибка при загрузке погоды${response.body.isNotEmpty ? ': ${response.body}' : ''}',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 20),
        TextField(
          controller: cityController,
          decoration: InputDecoration(
            labelText: 'Введите город на английском (и нажать ввод)',
            border: const OutlineInputBorder(),
            suffix: loading
                ? const SizedBox.square(
                    dimension: 14,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                    ),
                  )
                : null,
          ),
          onSubmitted: (value) {
            currentCity = value;
            fetchWeather(currentCity);
          },
        ),
        const SizedBox(height: 5),
        Text(
          'Например: Moscow, London, New York',
          style: Theme.of(context).textTheme.bodySmall,
        ),
        const SizedBox(height: 20),
        weatherData == null
            ? const CircularProgressIndicator()
            : Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (weatherData!['weather']?[0]?['icon'] != null)
                        Image.network(
                          'https://openweathermap.org/img/w/${weatherData!['weather'][0]['icon']}.png',
                        ),
                      Text(
                        '${weatherData!['main']['temp']}°C',
                        style: const TextStyle(fontSize: 40),
                      ),
                    ],
                  ),
                  Text(
                    '${weatherData!['name']}',
                    style: const TextStyle(fontSize: 20),
                  ),
                ],
              ),
      ],
    );
  }
}
