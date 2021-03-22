import 'package:app_vendas/Consts/ListCategorias.dart';
import 'package:flutter/material.dart';

class SelectCategoriaDialog extends StatefulWidget {
  final Function(int) onValueChange;
  final int categoriaSelecionada;

  const SelectCategoriaDialog({Key key, this.onValueChange, this.categoriaSelecionada}) : super(key: key);

  @override
  _SelectCategoriaDialogState createState() => _SelectCategoriaDialogState();
}

class _SelectCategoriaDialogState extends State<SelectCategoriaDialog> {
  int _categoriaSelecionada;

  @override
  void initState() {
    super.initState();
    _categoriaSelecionada = widget.categoriaSelecionada;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: [
          Text("Selecione a categoria:"),
          Divider(),
          ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.4,
            ),
            child: ListView.builder(
                shrinkWrap: true,
                itemCount: ListCategorias.listaCategoria.length,
                itemBuilder: (context, index) {
                  return RadioListTile(
                      title: Text(ListCategorias.listaCategoria[index]),
                      value: index,
                      //groupValue: widget.categoriaSelecionada != null ? widget.categoriaSelecionada : _categoriaSelecionada,
                      //groupValue: widget.categoriaSelecionada != _categoriaSelecionada ? widget.categoriaSelecionada : _categoriaSelecionada,
                      groupValue: _categoriaSelecionada,
                      //onChanged: widget.onValueChange(index),
                      onChanged: (value){
                        setState(() {
                          //_categoriaSelecionada = value;
                          _categoriaSelecionada = widget.onValueChange(value);

                        });
                      }

                      );
                }),
          )
        ],
      ),
    );
  }
}
