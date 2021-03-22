import 'dart:io';

import 'package:app_vendas/helpers/SharedPrefsHelper.dart';
import 'package:app_vendas/models/Usuario.dart';
import 'package:app_vendas/services/DatabaseMethods.dart';
import 'package:app_vendas/views/widgets/SnackBarCustomizado.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthenticationProvider{

  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  String email = "";

  AuthenticationProvider();
  //AuthenticationProvider(this.firebaseAuth);

  Stream<User> get authState => firebaseAuth.idTokenChanges();

  getCurrentUser() async {
    return firebaseAuth.currentUser;
  }

  signInWithGoogle(BuildContext context) async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final GoogleSignIn googleSignIn = GoogleSignIn();

    final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();

    final GoogleSignInAuthentication googleSignInAuthentication = await
      googleSignInAccount.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
      idToken: googleSignInAuthentication.idToken,
      accessToken: googleSignInAuthentication.accessToken
    );

    UserCredential result = await auth.signInWithCredential(credential);

    User userDetais = result.user;

    if(result != null){
      Usuario usuario = Usuario();
      usuario.idUsuario = userDetais.uid;
      usuario.nome = userDetais.displayName;
      usuario.email = userDetais.email;
      usuario.urlImagemPerfil = userDetais.photoURL;

      SharedPreferenceHelper().saveUsuario(usuario);

      DatabaseMethods().addUsuarioToDB(usuario.idUsuario, usuario.toMap());
    }
  }

  Future signUp(Usuario usuario, {File image}) async {
    String caminhoImagem = "";
    try {
      await firebaseAuth.createUserWithEmailAndPassword(
          email: usuario.email,
          password: usuario.senha
      ).then((firebaseUser) async {
        usuario.idUsuario = firebaseUser.user.uid;
        if(image != null){
          caminhoImagem = await DatabaseMethods().uploadImagemPerfil(
              firebaseUser.user.uid,
              image);
          usuario.urlImagemPerfil = caminhoImagem;
        } else {
          usuario.urlImagemPerfil = "";
        }
        SharedPreferenceHelper().saveUsuario(usuario);
        DatabaseMethods().addUsuarioToDB(firebaseUser.user.uid, usuario.toMap());
      });
      return "Signed up!";
    } on FirebaseAuthException catch (e) {
      return SnackBarCustomizado(texto: "Erro ao criar cadastro! ${e.message}",);
    }
  }

  Future<String> signIn(Usuario usuario) async {
    try {
      await firebaseAuth.signInWithEmailAndPassword(
          email: usuario.email, password: usuario.senha).then((firebaseUser) async {
            usuario = await DatabaseMethods().getUserDetails(firebaseUser.user.uid);
            usuario.idUsuario = firebaseUser.user.uid;
            usuario.email = firebaseUser.user.email;
            SharedPreferenceHelper().saveUsuario(usuario);
      });
      return "Signed in!";
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  Future sendPasswordResetEmail(String email) async {
    await firebaseAuth.sendPasswordResetEmail(email: email);
  }

  Future reauthenticatingUser(String senha) async {
    email = await SharedPreferenceHelper().getEmailUsuario();
    print(email);
    EmailAuthCredential credential = EmailAuthProvider.credential(email: email, password: senha);
    await FirebaseAuth.instance.currentUser.reauthenticateWithCredential(credential);
  }

  Future updateEmailAuth(String emailNovo, String senha) async {
    var user = firebaseAuth.currentUser;
    reauthenticatingUser(senha).then((_) {
      user.updateEmail(emailNovo).then((_) {
        SharedPreferenceHelper().saveEmailUsuario(emailNovo);
      });
    });
  }

  Future deleteAccount(String senha) async {
    var user = firebaseAuth.currentUser;
    String id = user.uid;
    try {
      reauthenticatingUser(senha).then((_) async {
        await DatabaseMethods().deleteUserData(id).then((_) async {
          await user.delete();
        });
      });
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  Future<void> signOut() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
    await firebaseAuth.signOut();
  }

}