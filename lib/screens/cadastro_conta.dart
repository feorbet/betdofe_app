import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class CadastroConta extends StatefulWidget {
  const CadastroConta({super.key});

  @override
  State<CadastroConta> createState() => _CadastroContaState();
}

class _CadastroContaState extends State<CadastroConta> {
  final nomeContaController = TextEditingController();
  final usuarioController = TextEditingController();
  final senhaController = TextEditingController();
  final pixController = TextEditingController();
  DateTime dataCriacao = DateTime.now();

  String? casaApostaSelecionada;
  String statusSelecionado = 'Ativo';
  String generoSelecionado = 'Homem';
  String idadeSelecionada = '18-25';

  void cadastrarConta() async {
    await FirebaseFirestore.instance.collection('contas').add({
      'data_criacao': dataCriacao,
      'nome_conta': nomeContaController.text.trim().toUpperCase(),
      'casa_aposta': casaApostaSelecionada,
      'status': statusSelecionado,
      'genero': generoSelecionado,
      'idade': idadeSelecionada,
      'usuario': usuarioController.text.trim(),
      'senha': senhaController.text.trim(),
      'pix': pixController.text.trim(),
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Conta cadastrada com sucesso!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cadastro de Conta')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text('Data: ${DateFormat('dd/MM/yyyy').format(dataCriacao)}'),
              TextField(controller: nomeContaController, decoration: const InputDecoration(labelText: 'Nome da Conta')),
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection('casas_aposta').snapshots(),
                builder: (_, snapshot) {
                  if (!snapshot.hasData) return const CircularProgressIndicator();
                  return DropdownButtonFormField<String>(
                    value: casaApostaSelecionada,
                    items: snapshot.data!.docs.map((doc) {
                      return DropdownMenuItem<String>(
                          value: doc['nome'], child: Text(doc['nome']));
                    }).toList(),
                    onChanged: (val) => setState(() => casaApostaSelecionada = val),
                    decoration: const InputDecoration(labelText: 'Casa de Aposta'),
                  );
                },
              ),
              DropdownButtonFormField<String>(
                value: statusSelecionado,
                items: ['Ativo', 'Inativo', 'Nova']
                    .map<DropdownMenuItem<String>>(
                      (status) => DropdownMenuItem<String>(value: status, child: Text(status)),
                    )
                    .toList(),
                onChanged: (v) => setState(() => statusSelecionado = v!),
              ),
              DropdownButtonFormField<String>(
                value: generoSelecionado,
                items: ['Homem', 'Mulher', 'Outros']
                    .map<DropdownMenuItem<String>>(
                      (g) => DropdownMenuItem<String>(value: g, child: Text(g)),
                    )
                    .toList(),
                onChanged: (v) => setState(() => generoSelecionado = v!),
              ),
              DropdownButtonFormField<String>(
                value: idadeSelecionada,
                items: ['18-25', '26-40', '41-70']
                    .map<DropdownMenuItem<String>>(
                      (i) => DropdownMenuItem<String>(value: i, child: Text(i)),
                    )
                    .toList(),
                onChanged: (v) => setState(() => idadeSelecionada = v!),
              ),
              TextField(controller: usuarioController, decoration: const InputDecoration(labelText: 'Usuário')),
              TextField(controller: senhaController, decoration: const InputDecoration(labelText: 'Senha')),
              TextField(controller: pixController, decoration: const InputDecoration(labelText: 'Chave Pix')),
              ElevatedButton(onPressed: cadastrarConta, child: const Text('Cadastrar')),
            ],
          ),
        ),
      ),
    );
  }
}
