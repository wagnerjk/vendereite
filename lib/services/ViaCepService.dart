import 'package:app_vendas/models/ResultCep.dart';
import 'package:http/http.dart' as http;


class ViaCepService {
  static Future<ResultCep> fetchCep({String cep}) async {
    var url = Uri.https('viacep.com.br', 'ws/$cep/json/');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      return ResultCep.fromJson(response.body);
    } else {
      throw Exception('Requisição inválida!');
    }
  }
}