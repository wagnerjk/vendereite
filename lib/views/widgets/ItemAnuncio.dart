import 'package:app_vendas/helpers/DateFormat.dart';
import 'package:app_vendas/models/Anuncio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';

class ItemAnuncio extends StatelessWidget {
  final Anuncio anuncio;
  final VoidCallback onTapItem;

  ItemAnuncio({@required this.anuncio, this.onTapItem});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: this.onTapItem,
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 130,
              height: 130,
              child: anuncio.fotos.isEmpty
                  ? Container(
                      color: Colors.grey[200],
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
                    )
                  : Image.network(
                      anuncio.fotos[0],
                      fit: BoxFit.cover,
                    ),
            ),
            Expanded(
              flex: 3,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                child: Container(
                  child: Column(
                    //mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        anuncio.titulo,
                        style: TextStyle(
                          fontSize: 14,
                          //fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 30),
                      Text(
                        "R\$ ${anuncio.preco}",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 28),
                      Text(
                        "${FormataData.formatData(anuncio.data, true)} ${FormataData.formatHora(anuncio.data)}",
                        style: TextStyle(
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
