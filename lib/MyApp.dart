import 'package:flutter/material.dart';
import 'Telas/TelaInicial.dart';
import 'Telas/AddCliente.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => TelaInicial(),
        '/addcliente': (context) => AddCliente(),
      },
    );
  }
}