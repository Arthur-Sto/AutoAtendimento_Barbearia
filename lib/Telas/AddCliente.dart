import 'package:flutter/material.dart';
import 'package:multi_dropdown/multi_dropdown.dart';

class Cliente {
  String nome = "";
  String telefone = "";
  List<String> servicos = [];
  DateTime data = DateTime.now();
  String horario = "";
  bool finalizado = false;

  Cliente(
    this.nome,
    this.telefone,
    this.servicos,
    this.data,
  ) : horario = definirHorario(data);

  static definirHorario(DateTime data) {
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

  finalizarCliente() {
    finalizado = true;
  }
}

class AddCliente extends StatelessWidget {
  const AddCliente({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      title: Text(
        'Adicionar Cliente',
        style: TextStyle(
          color: const Color.fromARGB(
            255,
            0,
            0,
            0,
          ),
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
      content: Column(
        children: [
          TextField(
            decoration: InputDecoration(
              labelText: 'Nome',
              labelStyle: TextStyle(
                color: const Color.fromARGB(
                  255,
                  94,
                  94,
                  94,
                ),
              ),
              focusedBorder:
                  const OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color.fromARGB(
                        255,
                        128,
                        12,
                        4,
                      ),
                    ),
                  ),
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 16),
          TextField(
            decoration: InputDecoration(
              labelText: 'Telefone',
              labelStyle: TextStyle(
                color: const Color.fromARGB(
                  255,
                  94,
                  94,
                  94,
                ),
              ),
              focusedBorder:
                  const OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color.fromARGB(
                        255,
                        128,
                        12,
                        4,
                      ),
                    ),
                  ),
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 16),
          MultiDropdown<String>(
             searchEnabled: true,
            items: [
              DropdownItem(
                label: 'Australia',
                value: 'AU',
              ),
              DropdownItem(
                label: 'Canada',
                value: 'CA',
              ),
              DropdownItem(
                label: 'India',
                value: 'IN',
              ),
              DropdownItem(
                label: 'United States',
                value: 'US',
              ),
            ],
            onSelectionChange: (selectedItems) {
              debugPrint(
                'Selected: $selectedItems',
              );
            },
          ),
        ],
      ),

      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text(
            'Fechar',
            style: TextStyle(color: Colors.red),
          ),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Color.fromARGB(
              255,
              128,
              12,
              4,
            ),
          ),
          onPressed: () {
            // Lógica para salvar o cliente
          },
          child: Text(
            'Salvar',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }
}
