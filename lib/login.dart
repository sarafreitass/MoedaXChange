import 'package:app/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hive_flutter/hive_flutter.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

//inicializar o Hive
final _c = Hive.box("caixa-login");

class _LoginState extends State<Login> {
  final formKey = GlobalKey<FormState>();
  final email = TextEditingController();
  final senha = TextEditingController();

  bool isLogin = true;
  late String titulo;
  late String mover;
  late String textoinferior;
  bool loading = false;

  bool _isChecked = _c.get('rememberMe') ?? false;
  String? _radioValue = _c.get('selectedRadio') ?? '';

  @override
  void initState() {
    super.initState();
    setFormAction(true);
  }

  setFormAction(bool acao) {
    setState(() {
      isLogin = acao;
      if (isLogin) {
        titulo = 'MOEDAXCHANGE';
        mover = 'Login';
        textoinferior = 'Cadastre-se aqui';
      } else {
        titulo = 'Crie sua conta';
        mover = 'Cadastrar';
        textoinferior = 'Voltar ao Login.';
      }
    });
  }

  void _showDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Welcome!'),
          content: Text('Logged in!'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  login() async {
    setState(() => loading = true);
    try {
      await context.read<AuthService>().login(email.text, senha.text);
      _showDialog();
    } on AuthException catch (e) {
      setState(() => loading = false);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.messagem)));
    }
  }

  registrar() async {
    setState(() => loading = true);
    try {
      await context.read<AuthService>().registrar(email.text, senha.text);
      _showDialog();
    } on AuthException catch (e) {
      setState(() => loading = false);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.messagem)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF52796F),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 100),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  alignment: Alignment.topCenter,
                  width: 70,
                  height: 70,
                  child: Image.asset('lib/assets/moeda.png'),
                ),
                Text(
                  titulo,
                  style: const TextStyle(
                    fontSize: 35,
                    fontWeight: FontWeight.bold,
                    letterSpacing: -1.5,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: TextFormField(
                    //initialValue: _c.get('email_login'),
                    controller: email,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Email',
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Informe o email corretamente!';
                      }
                      return null;
                    },
                    /*onChanged: (value) {
                      _c.put('email_login', value);
                    },*/
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 12.0, horizontal: 24.0),
                  child: TextFormField(
                    //initialValue: _c.get('password'),
                    controller: senha,
                    obscureText: true,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Senha',
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Informa sua senha!';
                      } else if (value.length < 6) {
                        return 'Sua senha deve ter no mínimo 6 caracteres';
                      }
                      return null;
                    },
                    /*onChanged: (value) {
                        _c.put('password', value);
                      }*/
                  ),
                ),
                //check box
                Container(
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Checkbox(
                        value: _isChecked,
                        onChanged: (value) {
                          setState(() {
                            _isChecked = value!;
                            _c.put('rememberMe', _isChecked);
                          });
                        },
                      ),
                      Text('Remember me'),
                    ],
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Radio(
                          value: 'Male',
                          groupValue: _radioValue,
                          onChanged: (value2) {
                            setState(() {
                              _radioValue = value2 as String?;
                              _c.put('selectedRadio', _radioValue);
                            });
                          }),
                      Text('Male'),
                      Radio(
                          value: 'Female',
                          groupValue: _radioValue,
                          onChanged: (value2) {
                            setState(() {
                              _radioValue = value2 as String?;
                              _c.put('selectedRadio', _radioValue);
                            });
                          }),
                      Text('Female'),
                      Radio(
                          value: 'Other',
                          groupValue: _radioValue,
                          onChanged: (value2) {
                            setState(() {
                              _radioValue = value2 as String?;
                              _c.put('selectedRadio', _radioValue);
                            });
                          }),
                      Text('Other'),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: ElevatedButton(
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        if (isLogin) {
                          login();
                        } else {
                          registrar();
                        }
                      }
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: (loading)
                          ? [
                              const Padding(
                                padding: EdgeInsets.all(16),
                                child: SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                  ),
                                ),
                              )
                            ]
                          : [
                              const Icon(Icons.check),
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Text(
                                  mover,
                                  style: const TextStyle(fontSize: 20),
                                ),
                              ),
                            ],
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () => setFormAction(!isLogin),
                  child: Text(textoinferior),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
