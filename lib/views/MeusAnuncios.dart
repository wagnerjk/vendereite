import 'dart:async';

import 'package:app_vendas/services/DatabaseMethods.dart';
import 'package:app_vendas/views/widgets/HeaderContainer.dart';
import 'package:app_vendas/views/widgets/StreamBuilderAnuncios.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

//import 'package:flutter/scheduler.dart' show timeDilation;

class MeusAnuncios extends StatefulWidget {
  @override
  _MeusAnunciosState createState() => _MeusAnunciosState();
}

class _MeusAnunciosState extends State<MeusAnuncios> {
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();
  final _controller = StreamController<QuerySnapshot>.broadcast();

  Future<Stream<QuerySnapshot>> _addControllerListenerAnuncios() async {
    Stream<QuerySnapshot> stream =
        await DatabaseMethods().addListenerMeusAnuncios();
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
    );
  }
}
