import 'package:firebase_app/core/auth_service.dart';
import 'package:firebase_app/pages/home_page.dart';
import 'package:firebase_app/pages/nova_conta_page.dart';

import 'package:flutter/material.dart';
import 'weather_service.dart'; // Importe seu serviço de busca de dados meteorológicos

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();
  final authService = AuthService();
  final WeatherService _weatherService = WeatherService(); // Instância do serviço de busca de dados meteorológicos
  Map<String, dynamic>? _weatherData; // Dados meteorológicos obtidos da API

  @override
  void initState() {
    super.initState();
    _fetchWeatherData(); // Busca os dados meteorológicos ao iniciar a tela
  }

  void _fetchWeatherData() async {
    try {
      final weatherData = await _weatherService.getWeatherData();
      setState(() {
        _weatherData = weatherData;
      });
    } catch (e) {
      print('Erro ao buscar os dados meteorológicos: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _weatherData != null
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Cidade: ${_weatherData!['location']['name']}',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Temperatura: ${_weatherData!['current']['temp_c']}°C',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Condição: ${_weatherData!['current']['condition']['text']}',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 20),
                      ],
                    )
                  : CircularProgressIndicator(), // Mostra um indicador de carregamento enquanto os dados estão sendo buscados
              Text(
                'Entrar na Agenda',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                ),
              ),
              TextField(
                controller: _senhaController,
                decoration: InputDecoration(
                  labelText: 'Senha',
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  final usuario = await authService.login(
                    _emailController.text,
                    _senhaController.text,
                  );
                  if (usuario == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Usuário ou senha inválido'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  } else {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HomePage(),
                      ),
                    );
                  }
                },
                child: const Text('Entrar'),
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => NovaConta(),
                    ),
                  ).then((value) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Conta criada com sucesso'),
                      ),
                    );
                  });
                },
                child: Text('Ainda não possuo uma conta'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}