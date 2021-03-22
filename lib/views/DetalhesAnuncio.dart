import 'package:app_vendas/helpers/DateFormat.dart';
import 'package:app_vendas/models/Anuncio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

import '../helpers/SharedPrefsHelper.dart';
import '../services/DatabaseMethods.dart';
import '../services/DatabaseMethods.dart';

class DetalhesAnuncio extends StatefulWidget {
  final Anuncio anuncio;

  const DetalhesAnuncio({Key key, this.anuncio}) : super(key: key);

  @override
  _DetalhesAnuncioState createState() => _DetalhesAnuncioState();
}

class _DetalhesAnuncioState extends State<DetalhesAnuncio> {
  Anuncio anuncio;
  bool _isFavorito = false;
  String _idUsuarioLogado;

  _manageFavoritos() async {


    if (_isFavorito) {
      await DatabaseMethods().addAnuncioFavorito(anuncio.id, _idUsuarioLogado);
    } else {
      await DatabaseMethods()
          .removeAnuncioFavorito(anuncio.id, _idUsuarioLogado);
    }
  }

  _verificaFavorito() async {
    _idUsuarioLogado = await SharedPreferenceHelper().getIdUsuario();

    _isFavorito = await DatabaseMethods()
        .verificaAnuncioFavorito(anuncio.id, _idUsuarioLogado);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    anuncio = widget.anuncio;
    _verificaFavorito();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Container(
        margin: EdgeInsets.only(left: 12, right: 12),
        height: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        child: Column(
          children: [
            SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: Icon(AntDesign.arrowleft),
                      color: Theme.of(context).primaryColor,
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    Text(
                      "Anúncio",
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    )
                  ],
                ),
                IconButton(
                  padding: EdgeInsets.only(right: 16),
                  icon: Icon(_isFavorito ? AntDesign.heart : AntDesign.hearto),
                  color: Colors.red,
                  onPressed: () {
                    setState(() {
                      _isFavorito = !_isFavorito;
                    });
                    _manageFavoritos();
                  },
                ),
              ],
            ),
            Expanded(
              child: Stack(
                children: [
                  ListView(
                    padding: EdgeInsets.all(0),
                    children: [
                      Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildCarouselImagens(),
                            SizedBox(height: 16),
                            Text(
                              anuncio.titulo,
                              style: TextStyle(
                                fontSize: 24,
                              ),
                            ),
                            SizedBox(height: 12),
                            Text(
                              "R\$ ${anuncio.preco}",
                              style: TextStyle(
                                fontSize: 28,
                              ),
                            ),
                            SizedBox(height: 12),
                            Text(
                              "Publicado em ${FormataData.formatData(anuncio.data, false)} às ${FormataData.formatHora(anuncio.data)}",
                              style: TextStyle(
                                fontSize: 14,
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 16.0),
                              child: Divider(),
                            ),
                            Text(
                              "Descrição",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 12),
                            Text(
                              anuncio.descricao,
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 16.0),
                              child: Divider(),
                            ),
                            Text(
                              "Localização",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 12),
                            Text(
                              "CEP ${anuncio.cep}",
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              anuncio.endereco,
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCarouselImagens() {
    return Column(
      children: [
        Container(
          height: 300,
          width: double.infinity,
          child: Swiper(
            itemCount: anuncio.fotos.length,
            viewportFraction: 0.8,
            scale: 0.9,
            //layout: SwiperLayout.TINDER,
            pagination: SwiperPagination(
              builder: const DotSwiperPaginationBuilder(
                size: 10.0,
                activeSize: 14.0,
                space: 6.0,
              ),
            ),
            itemBuilder: (context, index) {
              if (anuncio.fotos.isEmpty) {
                return Container(
                  color: Colors.grey[200],
                  height: 200,
                  width: 300,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Sem imagens",
                        style: TextStyle(
                          color: Colors.grey[600],
                        ),
                      ),
                      Stack(
                        children: [
                          Icon(
                            AntDesign.camerao,
                            size: 50,
                            color: Colors.grey,
                          ),
                          Icon(
                            AntDesign.close,
                            size: 50,
                            color: Colors.grey,
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              }
              if (anuncio.fotos.length > 0) {
                return GestureDetector(
                  onTap: () {},
                  child: Container(
                    height: 200,
                    width: 300,
                    child: Image.network(
                      anuncio.fotos[index],
                      fit: BoxFit.cover,
                    ),
                  ),
                );
              }
              return Container();
            },
          ),
        ),
      ],
    );
  }
}
