class Tempo {
  final double temperatura;
  final int umidadeRelativa;

  Tempo({
    required this.temperatura,
    required this.umidadeRelativa,
  });

  factory Tempo.fromJson(Map<String, dynamic> json) {
    return Tempo(
      temperatura: (json['temperature_2m'] ?? 0.0)
          .toDouble(), // Valor padrão 0.0 se for null
      umidadeRelativa: (json['relative_humidity_2m'] ?? 0)
          .toInt(), // Valor padrão 0 se for null
    );
  }
}
