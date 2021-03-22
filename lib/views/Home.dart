import 'package:app_vendas/views/pagetabs/Favoritos.dart';
import 'package:app_vendas/views/pagetabs/Mensagens.dart';
import 'package:app_vendas/views/pagetabs/PaginaInicial.dart';
import 'package:app_vendas/views/pagetabs/Perfil.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _paginaSelecionada = 0;
  List<Widget> _paginas = [PaginaInicial(), Favoritos(), Mensagens(), Perfil()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Container(
        child: _paginas[_paginaSelecionada],
      ),
      bottomNavigationBar: ConvexAppBar(
          items: [
            TabItem(icon: AntDesign.filetext1, title: "Anúncios"),
            TabItem(icon: AntDesign.hearto, title: "Favoritos"),
            //TabItem(icon: AntDesign.plus, title: "Novo"),
            TabItem(icon: AntDesign.message1, title: "Mensagens"),
            TabItem(icon: AntDesign.user, title: "Perfil"),
          ],
          height: 60,
          backgroundColor: Theme.of(context).primaryColor,
          color: Colors.white,
          elevation: 0,
          style: TabStyle.reactCircle,
          top: -20,
          initialActiveIndex: _paginaSelecionada,
          onTap: (index){
            setState(() {
              _paginaSelecionada = index;
            });
          },
      ),
    );
  }
}
