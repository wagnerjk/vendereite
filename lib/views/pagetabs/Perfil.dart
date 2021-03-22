import 'package:app_vendas/services/AuthenticationProvider.dart';
import 'package:app_vendas/views/EditProfile.dart';
import 'package:app_vendas/views/MeusAnuncios.dart';
import 'package:app_vendas/views/widgets/HeaderContainer.dart';
import 'package:app_vendas/views/widgets/ListTileCustomizado.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:provider/provider.dart';

class Perfil extends StatefulWidget {
  @override
  _PerfilState createState() => _PerfilState();
}

class _PerfilState extends State<Perfil> {
  String nome;

  _dialogDeleteAccountPassword() {
    TextEditingController controllerSenha = TextEditingController();

    AwesomeDialog(
        context: context,
        dialogType: DialogType.QUESTION,
        headerAnimationLoop: false,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Para excluir a conta, por favor informe a senha:"),
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
              .deleteAccount(controllerSenha.text)
              .then((_) {
            AwesomeDialog(
                context: context,
                dialogType: DialogType.SUCCES,
                headerAnimationLoop: false,
                title: "Deletar conta",
                desc: "Conta deletada com sucesso!",
                btnOkOnPress: () {
                  context.read<AuthenticationProvider>().signOut();
                })
              ..show();
          });
        })
      ..show();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: HeaderContainer(
        child: Container(
          width: double.infinity,
          child: Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 30.0, horizontal: 20.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Meu perfil",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 60),
                  ListTileCustomizao(
                    leading: AntDesign.user,
                    texto: "Editar perfil",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditProfile(),
                        ),
                      );
                    },
                  ),
                  Divider(),
                  ListTileCustomizao(
                    leading: AntDesign.deleteuser,
                    texto: "Deletar conta",
                    onTap: () {
                      _dialogDeleteAccountPassword();
                    },
                  ),
                  Divider(),
                  ListTileCustomizao(
                    leading: AntDesign.filetext1,
                    texto: "Meus anúncios",
                    onTap: (){
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MeusAnuncios(),
                        ),
                      );
                    },
                  ),
                  Divider(height: 20),
                  SizedBox(height: 60),
                  Center(
                    child: OutlinedButton.icon(
                      icon: Icon(
                        AntDesign.poweroff,
                        color: Colors.black,
                      ),
                      label: Text(
                        "Sair",
                        style: TextStyle(fontSize: 18, color: Colors.black),
                      ),
                      style: OutlinedButton.styleFrom(
                        primary: Colors.black,
                        padding:
                            EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                        side: BorderSide(
                          color: Colors.black,
                        ),
                      ),
                      onPressed: () {
                        context.read<AuthenticationProvider>().signOut();
                      },
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
