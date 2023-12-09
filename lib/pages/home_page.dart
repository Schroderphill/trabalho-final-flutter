import 'package:firebase_app/core/firestore_service.dart';
import 'package:firebase_app/pages/pessoa_page.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dados Agenda'),
      ),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: StreamBuilder(
          stream: FirestoreService().listar().snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return CircularProgressIndicator();
            }
            final dados = snapshot.data!.docs;
            return ListView.builder(
              itemCount: dados.length,
              itemBuilder: (context, index) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      flex: 3,
                      child: Text(
                        dados[index]['nome'],
                        style: TextStyle(fontSize: 16.0),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Text(
                        dados[index]['contato'],
                        style: TextStyle(fontSize: 16.0),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => PessoaPage(id: dados[index].id),
                                ),
                              );
                            },
                            icon: Icon(Icons.edit),
                          ),
                          IconButton(
                            onPressed: () {
                              FirestoreService().remover(dados[index].id);
                            },
                            icon: Icon(Icons.delete),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => PessoaPage(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}