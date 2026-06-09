import 'package:flutter/material.dart';
import 'Telas/TelaInicial.dart';

class AutoAtendimento extends StatelessWidget {
  const AutoAtendimento({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => TelaInicial()
      },
    );
  }
}