import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CadastroCasaAposta extends StatefulWidget {
  const CadastroCasaAposta({super.key});

  @override
  State<CadastroCasaAposta> createState() => _CadastroCasaApostaState();
}

class _CadastroCasaApostaState extends State<CadastroCasaAposta> {
  final nomeController = TextEditingController();
  String corSelecionada = 'Vermelho';

  final List<String> cores = ['Vermelho', 'Verde', 'Azul', 'Amarelo', 'Roxo'];

  void cadastrarCasa() async {
    await FirebaseFirestore.instance.collection('casas_aposta').add({
      'nome': nomeController.text.trim().toUpperCase(),
      'cor': corSelecionada,
    });

    nomeController.clear();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Casa cadastrada com sucesso!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cadastro Casa de Aposta')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: nomeController,
              decoration: const InputDecoration(labelText: 'Nome da Casa'),
            ),
            DropdownButtonFormField<String>(
              value: corSelecionada,
              items: cores
                  .map<DropdownMenuItem<String>>(
                    (cor) => DropdownMenuItem<String>(value: cor, child: Text(cor)),
                  )
                  .toList(),
              onChanged: (value) => setState(() => corSelecionada = value!),
              decoration: const InputDecoration(labelText: 'Cor'),
            ),
            ElevatedButton(onPressed: cadastrarCasa, child: const Text('Cadastrar')),
          ],
        ),
      ),
    );
  }
}
