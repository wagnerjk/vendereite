import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

class FormataData{
  static formatData(String data, bool extenso){
    initializeDateFormatting("pt_BR");
    var formatador;

    if (extenso){
      formatador = DateFormat.MMMMd("pt_BR");
    } else {
      formatador = DateFormat.Md("pt_BR");
    }

    final DateTime dataConvertida = DateTime.parse(data);
    String dataFormatada = formatador.format(dataConvertida);

    return dataFormatada;
  }

  static formatHora(String data){
    initializeDateFormatting("pt_BR");

    var formatador = DateFormat.Hm("pt_BR");

    final DateTime dataConvertida = DateTime.parse(data);
    String dataFormatada = formatador.format(dataConvertida);

    return dataFormatada;
  }
}