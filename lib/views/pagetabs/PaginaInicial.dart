import 'dart:async';

import 'package:app_vendas/services/DatabaseMethods.dart';
import 'package:app_vendas/views/widgets/HeaderContainer.dart';
import 'package:app_vendas/views/widgets/ProgressIndicatorCustomizado.dart';
import 'package:app_vendas/views/widgets/StreamBuilderAnuncios.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';

//import 'package:flutter/scheduler.dart' show timeDilation;
import '../NovoAnuncio.dart';

class PaginaInicial extends StatefulWidget {
  @override
  _PaginaInicialState createState() => _PaginaInicialState();
}

class _PaginaInicialState extends State<PaginaInicial> {
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();
  final _controller = StreamController<QuerySnapshot>.broadcast();

  Future<Stream<QuerySnapshot>> _addControllerListenerAnuncios() async {
    Stream<QuerySnapshot> stream =
        await DatabaseMethods().addListenerAnuncios();
    stream.listen((data) {
      _controller.add(data);
    });
  }

  @override
  void initState() {
    super.initState();
    _addControllerListenerAnuncios();
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
              StreamBuilderAnuncios(controller: _controller),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        foregroundColor: Colors.white,
        backgroundColor: Theme.of(context).primaryColor,
        icon: Icon(AntDesign.plus),
        label: Text("Anunciar agora"),
        onPressed: () {
          ProgressIndicatorCustomizado.showProgressIndicator(
              context, _keyLoader, "Aguarde...");
          Navigator.push(context,
                  MaterialPageRoute(builder: (context) => NovoAnuncio()))
              .whenComplete(() {
            Navigator.of(context, rootNavigator: true).pop();
          });
        },
      ),
    );
  }
}
