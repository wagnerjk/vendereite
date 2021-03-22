import 'dart:io';

import 'package:app_vendas/helpers/ImagePickerHelper.dart';
import 'package:app_vendas/models/Usuario.dart';
import 'package:app_vendas/services/AuthenticationProvider.dart';
import 'package:app_vendas/views/widgets/CircleAvatarCustomizado.dart';
import 'package:app_vendas/views/widgets/ElevatedButtonCustomizado.dart';
import 'package:app_vendas/views/widgets/InputCustomizado.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:provider/provider.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  FocusNode focusNome;
  FocusNode focusEmail;
  FocusNode focusSenha;

  final _formKey = GlobalKey<FormState>();
  Usuario _usuario = new Usuario();

  bool _isObscure = true;
  bool _isSignUp = false;
  File _image;

  final emailValidator = MultiValidator([
    RequiredValidator(errorText: "Insira o e-mail!"),
    EmailValidator(errorText: "Insira um e-mail válido!")
  ]);

  final senhaValidator = MultiValidator([
    RequiredValidator(errorText: "Insira a senha!"),
    MinLengthValidator(6, errorText: "A senha deve conter no mínimo 6 caracteres!")
  ]);

  _signInSignUpButtonController() async {
    if (!_isSignUp) {
      context.read<AuthenticationProvider>().signIn(_usuario);
    } else {
      context.read<AuthenticationProvider>().signUp(_usuario, image: _image);
    }
  }

  Future _setImage() async {
    _image = await ImagePickerHelper().getImage();
    setState(() {});
  }

  _dialogResetPassword(){
    TextEditingController controllerEmail = TextEditingController();

    AwesomeDialog(
      context: context,
      dialogType: DialogType.QUESTION,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Por favor insira o seu e-mail:"
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: TextField(
              controller: controllerEmail,
              keyboardType: TextInputType.emailAddress,
              textAlign: TextAlign.center
            ),
          )
        ],
      ),
      btnCancelOnPress: (){},
      btnOkOnPress: (){
        context.read<AuthenticationProvider>().sendPasswordResetEmail(
            controllerEmail.text).then((_) {
              AwesomeDialog(
                context: context,
                dialogType: DialogType.SUCCES,
                title: "Alteração da senha",
                desc: "Um e-mail foi enviado para a sua conta!",
                btnOkOnPress: (){}
              )..show();
        });
      }
    )..show();
  }

  @override
  void initState() {
    super.initState();

    focusNome = FocusNode();
    focusEmail = FocusNode();
    focusSenha = FocusNode();
  }

  @override
  void dispose() {
    focusNome.dispose();
    focusEmail.dispose();
    focusSenha.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Container(
        margin:
            EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.257,
                            left: 12, right: 12),
        height: MediaQuery.of(context).size.height * 0.8,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(50), topLeft: Radius.circular(50)),
        ),
        child: Padding(
          padding:
              const EdgeInsets.symmetric(horizontal: 16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _isSignUp
                    ? SizedBox(height: 0, width: 0,)
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          SizedBox(height: 30),
                          Center(
                              child: Text(
                            "Acesse a sua conta",
                            style: TextStyle(fontSize: 18),
                          )),
                          SizedBox(
                            height: 14,
                          ),
                          ElevatedButton.icon(
                            icon: SvgPicture.asset(
                              "assets/images/google_icon.svg",
                              width: 25,
                              height: 25,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              context
                                  .read<AuthenticationProvider>()
                                  .signInWithGoogle(context);
                            },
                            style: OutlinedButton.styleFrom(
                                backgroundColor: Colors.red,
                                padding: EdgeInsets.symmetric(vertical: 16),
                                side: BorderSide(color: Colors.red),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(6))),
                            label: Text("Entrar com o Google",
                                style: TextStyle(
                                    fontSize: 18, color: Colors.white)),
                          ),
                          SizedBox(
                            height: 40,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                height: 0.5,
                                width: 120,
                                color: Colors.grey,
                                margin: EdgeInsets.only(right: 20),
                              ),
                              Text(
                                "ou",
                                style: TextStyle(
                                    fontSize: 16, color: Colors.grey),
                              ),
                              Container(
                                height: 0.5,
                                width: 120,
                                color: Colors.grey,
                                margin: EdgeInsets.only(left: 20),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 40,
                          ),
                          Center(
                              child: Text(
                            "Acesse com seu e-mail",
                            style: TextStyle(fontSize: 18),
                          )),
                          SizedBox(
                            height: 14,
                          ),
                        ],
                      ),
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _isSignUp
                          ? Column(
                            children: [
                              SizedBox(height: 30),
                              Center(
                                child: CircleAvatarCustomizado(
                                  onTap: (){
                                    _setImage();
                                  },
                                  image: _image,
                                ),
                              ),
                              SizedBox(height: 30),
                              InputCustomizado(
                                label: "Nome",
                                focusNode: focusNome,
                                validator: RequiredValidator(
                                    errorText: "insira o nome!"),
                                textInputAction: TextInputAction.next,
                                keyboardType: TextInputType.text,
                                textCapitalization: TextCapitalization.words,
                                onSaved: (nome){
                                  _usuario.nome = nome;
                                },
                                onFieldSubmitted: (_) {
                                  focusNome.unfocus();
                                  FocusScope.of(context)
                                      .requestFocus(focusEmail);
                                },
                              ),
                              SizedBox(
                                height: 10,
                              ),
                            ],
                          )
                        : SizedBox(height: 0, width: 0,),
                      InputCustomizado(
                        label: "E-mail",
                        focusNode: focusEmail,
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.emailAddress,
                        validator: emailValidator,
                        onSaved: (email){
                          _usuario.email = email;
                        },
                        onFieldSubmitted: (_) {
                          focusEmail.unfocus();
                          FocusScope.of(context).requestFocus(focusSenha);
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      InputCustomizado(
                        label: "Senha",
                        focusNode: focusSenha,
                        obscure: _isObscure,
                        textInputAction: TextInputAction.done,
                        keyboardType: TextInputType.visiblePassword,
                        validator: senhaValidator,
                        onSaved: (senha){
                          _usuario.senha = senha;
                        },
                        onFieldSubmitted: (_) {
                          focusSenha.unfocus();
                        },
                        sufixIcon: GestureDetector(
                          onTap: () {
                            setState(() {
                              _isObscure = !_isObscure;
                            });
                          },
                          child: Icon(_isObscure
                              ? Icons.visibility
                              : Icons.visibility_off),
                        ),
                      ),
                      !_isSignUp
                        ? Align(
                          alignment: Alignment.topRight,
                          child: TextButton(
                              onPressed: _dialogResetPassword,
                              child: Text(
                                "Esqueci minha senha",
                                style: TextStyle(color: Colors.black),
                              )),
                        )
                        : SizedBox(height: 30),
                      ElevatedButtonCustomizado(
                        text: _isSignUp ? "Cadastrar" : "Entrar",
                        onPressed: () {
                          if(_formKey.currentState.validate()){
                            _formKey.currentState.save();
                            _signInSignUpButtonController();
                          }
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 14),
                TextButton(
                  onPressed: () {
                    setState(() {
                      _isSignUp = !_isSignUp;
                    });
                  },
                  child: Text(
                      _isSignUp
                          ? "Já possui conta? Entre aqui!"
                          : "Ainda não possui conta? Cadastre-se aqui!",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                      )),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
