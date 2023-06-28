//import 'dart:js';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:app/services/auth_service.dart';
import 'package:app/widgets/auth_check.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../login.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:provider/provider.dart';

//Sara Freitas 254358
//João Quessada 237885

/* 
git status
aparece oq mudou
git add .
git status
git commit -m "mensagem do commit"
git push
*/

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox("box");
  await Hive.openBox("caixa-login");
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => AuthService())
    ], //indica que a classe AuthService é um
    // provider, ou seja, um gerenciador de estados
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Application name
      title: 'Gerenciador de Cotações',
      // A widget which will be started on application startup
      home: AuthCheck(),
    );
  }
}
