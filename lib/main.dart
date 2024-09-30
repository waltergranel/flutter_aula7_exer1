import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_aula7_exer1/tempo.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  final LocationSettings locationSettings = const LocationSettings(
    accuracy: LocationAccuracy.high,
    distanceFilter: 100,
  );
  var textUmidade = '';
  var textTemperatura = '';
  late Position posicao;
  String lat = '';
  String lon = '';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Column(
            children: [
              const SizedBox(
                height: 40,
              ),
              const Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Icon(
                    Icons.satellite_alt_rounded,
                    size: 30,
                  ),
                  Text(
                      style: TextStyle(
                        fontSize: 25,
                      ),
                      '  Sistema de Geolocalização'),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                'Latitude: $lat',
                style: const TextStyle(
                  fontSize: 32,
                ),
              ),
              Text(
                'Longitude: $lon',
                style: const TextStyle(
                  fontSize: 32,
                ),
              ),
              Text(
                style: const TextStyle(
                    color: Colors.red,
                    fontSize: 32,
                    fontWeight: FontWeight.bold),
                'Temperatura atual: $textTemperaturaºC',
              ),
              Text(
                  style: const TextStyle(
                      color: Colors.red,
                      fontSize: 32,
                      fontWeight: FontWeight.bold),
                  'Umidade atual: $textUmidade'),
              const SizedBox(
                height: 20,
              ),              
              
              TextButton(
                onPressed: buscaTempo,
                child: const Text('Buscar'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void buscaTempo() async {
    Position position =
        await Geolocator.getCurrentPosition(locationSettings: locationSettings);

    lat = '${position.latitude}';
    //String lat = _latitude.text;
    lon = '${position.longitude}';
    //String lon = _longitude.text;

    String url =
        'https://api.open-meteo.com/v1/forecast?latitude=$lat&longitude=$lon&current=temperature_2m,relative_humidity_2m&forecast_days=1';

    final resposta = await http.get(Uri.parse(url));
    if (resposta.body.length <= 21) {
      setState(() {});
    } else if (resposta.statusCode == 200) {
      // resposta 200 OK
      // o body contém JSON
      final jsonDecodificado = jsonDecode(resposta.body);
      final jsonTempoAtual = jsonDecodificado['current'];
      final valores = Tempo.fromJson(jsonTempoAtual);
      setState(() {
        textTemperatura = '${valores.temperatura.toString()}';
        textUmidade = '${valores.umidadeRelativa.toString()}';
      });
    } else {
      // diferente de 200
      setState(() {
        textTemperatura = 'Falha no carregamento dos dados.';
        textUmidade = '';
      });
    }
  }
}
