import 'package:flutter/material.dart';

class ProgressIndicatorCustomizado {
  static Future<void> showProgressIndicator(
      BuildContext context, GlobalKey key, String texto) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, //nao deixa usuario clicar fora
      builder: (BuildContext context) {
        return new WillPopScope(
          onWillPop: () async => false,
          child: SimpleDialog(
            key: key,
            backgroundColor: Colors.white,
            children: <Widget>[
              Center(
                child: Column(children: [
                  CircularProgressIndicator(),
                  SizedBox(
                    height: 20,
                  ),
                  Text(texto)
                ]),
              ),
            ],
          ),
        );
      },
    );
    /*return AlertDialog(
            key: key,
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 20,),
                Text("Salvando anúncio...")
              ],
            ),
          );
        }
    );

           */
  }
}
