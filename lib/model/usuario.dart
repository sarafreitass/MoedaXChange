import 'package:app/model/lista.dart';

class Usuario {
  String? key;
  DataUsuario? datausuario;

  Usuario({this.key, this.datausuario});
}

class DataUsuario {
  String? username;
  String? email;
  String? password;
  List<Lista> lista_favoritos = [];
  List<Lista> lista_historico = [];

  DataUsuario(
      {this.username,
      this.email,
      this.password,
      required this.lista_favoritos,
      required this.lista_historico});

  DataUsuario.fromJson(Map<dynamic, dynamic> json) {
    username = json["username"];
    email = json["email"];
    password = json["password"];
    lista_favoritos = json["favoritos"];
    lista_historico = json["historico"];
  }
}
