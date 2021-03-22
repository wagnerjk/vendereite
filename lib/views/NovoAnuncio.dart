import 'package:app_vendas/Consts/ListCategorias.dart';
import 'package:app_vendas/helpers/SharedPrefsHelper.dart';
import 'package:app_vendas/models/Anuncio.dart';
import 'package:app_vendas/services/DatabaseMethods.dart';
import 'package:app_vendas/services/ViaCepService.dart';
import 'package:app_vendas/views/widgets/ElevatedButtonCustomizado.dart';
import 'package:app_vendas/views/widgets/InputCustomizado.dart';
import 'package:app_vendas/views/widgets/ProgressIndicatorCustomizado.dart';
import 'package:app_vendas/views/widgets/SelectCategoriaDialog.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

class NovoAnuncio extends StatefulWidget {
  @override
  _NovoAnuncioState createState() => _NovoAnuncioState();
}

class _NovoAnuncioState extends State<NovoAnuncio> {
  final _formKey = GlobalKey<FormState>();
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();
  Anuncio _anuncio = Anuncio();
  TextEditingController _controllerEndereco = TextEditingController();
  TextEditingController _controllerCategoria = TextEditingController();
  FocusNode focusTitulo;
  FocusNode focusDescricao;
  FocusNode focusPreco;
  FocusNode focusCep;
  FocusNode focusTelefone;
  List<Asset> _listaImagens = [];
  BuildContext _dialogContext;
  int _categoriaSelecionada;
  String _categoria = "";

  final descricaoValidator = MultiValidator([
    RequiredValidator(errorText: "Campo obrigatório"),
    MaxLengthValidator(200, errorText: "Máximo 200 caracteres")
  ]);

  final cepValidator = MultiValidator([
    RequiredValidator(errorText: "Campo obrigatório"),
    MinLengthValidator(10, errorText: "Informe um CEP válido"),
  ]);

  Future _serchCep(String cep) async {
    final resultCep = await ViaCepService.fetchCep(cep: cep);

    if (resultCep != null) {
      if (resultCep.bairro != "") {
        setState(() {
          _controllerEndereco.text =
              "${resultCep.bairro}, ${resultCep.localidade}, ${resultCep.uf}";
        });
      } else {
        setState(() {
          _controllerEndereco.text = "${resultCep.localidade}, ${resultCep.uf}";
        });
      }
    }
  }

  Future _loadImagesNovoAnuncio() async {
    _listaImagens = await MultiImagePicker.pickImages(maxImages: 6);
    setState(() {});
  }

  _salvarAnuncio(BuildContext context) async {
    ProgressIndicatorCustomizado.showProgressIndicator(
        context, _keyLoader, "Salvando anúncio...");

    _anuncio.idUsuario = await SharedPreferenceHelper().getIdUsuario();
    _anuncio.data = DateTime.now().toString();

    if (_listaImagens != null) {
      _anuncio.fotos =
          await DatabaseMethods().saveImagesAnuncio(_anuncio.id, _listaImagens);
    }

    await DatabaseMethods().addAnuncioToDB(_anuncio);

    //Navigator.pop(_keyLoader.currentContext);
    Navigator.of(context, rootNavigator: true).pop();
    Navigator.pop(context);
  }

  _selectCategoria() {
    AwesomeDialog(
        context: _dialogContext,
        dialogType: DialogType.NO_HEADER,
        width: 480,
        body: SelectCategoriaDialog(
          categoriaSelecionada: _categoriaSelecionada,
          onValueChange: _onValueChange,
        ),
        btnCancelOnPress: () {
          setState(() {
            _categoriaSelecionada = null;
            _categoria = "";
          });
        },
        btnOkOnPress: () {
          setState(() {
            _categoria = ListCategorias.listaCategoria[_categoriaSelecionada];
          });
        },
        btnOkText: "Confirmar")
      ..show();
  }

  int _onValueChange(int value) {
    _categoriaSelecionada = value;
    return _categoriaSelecionada;
  }

  @override
  void initState() {
    super.initState();

    focusTitulo = FocusNode();
    focusDescricao = FocusNode();
    focusPreco = FocusNode();
    focusCep = FocusNode();
    focusTelefone = FocusNode();

    _anuncio = Anuncio.gerarId();
  }

