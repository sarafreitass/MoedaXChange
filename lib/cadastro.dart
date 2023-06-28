/*import 'package:app/login.dart';
import 'package:app/model/usuario.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:provider/provider.dart';
import 'package:app/services/auth_service.dart';

class Cadastro extends StatefulWidget {
  @override
  _Cadastro createState() => _Cadastro();
}

class _Cadastro extends State<Cadastro> {
//parte autenticação
  //final email = TextEditingController();
  //final senha = TextEditingController();

  bool isLogin = true;
  bool loading = false;

  registrar() async {
    setState(() => loading = true);
    try {
      await context
          .read<AuthService>()
          .registrar(_edEmail.text, _edPassword.text);
    } on AuthException catch (e) {
      setState(() => loading = false);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.messagem)));
    }
  }

/////
  DatabaseReference dbRef = FirebaseDatabase.instance.ref();
  final TextEditingController _edUsername = TextEditingController();
  final TextEditingController _edEmail = TextEditingController();
  final TextEditingController _edPassword = TextEditingController();

  List<Usuario> listaUsuario = [];

  void initState() {
    super.initState();
    //recuperarDataUsuario();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.green,
        child: ListView(
          children: <Widget>[
            SizedBox(height: 40),
            SizedBox(
              width: 64,
              height: 64,
              child: Image.asset('lib/assets/moeda.png'),
            ),
            SizedBox(
              height: 40,
            ),
            TextFormField(
              controller: _edEmail,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: 'email',
                labelStyle: TextStyle(
                  color: Colors.black,
                ),
              ),
            ),
            SizedBox(
              height: 5,
            ),
            TextFormField(
              controller: _edUsername,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                labelText: 'username',
                labelStyle: TextStyle(
                  color: Colors.black,
                ),
              ),
            ),
            SizedBox(
              height: 5,
            ),
            TextFormField(
              controller: _edPassword,
              keyboardType: TextInputType.text,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'password',
                labelStyle: TextStyle(
                  color: Colors.black,
                ),
              ),
            ),
            SizedBox(
              height: 5,
            ),
            SizedBox(
              height: 80,
            ),
            Container(
                alignment: Alignment.center,
                child: (FloatingActionButton(
                    backgroundColor: Colors.black,
                    onPressed: () {
                      /* Map<String, dynamic> data = {
                        "email": _edEmail.text.toString(),
                        "username": _edUsername.text.toString(),
                        "password": _edPassword.text.toString(),
                      };

                      dbRef.child("Usuario").push().set(data).then((value) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Login()),
                        );
                      });*/
                    },
                    child: (Text("Save"))))),
          ],
        ),
      ),
    );
  }

  /* void recuperarDataUsuario() {
    dbRef.child("Usuario").onChildAdded.listen((data) {
      DataUsuario dataUsuario =
          DataUsuario.fromJson(data.snapshot.value as Map);
      Usuario usuario =
          Usuario(key: data.snapshot.key, datausuario: dataUsuario);
      listaUsuario.add(usuario);
      setState(() {});
    });
  }*/
}*/
