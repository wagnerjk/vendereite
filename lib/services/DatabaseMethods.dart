import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:app_vendas/models/Anuncio.dart';
import 'package:app_vendas/models/Usuario.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

import '../helpers/SharedPrefsHelper.dart';

class DatabaseMethods{
  final FirebaseFirestore db = FirebaseFirestore.instance;
  final Reference pastaRaiz = FirebaseStorage.instance.ref();

  Future addUsuarioToDB(String idUsuario, Map<String, dynamic> infoUsuario) async {
    return await db.collection("usuarios")
        .doc(idUsuario)
        .set(infoUsuario);
  }

  Future<String> uploadImagemPerfil(String idUsuario, File image) async {
    FirebaseStorage storage = FirebaseStorage.instance;
    Reference pastaRaiz = storage.ref();

    Reference arquivo = pastaRaiz
      .child("usuarios")
      .child(idUsuario)
      .child(idUsuario + ".jpg");

    UploadTask uploadTask = arquivo.putFile(image);

    return await (await uploadTask).ref.getDownloadURL();
  }

  Future updateDataDB(String idUsuario, Map<String, dynamic> dadosAtualizados) async {
    return await db.collection("usuarios")
      .doc(idUsuario)
      .update(dadosAtualizados);
  }

  Future deleteUserData(String idUsuario) async {
    return await db.collection("usuarios")
        .doc(idUsuario)
        .delete();
  }

  Future<Usuario> getUserDetails(String idUsuario) async {
    DocumentSnapshot documentSnapshot = await db.collection("usuarios")
        .doc(idUsuario)
        .get();

    Map<String, dynamic> dados = documentSnapshot.data();
    Usuario usuario = Usuario();
    usuario.nome = dados["nome"];
    usuario.email = dados["email"];
    usuario.urlImagemPerfil = dados["urlImagemPerfil"];

    return usuario;
  }

  Future<List<String>> saveImagesAnuncio(String idAnuncio, List<Asset> assets) async {
    List<String> urlImagens = [];

    for(var asset in assets){
      ByteData byteData = await asset.getByteData();
      List<int> imageData = byteData.buffer.asUint8List();

      String nomeImagem = DateTime.now().millisecondsSinceEpoch.toString();
      Reference arquivo = pastaRaiz
          .child("meus_anuncios")
          .child(idAnuncio)
          .child(nomeImagem);

      UploadTask uploadTask = arquivo.putData(imageData);

      urlImagens.add(await (await uploadTask).ref.getDownloadURL());
    }
    return urlImagens;
  }

  Future addAnuncioToDB(Anuncio anuncio) async {
    await db.collection("meus_anuncios")
        .doc(anuncio.idUsuario)
        .collection("anuncios")
        .doc(anuncio.id)
        .set(anuncio.toMap()).then((_){
          db.collection("anuncios")
              .doc(anuncio.id)
              .set(anuncio.toMap());
    });
  }

  Future<Stream<QuerySnapshot>> addListenerAnuncios() async {
    Stream<QuerySnapshot> stream = db
        .collection("anuncios")
        .snapshots();

    return stream;
  }

  Future<Stream<QuerySnapshot>> addListenerMeusAnuncios() async {
    String idUsuarioLogado = await SharedPreferenceHelper().getIdUsuario();

    Stream<QuerySnapshot> stream = db
        .collection("meus_anuncios")
        .doc(idUsuarioLogado)
        .collection("anuncios")
        .snapshots();

    return stream;
  }

  Future<QuerySnapshot> addListenerAnunciosFavoritos() async {
    String idUsuarioLogado = await SharedPreferenceHelper().getIdUsuario();
    List<String> ids = [];

    Stream<QuerySnapshot> stream = db
        .collection("meus_anuncios")
        .doc(idUsuarioLogado)
        .collection("meus_favoritos")
        .snapshots();

    //return stream;
    await for (QuerySnapshot q in stream){
      for (var doc in q.docs){
        var dados = doc.data();
        ids.add(dados["idAnuncioFavorito"]);
      }
      break;
    }

    QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection("anuncios")
        .where("id", whereIn: ids)
        .get();

    return querySnapshot;
  }

  Future addAnuncioFavorito(String idAnuncio, String idUsuario) async {
    await db.collection("meus_anuncios")
        .doc(idUsuario)
        .collection("meus_favoritos")
        .doc(idAnuncio)
        .set(
          {"idAnuncioFavorito" : idAnuncio}
        );
  }

  Future removeAnuncioFavorito(String idAnuncio, String idUsuario) async {
    await db.collection("meus_anuncios")
        .doc(idUsuario)
        .collection("meus_favoritos")
        .doc(idAnuncio)
        .delete();
  }

  Future<bool> verificaAnuncioFavorito(String idAnuncio, String idUsuario) async {
    bool favorito = false;

    await db.collection("meus_anuncios")
        .doc(idUsuario)
        .collection("meus_favoritos")
        .doc(idAnuncio)
        .get().then((DocumentSnapshot documentSnapshot) {
          if(documentSnapshot.exists){
            print(documentSnapshot.data());
            favorito = true;
          }
    });
    return favorito;
  }

  Future addAnunciosFavoritos() async {
    QuerySnapshot snapshotFavoritos;
    final idUsuarioLogado = await SharedPreferenceHelper().getIdUsuario();

    await db.collection("meus_anuncios")
        .doc(idUsuarioLogado)
        .collection("meus_favoritos")
        .get().then((QuerySnapshot querySnapshot) async* {
          for(DocumentSnapshot item in querySnapshot.docs){
            //print("000000000 " + item.data().toString());
            var dados = item.data();
            snapshotFavoritos = await db.collection("anuncios")
                .where("id", isEqualTo: dados["idAnuncioFavorito"])
                .get();
            yield snapshotFavoritos;
          }
    });
    //print("000000001 " + snapshotFavoritos.docs.toString());
    //for(DocumentSnapshot item2 in snapshotFavoritos){
    //  var dados2 = item2.data();
    //  print("TESTE NO FINAL DO METODO " + dados2.toString());
    //}

    //print("AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA");
    //return snapshotFavoritos;
  }

}