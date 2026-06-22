import 'package:flutter/material.dart';
import 'package:multi_dropdown/multi_dropdown.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Cliente {
  String nome = "";
  String telefone = "";
  List<String> servicos = [];
  DateTime data = DateTime.now();
  String horario = "";
  String profissional = "";
  double valor = 0.0;
  Map<String, String> pagamento =
      {}; //crédito: amex

  bool finalizado = false;

  Cliente(
    this.nome,
    this.telefone,
    this.servicos,
    this.data,
    this.profissional,
    this.pagamento,
    this.valor,
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

  toMap() {
    return {
      'nome': nome,
      'telefone': telefone,
      'servicos': servicos,
      'data': data.toIso8601String(),
      'horario': horario,
      'profissional': profissional,
      'pagamento': pagamento,
      'finalizado': finalizado,
      'valor': valor,
    };
  }
}

class ObterServicos {
  static const String _urlAppsScript =
      'https://script.google.com/macros/s/AKfycby0tew838e9VnJiyZ3y5PPi7EP5XylLkVXVhhrd4TrlafMSQKhLc7ZjBXlZVzCPWDNjOw/exec';

  static Future<List<Map<String, dynamic>>>
  buscarServicos() async {
    try {
      final response = await http.get(
        Uri.parse(_urlAppsScript),
      );

      if (response.statusCode == 200) {
        List<dynamic> dados = jsonDecode(
          response.body,
        );

        return dados
            .map(
              (item) => {
                'servico': item['servico']
                    .toString(),
                'preco': item['preco'].toString(),
              },
            )
            .toList();
      } else {
        throw Exception(
          'Falha ao carregar serviços da planilha',
        );
      }
    } catch (e) {
      print('Erro ao buscar dados: $e');
      return [];
    }
  }
}

// void main() async {
//   print('Buscando dados na planilha...');
//   List<Map<String, dynamic>> resultado =
//       await ObterServicos.buscarServicos();

//   print(resultado);
// }

class AddCliente extends StatefulWidget {
  const AddCliente({super.key});

  @override
  State<AddCliente> createState() =>
      _AddClienteState();
}

class _AddClienteState extends State<AddCliente> {
  // 1. Controllers para os TextFields
  final TextEditingController _nomeController =
      TextEditingController();
  final TextEditingController
  _telefoneController = TextEditingController();

  // 2. Controllers para os MultiDropdowns
  final MultiSelectController<String>
  _servicosController =
      MultiSelectController<String>();
  final MultiSelectController<String>
  _profissionaisController =
      MultiSelectController<String>();
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
            controller: _nomeController,
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
            controller: _telefoneController,
          ),
          SizedBox(height: 16),

          FutureBuilder<
            List<Map<String, dynamic>>
          >(
            // Apontamos qual função ele deve esperar terminar
            future:
                ObterServicos.buscarServicos(),

            builder: (context, snapshot) {
              // Estado 1: Ainda está carregando (mostra a bolinha girando)
              if (snapshot.connectionState ==
                  ConnectionState.waiting) {
                return const Center(
                  child:
                      CircularProgressIndicator(),
                );
              }

              // Estado 2: Deu algum erro na requisição HTTP
              if (snapshot.hasError) {
                return const Text(
                  'Erro ao carregar serviços.',
                  style: TextStyle(
                    color: Colors.red,
                  ),
                );
              }

              // Estado 3: Os dados chegaram com sucesso!
              if (snapshot.hasData &&
                  snapshot.data!.isNotEmpty) {
                // Transformamos o resultado da planilha em itens do Dropdown
                List<DropdownItem<String>>
                itensDoDropdown = snapshot.data!.map((
                  item,
                ) {
                  String nomeServico =
                      item['servico'];
                  String labelCompleto =
                      '$nomeServico - R\$ ${item['preco']}';

                  return DropdownItem<String>(
                    label:
                        labelCompleto, // Aparece na tela (cortado se for muito grande)
                    value:
                        nomeServico, // Salva no código (valor original intacto)
                  );
                }).toList();

                // Finalmente, desenhamos o dropdown
                return MultiDropdown<String>(
                  items: itensDoDropdown,
                  searchEnabled: true,
                  // 1. Controller obrigatoriamente linkado aqui
                  controller: _servicosController,
                  fieldDecoration:
                      const FieldDecoration(
                        hintText:
                            'Selecione os serviços...',
                      ),
                  chipDecoration:
                      const ChipDecoration(
                        wrap: true,
                      ),

                  // 2. Construtor customizado para os itens selecionados (Evita o overflow)
                  selectedItemBuilder: (item) {
                    return Container(
                      constraints: BoxConstraints(
                        maxWidth:
                            MediaQuery.sizeOf(
                              context,
                            ).width *
                            0.65,
                      ),
                      margin:
                          const EdgeInsets.all(4),
                      padding:
                          const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                      decoration: BoxDecoration(
                        color: const Color(
                          0xFFFFF0F5,
                        ),
                        borderRadius:
                            BorderRadius.circular(
                              8,
                            ),
                        border: Border.all(
                          color: const Color(
                            0xFFFFD1DC,
                          ),
                        ),
                      ),
                      child: Row(
                        mainAxisSize:
                            MainAxisSize.min,
                        children: [
                          Flexible(
                            child: Text(
                              item.label,
                              style:
                                  const TextStyle(
                                    fontSize: 13,
                                    color: Colors
                                        .black87,
                                  ),
                              overflow:
                                  TextOverflow
                                      .ellipsis,
                              maxLines: 1,
                            ),
                          ),
                          const SizedBox(
                            width: 6,
                          ),

                          // 3. Botão (X) funcional
                          GestureDetector(
                            onTap: () {
                              // Remove o item usando o controller
                              _servicosController
                                  .unselectWhere(
                                    (i) =>
                                        i.value ==
                                        item.value,
                                  );
                            },
                            child: const Icon(
                              Icons.close,
                              size: 14,
                              color:
                                  Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                  onSelectionChange: (selectedItems) {
                    debugPrint(
                      'Serviços escolhidos: $selectedItems',
                    );
                    // Aqui você salva esses itens na sua classe Cliente!
                  },
                );
              }

              // Estado 4: A planilha retornou vazia
              return const Text(
                'Nenhum serviço encontrado.',
              );
            },
          ),
          SizedBox(height: 16),
          MultiDropdown<String>(
            controller: _profissionaisController,
            singleSelect: true,
            searchEnabled: true,
            fieldDecoration: const FieldDecoration(
              hintText:
                  'Selecione o profissional...',
            ),
            items: [
              for (String profis in [
                'Davi',
                'Felipe',
                'Guilherme',
                'Kaio',
                'Marcelo',
                'Marlon',
                'Mauricio',
                'Michel',
                'Free1',
                'Free2',
              ])
                DropdownItem<String>(
                  label: profis,
                  value: profis,
                ),
            ],
            onSelectionChange: (selected) {},
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
            List<String> servicosEscolhidos =
                _servicosController.selectedItems
                    .map((item) => item.value)
                    .toList();

            List<String> profissionaisEscolhidos =
                _profissionaisController
                    .selectedItems
                    .map((item) => item.value)
                    .toList();
            debugPrint(
              'Nome: ${_nomeController.text}',
            );
            debugPrint(
              'Telefone: ${_telefoneController.text}',
            );
            debugPrint(
              'Serviços: ${servicosEscolhidos}',
            );
            debugPrint(
              'Profissionais: ${profissionaisEscolhidos}',
            );
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
