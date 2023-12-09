import 'dart:convert';
import 'package:http/http.dart' as http;

class WeatherService {
  final String apiKey = '49696eabac714524b77224917230812';
  final String city = 'São Borja';

  Future<Map<String, dynamic>> getWeatherData() async {
    final response = await http.get(
        Uri.parse('https://api.weatherapi.com/v1/current.json?key=$apiKey&q=$city'));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Falha ao carregar os dados');
    }
  }
}
