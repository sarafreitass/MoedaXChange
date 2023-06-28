import 'package:flutter/material.dart';
import '../AboutUs.dart';
import '../buscar.dart';
import '../editarDados.dart';
import '../favoritos.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  //final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _indiceAtual = 0;
  final List<Widget> _telas = [
    ListaCotacoesFavoritas(),
    //ListaCotacoesHistorico(),
    BuscarCotacao(),
    editarDados(),
    AboutUs(),
  ];

  void onTabTapped(int index) {
    setState(() {
      _indiceAtual = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /*appBar: AppBar(
        backgroundColor: Color(0x52796F),
      ),*/
      body: _telas[_indiceAtual],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.star_border_outlined),
            label: 'Favoritos',
            backgroundColor: Color.fromARGB(255, 90, 180, 100),
          ),
          /*BottomNavigationBarItem(
            icon: Icon(Icons.punch_clock),
            label: 'Histórico',
            backgroundColor: Color.fromARGB(255, 100, 190, 110),
          ),*/
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Buscar',
            backgroundColor: Color.fromARGB(255, 110, 200, 120),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Configurações',
            backgroundColor: Color.fromARGB(255, 120, 210, 130),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: 'About Us',
            backgroundColor: Color.fromARGB(255, 120, 210, 130),
          ),
        ],
        currentIndex: _indiceAtual,
        selectedItemColor: Color.fromARGB(255, 28, 53, 22),
        onTap: onTabTapped,
      ),
    );
  }
}