  @override
  void dispose() {
    focusTitulo.dispose();
    focusDescricao.dispose();
    focusPreco.dispose();
    focusCep.dispose();
    focusTelefone.dispose();

    _controllerEndereco.dispose();
    _controllerCategoria.dispose();

    super.dispose();
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
              children: [
                IconButton(
                  icon: Icon(AntDesign.arrowleft),
                  color: Theme.of(context).primaryColor,
                  onPressed: (){
                    Navigator.pop(context);
                  },
                ),
                Text(
                  "Cadastrar anúncio",
                  style:
                  TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SizedBox(height: 12),
                        _buildSelectImagens(),
                        SizedBox(height: 15),
                        InputCustomizado(
                          label: "Título do anúncio*",
                          focusNode: focusTitulo,
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.text,
                          textCapitalization: TextCapitalization.sentences,
                          validator:
                              RequiredValidator(errorText: "Campo obrigatório"),
                          onSaved: (titulo) {
                            _anuncio.titulo = titulo;
                          },
                          onFieldSubmitted: (_) {
                            focusTitulo.unfocus();
                            FocusScope.of(context).requestFocus(focusDescricao);
                          },
                        ),
                        SizedBox(height: 10),
                        InputCustomizado(
                          label: "Descrição*",
                          focusNode: focusDescricao,
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.text,
                          textCapitalization: TextCapitalization.sentences,
                          maxLines: null,
                          maxLength: 200,
                          validator: descricaoValidator,
                          onSaved: (descricao) {
                            _anuncio.descricao = descricao;
                          },
                          onFieldSubmitted: (_) {
                            focusDescricao.unfocus();
                          },
                        ),
                        SizedBox(height: 10),
                        _buildFormCategoria(context),
                        SizedBox(height: 10),
                        InputCustomizado(
                          label: "Preço*",
                          focusNode: focusPreco,
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.number,
                          validator:
                              RequiredValidator(errorText: "Campo obrigatório"),
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            RealInputFormatter(centavos: true),
                          ],
                          onSaved: (preco) {
                            _anuncio.preco = preco;
                          },
                          onFieldSubmitted: (_) {
                            focusPreco.unfocus();
                            FocusScope.of(context).requestFocus(focusCep);
                          },
                        ),
                        SizedBox(height: 10),
                        InputCustomizado(
                          label: "CEP*",
                          focusNode: focusCep,
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.number,
                          validator: cepValidator,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            CepInputFormatter()
                          ],
                          onChanged: (cep) {
                            if (cep.length == 10) {
                              _serchCep(
                                  cep.replaceAll(".", "").replaceAll("-", ""));
                            }
                          },
                          onSaved: (cep) {
                            _anuncio.cep = cep;
                          },
                          onFieldSubmitted: (valor) {
                            focusCep.unfocus();
                            FocusScope.of(context).requestFocus(focusTelefone);
                          },
                        ),
                        SizedBox(height: 10),
                        InputCustomizado(
                            label: "Endereço",
                            controller: _controllerEndereco,
                            enabled: false,
                            onSaved: (endereco) {
                              _anuncio.endereco = endereco;
                            }),
                        SizedBox(height: 10),
                        InputCustomizado(
                          label: "Telefone",
                          focusNode: focusTelefone,
                          textInputAction: TextInputAction.done,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            TelefoneInputFormatter()
                          ],
                          onSaved: (telefone) {
                            _anuncio.telefone = telefone;
                          },
                          onFieldSubmitted: (_) {
                            focusTelefone.unfocus();
                          },
                        ),
                        SizedBox(height: 10),
                        ElevatedButtonCustomizado(
                          text: "Cadastrar",
                          onPressed: () {
                            if (_formKey.currentState.validate()) {
                              _formKey.currentState.save();
                              _dialogContext = context;
                              _salvarAnuncio(context);
                            }
                          },
                        ),
                        SizedBox(height: 30),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  FormField<int> _buildFormCategoria(BuildContext context) {
    return FormField<int>(
      initialValue: _categoriaSelecionada,
      validator: (_) {
        if (_categoriaSelecionada == null) {
          return "Selecione uma categoria";
        }
        return null;
      },
      onSaved: (_) {
        _anuncio.categoria = _categoria;
      },
      builder: (state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            OutlinedButton(
              onPressed: () {
                _dialogContext = context;
                _selectCategoria();
              },
              style: OutlinedButton.styleFrom(
                padding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                backgroundColor: Colors.white,
                side: BorderSide(
                    color: state.hasError ? Colors.red[700] : Colors.grey[700],
                    width: 1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _categoriaSelecionada != null ? _categoria : "Categoria",
                    style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                  ),
                  Icon(
                    AntDesign.right,
                    color: Colors.grey[700],
                    size: 16,
                  ),
                ],
              ),
            ),
            if (state.hasError)
              Container(
                padding: EdgeInsets.only(left: 32),
                child: Text(
                  "${state.errorText}",
                  style: TextStyle(color: Colors.red[700], fontSize: 12),
                ),
              ),
          ],
        );
      },
    );
  }

  Widget _buildSelectImagens() {
    return Column(
      children: [
        Container(
          height: 200,
          width: double.infinity,
          child: Swiper(
            itemCount: _listaImagens.length + 1,
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
              if (index == _listaImagens.length) {
                return GestureDetector(
                  onTap: () {
                    _loadImagesNovoAnuncio();
                  },
                  child: Container(
                    color: Colors.grey[200],
                    height: 200,
                    width: 300,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.add_a_photo_outlined,
                          size: 100,
                          color: Colors.grey,
                        ),
                        Text(
                          "Selecionar imagens \n(máximo 6)",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.grey,
                          ),
                        )
                      ],
                    ),
                  ),
                );
              }
              if (_listaImagens.length > 0) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _listaImagens.removeAt(index);
                    });
                  },
                  child: AssetThumb(
                    asset: _listaImagens[index],
                    height: 200,
                    width: 300,
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
