import 'package:flutter/material.dart';

class TelaInicial extends StatelessWidget {
  const TelaInicial({super.key});

  @override
  Widget build(BuildContext context) {
     final screenWidth = MediaQuery.of(
      context,
    ).size.width;

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/imagens/logo300.png', width: screenWidth * 0.4),
            InkWell(
              onTap: () {
                print("mim apertaro");
              },
              
              child: Card(
                child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(40.0),
                        child: Column(
                          children: [
                            Icon(Icons.person_add, size: 78, color: Color.fromARGB(255, 180, 14, 2)),
                            SizedBox(height: 16),
                            Text('Novo Cliente', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
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