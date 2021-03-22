import 'package:app_vendas/helpers/ImagePickerHelper.dart';
import 'package:app_vendas/helpers/SharedPrefsHelper.dart';
import 'package:app_vendas/models/Usuario.dart';
import 'package:app_vendas/services/AuthenticationProvider.dart';
import 'package:app_vendas/services/DatabaseMethods.dart';
import 'package:app_vendas/views/widgets/CircleAvatarCustomizado.dart';
import 'package:app_vendas/views/widgets/ElevatedButtonCustomizado.dart';
import 'package:app_vendas/views/widgets/HeaderContainer.dart';
import 'package:app_vendas/views/widgets/InputCustomizado.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:provider/provider.dart';
import 'dart:io';

class EditProfile extends StatefulWidget {
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  TextEditingController _controllerNome = TextEditingController();
  TextEditingController _controllerEmail = TextEditingController();
  FocusNode focusNome;
  FocusNode focusEmail;
  final _formKey = GlobalKey<FormState>();
  Usuario _usuario = new Usuario();
  File _image;
  String _urlImagemUsuario = "";
  String _idUsuario = "";

  _changeButtonController() async {
    Map<String, dynamic> dadosNovos = {};

    if (_controllerNome.text != _usuario.nome) {
      dadosNovos.addAll({"nome": _controllerNome.text});
    }
    if (_controllerEmail.text != _usuario.email) {
      _dialogChangeEmailPassword();
      dadosNovos.addAll({"email": _controllerEmail.text});
    }
    if (_image != null) {
      String url =
          await DatabaseMethods().uploadImagemPerfil(_idUsuario, _image);
      dadosNovos.addAll({"urlImagemPerfil": url});
    }
    print(dadosNovos.toString());
    await DatabaseMethods().updateDataDB(_idUsuario, dadosNovos);
    await _getUserInfos();
  }

  _dialogChangeEmailPassword() {
    TextEditingController controllerSenha = TextEditingController();

    AwesomeDialog(
        context: context,
        dialogType: DialogType.QUESTION,
        headerAnimationLoop: false,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Para completar essa operação, por favor informe a senha:"),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                  controller: controllerSenha,
                  obscureText: true,
                  keyboardType: TextInputType.emailAddress,
                  textAlign: TextAlign.center),
            )
          ],
        ),
        btnCancelOnPress: () {},
        btnOkOnPress: () {
          context
              .read<AuthenticationProvider>()
              .updateEmailAuth(_controllerEmail.text, controllerSenha.text)
              .then((_) {
            AwesomeDialog(
                context: context,
                dialogType: DialogType.SUCCES,
                headerAnimationLoop: false,
                title: "Alteração de e-mail",
                desc: "E-mail alterado com sucesso!",
                btnOkOnPress: () {})
              ..show();
          });
        })
      ..show();
  }

  Future _setImage() async {
    _image = await ImagePickerHelper().getImage();
    setState(() {});
  }

  _getUserInfos() async {
    _idUsuario = await SharedPreferenceHelper().getIdUsuario();
    _usuario = await DatabaseMethods().getUserDetails(_idUsuario);
    SharedPreferenceHelper().saveNomeUsuario(_usuario.nome);
    SharedPreferenceHelper().saveUrlImagemUsuario(_usuario.urlImagemPerfil);

    _controllerNome.text = _usuario.nome;
    _controllerEmail.text = _usuario.email;
    _urlImagemUsuario = _usuario.urlImagemPerfil;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();

    focusNome = FocusNode();
    focusEmail = FocusNode();
    _getUserInfos();
  }

  @override
  void dispose() {
    focusNome.dispose();
    focusEmail.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: HeaderContainer(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: 30),
                  Center(
                    child: CircleAvatarCustomizado(
                      onTap: () {
                        _setImage();
                      },
                      image: _image,
                      url: _urlImagemUsuario,
                    ),
                  ),
                  SizedBox(height: 30),
                  InputCustomizado(
                    label: "Nome",
                    controller: _controllerNome,
                    focusNode: focusNome,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.text,
                    textCapitalization: TextCapitalization.words,
                    validator: RequiredValidator(errorText: "insira o nome!"),
                    onFieldSubmitted: (valor) {
                      focusNome.unfocus();
                      FocusScope.of(context).requestFocus(focusEmail);
                    },
                  ),
                  SizedBox(height: 10),
                  InputCustomizado(
                    label: "E-mail",
                    controller: _controllerEmail,
                    focusNode: focusEmail,
                    textInputAction: TextInputAction.done,
                    keyboardType: TextInputType.emailAddress,
                    validator:
                        EmailValidator(errorText: "Insira um e-mail válido!"),
                    onFieldSubmitted: (valor) {
                      focusEmail.unfocus();
                    },
                  ),
                  SizedBox(height: 14),
                  ElevatedButtonCustomizado(
                    text: "Alterar",
                    onPressed: () {
                      if (_formKey.currentState.validate()) {
                        _changeButtonController();
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
