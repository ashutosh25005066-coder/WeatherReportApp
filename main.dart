import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Weather App',
      theme: ThemeData.dark(),
      home: const WeatherPage(),
    );
  }
}

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  final TextEditingController cityController = TextEditingController();

  String city = "";
  String temperature = "";
  String description = "";
  String humidity = "";
  bool isLoading = false;

  Future<void> getWeather() async {
    setState(() {
      isLoading = true;
    });

    final apiKey = "YOUR_API_KEY_HERE";
    final url =
        "https://api.openweathermap.org/data/2.5/weather?q=$city&appid=$apiKey&units=metric";

    try {
      final response = await http.get(Uri.parse(url));
      final data = json.decode(response.body);

      setState(() {
        temperature = data["main"]["temp"].toString();
        description = data["weather"][0]["description"];
        humidity = data["main"]["humidity"].toString();
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("City not found")),
      );
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Weather Report App"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: cityController,
              decoration: const InputDecoration(
                hintText: "Enter city name",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.location_city),
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                city = cityController.text.trim();
                getWeather();
              },
              child: const Text("Get Weather"),
            ),
            const SizedBox(height: 20),

            if (isLoading) const CircularProgressIndicator(),

            if (!isLoading && temperature.isNotEmpty)
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Text(city,
                          style: const TextStyle(
                              fontSize: 22, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 10),
                      Text("🌡 Temperature: $temperature °C"),
                      Text("☁ Weather: $description"),
                      Text("💧 Humidity: $humidity %"),
                    ],
                  ),
                ),
              )
          ],
        ),
      ),
    );
  }
}
