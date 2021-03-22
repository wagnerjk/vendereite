
import 'package:cloud_firestore/cloud_firestore.dart';

class Anuncio{
  String _id;
  String _idUsuario;
  String _titulo;
  String _descricao;
  String _categoria;
  String _preco;
  String _cep;
  String _endereco;
  String _telefone;
  String _data;
  List<String> _fotos;

  Anuncio();

  Anuncio.gerarId() {
    CollectionReference anuncios = FirebaseFirestore.instance.collection("meus_anuncios");
    this.id = anuncios.doc().id;
    this.fotos = [];
  }

  Anuncio.fromDocumentSnaphot(DocumentSnapshot documentSnapshot){
    this.id        = documentSnapshot.id;
    this.idUsuario = documentSnapshot["idUsuario"];
    this.titulo    = documentSnapshot["titulo"];
    this.descricao = documentSnapshot["descricao"];
    this.categoria = documentSnapshot["categoria"];
    this.preco     = documentSnapshot["preco"];
    this.cep       = documentSnapshot["cep"];
    this.endereco  = documentSnapshot["endereco"];
    this.telefone  = documentSnapshot["telefone"];
    this.data      = documentSnapshot["data"];
    this.fotos     = List<String>.from(documentSnapshot["fotos"]);
  }

  Map<String, dynamic> toMap(){
    Map<String, dynamic> map = {
      "id"        : this.id,
      "idUsuario" : this.idUsuario,
      "titulo"    : this.titulo,
      "descricao" : this.descricao,
      "categoria" : this.categoria,
      "preco"     : this.preco,
      "cep"       : this.cep,
      "endereco"  : this.endereco,
      "telefone"  : this.telefone,
      "data"      : this.data,
      "fotos"     : this.fotos,
    };
    return map;
  }

  String get idUsuario => _idUsuario;

  set idUsuario(String value) {
    _idUsuario = value;
  }

  String get telefone => _telefone;

  set telefone(String value) {
    _telefone = value;
  }

  List<String> get fotos => _fotos;

  set fotos(List<String> value) {
    _fotos = value;
  }

  String get data => _data;

  set data(String value) {
    _data = value;
  }

  String get endereco => _endereco;

  set endereco(String value) {
    _endereco = value;
  }

  String get cep => _cep;

  set cep(String value) {
    _cep = value;
  }

  String get preco => _preco;

  set preco(String value) {
    _preco = value;
  }

  String get categoria => _categoria;

  set categoria(String value) {
    _categoria = value;
  }

  String get descricao => _descricao;

  set descricao(String value) {
    _descricao = value;
  }

  String get titulo => _titulo;

  set titulo(String value) {
    _titulo = value;
  }

  String get id => _id;

  set id(String value) {
    _id = value;
  }
}