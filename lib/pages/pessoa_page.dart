import 'package:flutter/material.dart';

import '../core/firestore_service.dart';

class PessoaPage extends StatefulWidget {
  String? id;
  PessoaPage({super.key, this.id});

  @override
  State<PessoaPage> createState() => _PessoaPageState();
}

class _PessoaPageState extends State<PessoaPage> {
  final txtNome = TextEditingController();
  final txtContato = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _carregarDados();

  }
    void _carregarDados() async {
      if(widget.id != null ){
        final dados = await FirestoreService().buscaPorId(widget.id!);
        txtNome.text = dados?['nome'];
        txtContato.text = dados?['contato'];
      }
    }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pessoa'),
      ),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            TextField(
              controller: txtNome,
              decoration: const InputDecoration(
                label: Text('Nome:')
              ),
            ),
            const SizedBox(
              height: 20,
            ),
             TextField(
              controller: txtContato,
              decoration: const InputDecoration(
                label: Text('Contato:')
              ),
            ),
            const SizedBox(
              height: 20,
            ),
              ElevatedButton(
                onPressed: () async{
                final idGerado = await FirestoreService().gravar(
                  txtNome.text, 
                  txtContato.text, 
                  id: widget.id
                );
                widget.id = idGerado;

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Cadastrado com sucesso'))
                );
              }, 
              child: const Text('Salvar'),
            ),
          ],
        ),
      ),
    );
  }
  
}