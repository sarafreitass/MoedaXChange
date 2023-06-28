import 'package:flutter/material.dart';

class ListaCotacoesHistorico extends StatefulWidget {
  @override
  _ListaCotacoesHistoricoState createState() => _ListaCotacoesHistoricoState();
}

class _ListaCotacoesHistoricoState extends State<ListaCotacoesHistorico> {
  List<Map<String, dynamic>> cotacoes = [
    {'nome': 'Dólar', 'codigo': 'USD', 'valor': '5.41'},
    {'nome': 'Euro', 'codigo': 'EUR', 'valor': '6.39'},
    {'nome': 'Iene', 'codigo': 'JPY', 'valor': '0.049'},
    {'nome': 'Libra', 'codigo': 'GBP', 'valor': '7.44'},
  ];

  TextEditingController _searchController = TextEditingController();

  List<Map<String, dynamic>> _filteredCotacoes = [];

  @override
  void initState() {
    super.initState();
    _filteredCotacoes = cotacoes;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightGreen,
        centerTitle: true,
        title: const Text('Lista do Histórico de busca'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Pesquisar cotação na lista de histórico',
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(horizontal: 20.0),
              ),
              onChanged: (value) {
                setState(() {
                  _filteredCotacoes = cotacoes
                      .where((cotacao) => cotacao['nome']
                          .toLowerCase()
                          .contains(value.toLowerCase()))
                      .toList();
                });
              },
            ),
            SizedBox(height: 10.0),
            Expanded(
              child: ListView.builder(
                itemCount: _filteredCotacoes.length,
                itemBuilder: (BuildContext context, int index) {
                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${_filteredCotacoes[index]['nome']} - ${_filteredCotacoes[index]['codigo']}',
                            style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 10.0),
                          Text(
                            'Valor: ${_filteredCotacoes[index]['valor']}',
                            style: TextStyle(
                              fontSize: 16.0,
                            ),
                          ),
                          SizedBox(height: 10.0),
                          Align(
                            alignment: Alignment.centerRight,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                IconButton(
                                  icon: Icon(Icons.delete),
                                  onPressed: () {
                                    setState(() {
                                      cotacoes.remove(_filteredCotacoes[index]);
                                      _filteredCotacoes = cotacoes;
                                    });
                                  },
                                ),
                                IconButton(
                                  icon: Icon(Icons.star_border),
                                  onPressed: () {
                                    //lógica para adicionar a cotação aos favoritos
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
