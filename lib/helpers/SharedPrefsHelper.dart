import 'package:app_vendas/models/Usuario.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferenceHelper{

  static String idUsuarioKey = "IDUSUARIOKEY";
  static String nomeUsuarioKey = "NOMEUSUARIOKEY";
  static String emailUsuarioKey = "EMAILUSUARIOKEY";
  static String urlImagemUsuarioKey = "URLIMAGEMUSUARIOKEY";

  Future<bool> saveIdUsuario(String userId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(idUsuarioKey, userId);
  }

  Future<bool> saveNomeUsuario(String userName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(nomeUsuarioKey, userName);
  }

  Future<bool> saveEmailUsuario(String userEmail) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(emailUsuarioKey, userEmail);
  }

  Future<bool> saveUrlImagemUsuario(String userUrlImagem) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(urlImagemUsuarioKey, userUrlImagem);
  }

  Future<String> getIdUsuario() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(idUsuarioKey);
  }

  Future<String> getNomeUsuario() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(nomeUsuarioKey);
  }

  Future<String> getEmailUsuario() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(emailUsuarioKey);
  }

  Future<String> getUrlImagemUsuario() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(urlImagemUsuarioKey);
  }

  saveUsuario(Usuario usuario){
    saveIdUsuario(usuario.idUsuario);
    saveNomeUsuario(usuario.nome);
    saveEmailUsuario(usuario.email);
    saveUrlImagemUsuario(usuario.urlImagemPerfil);
  }
  
}