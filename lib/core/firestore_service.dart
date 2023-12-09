import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService{
  final _firestoreReference = FirebaseFirestore.instance;

   Future<String> gravar(String nome, String contato, {String? id}) async{
    if(id != null) {
      final item = await  _firestoreReference.collection('pessoas').doc(id);
    
        item.set({
          'nome': nome,
          'contato': contato
        });

        return id;
  
    }else{
     final ref = await _firestoreReference.collection('pessoas').add({
        'nome': nome,
        'contato': contato,
    });
    return ref.id;
    }
  }

 CollectionReference<Map<String, dynamic>> listar(){
    return _firestoreReference.collection('pessoas');
  }

  remover(String chave) async {
    final item = await  _firestoreReference.collection('pessoas').doc(chave);
    if(item != null){
      item.delete();
    }
  }

 Future< Map<String, dynamic>? > buscaPorId(String id ) async{
  
    final snap = await  _firestoreReference.collection('pessoas').doc(id).get();
    return snap.data();

  }

}