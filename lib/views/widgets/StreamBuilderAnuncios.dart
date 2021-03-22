import 'dart:async';

import 'package:app_vendas/models/Anuncio.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../DetalhesAnuncio.dart';
import 'ItemAnuncio.dart';

class StreamBuilderAnuncios extends StatelessWidget {
  final StreamController<QuerySnapshot> controller;

  const StreamBuilderAnuncios({Key key, this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: this.controller.stream,
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
    );
  }
}
