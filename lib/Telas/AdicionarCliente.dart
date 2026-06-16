import 'package:flutter/material.dart';

class Cliente {
  String nome = "";
  String telefone = "";
  List<String> servicos = [];
  DateTime data = DateTime.now();
  String horario = "";

  Cliente(
    this.nome,
    this.telefone,
    this.servicos,
    this.data,
  ) : horario = definirHorario(data);

static definirHorario(DateTime data){
  if (data.minute > 50) {
    return "${data.hour + 1}:00";
  } else if (data.minute > 20) {
    return "${data.hour}:30";
  } else {
    return "${data.hour}:00";
  }
}
  addservicos(List<String> servico) {
    for (String serv in servico) {
    servicos.add(serv);
    }
  }

  mudarservicos(List<String> servico) {
    int inicio = 0;
    for (String serv in servico) {
      servicos.replaceRange(
        inicio,
        servicos.length,
        [serv],
      );
      inicio++;
    }
  }
}

class AddCliente extends StatelessWidget {
  const AddCliente({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Center()),
    );
  }
}
