import 'dart:async';

import 'package:app_vendas/views/widgets/HeaderContainer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../helpers/SharedPrefsHelper.dart';
import '../../models/Anuncio.dart';
import '../../services/DatabaseMethods.dart';
import '../DetalhesAnuncio.dart';
import '../widgets/ItemAnuncio.dart';

class Favoritos extends StatefulWidget {
  @override
  _FavoritosState createState() => _FavoritosState();
}

class _FavoritosState extends State<Favoritos> {
  String _idUsuarioLogado;
  QuerySnapshot _anunciosFavoritos;
  final _controller = StreamController<QuerySnapshot>.broadcast();

  _addQueryAnuncios() async {
    _idUsuarioLogado = await SharedPreferenceHelper().getIdUsuario();
    print("idddddd" + _idUsuarioLogado.toString());
    //_anunciosFavoritos = await DatabaseMethods().addListenerAnunciosFavoritos(_idUsuarioLogado);
    //print(_anunciosFavoritos.docs.length.toString());
    //setState(() { });
  }

  @override
  void initState() {
    super.initState();
    //_addQueryAnuncios();
    //_addListenerAnunciosFavoritos();
  }

  @override
  void dispose() {
    _controller.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: HeaderContainer(
        child: Container(
          margin: EdgeInsets.only(left: 6, right: 6, top: 20),
          child: Column(
            children: [
              FutureBuilder(
                //future: _addListenerAnunciosFavoritos(),
                future: DatabaseMethods().addListenerAnunciosFavoritos(),
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.none:
                    case ConnectionState.waiting:
                      return Center(
                        child: Column(
                          children: [
                            CircularProgressIndicator(),
                            Text("Carregando anúncios...")
                          ],
                        ),
                      );
                    case ConnectionState.active:
                    case ConnectionState.done:
                      QuerySnapshot querySnapshot = snapshot.data;

                      if (querySnapshot.docs.length == 0) {
                        return Container(
                          padding: EdgeInsets.all(25),
                          child: Text(
                            "Sem anúncios...",
                            style: TextStyle(fontSize: 20),
                          ),
                        );
                      }

                      return Expanded(
                        child: ListView.builder(
                          physics: BouncingScrollPhysics(),
                          itemCount: querySnapshot.docs.length,
                          itemBuilder: (_, index) {
                            List<DocumentSnapshot> anuncios = querySnapshot.docs.toList();
                            DocumentSnapshot documentSnapshot = anuncios[index];
                            Anuncio anuncio =
                            Anuncio.fromDocumentSnaphot(documentSnapshot);

                            return ItemAnuncio(
                              anuncio: anuncio,
                              onTapItem: () {
                                print(anuncio.fotos.toString());
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => DetalhesAnuncio(
                                      anuncio: anuncio,
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      );
                  }
                  return Container();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
