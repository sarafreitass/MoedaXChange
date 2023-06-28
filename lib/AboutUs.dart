import 'package:flutter/material.dart';

class AboutUs extends StatefulWidget {
  @override
  State<AboutUs> createState() => _AboutUsState();
}

class _AboutUsState extends State<AboutUs> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightGreen,
        centerTitle: true,
        title: const Text('Sobre nós'),
      ),
      body: ListView(
        children: <Widget>[
          SizedBox(height: 20),
          Center(
            child: SizedBox(
              width: 60,
              height: 60,
              child: CircleAvatar(
                backgroundImage: AssetImage('lib/assets/moeda.png'),
              ),
            ),
          ),
          SizedBox(height: 10),
          Center(
            child: Text(
              'Gerenciador de Cotações',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(height: 5),
          Center(
            child: Text(
              'App desenvolvido em flutter para gerenciar cotações de moedas, com conexão com uma API de cotações',
              style: TextStyle(
                fontSize: 16,
              ),
            ),
          ),
          SizedBox(height: 20),
          ListTile(
            title: Text('SI700'),
            subtitle: Text('Programação para dispositivos móveis'),
          ),
        ],
      ),
    );
  }
}
