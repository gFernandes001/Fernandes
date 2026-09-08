import 'package:flutter/material.dart';
import 'database_helper.dart';

void main() => runApp(const MaterialApp(home: TelaTarefas()));

class TelaTarefas extends StatefulWidget {
  const TelaTarefas({super.key});

  @override
  State<TelaTarefas> createState() => _TelaTarefasState();
}

class _TelaTarefasState extends State<TelaTarefas> {
  List<Map<String, dynamic>> _listaTarefas = [];
  final TextEditingController _controllerAdicionar = TextEditingController();

  @override
  void initState() {
    super.initState();
    _atualizarLista();
  }

  Future<void> _atualizarLista([String busca = '']) async {
    final dados = busca.isEmpty
        ? await DatabaseHelper().getTarefas()
        : await DatabaseHelper().buscarPorTexto(busca);
    setState(() {
      _listaTarefas = dados;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Minhas Tarefas'),
        actions: [
      
                                                                                                                       
          IconButton(
            icon: const Icon(Icons.delete_forever),
            onPressed: () async {
              await DatabaseHelper().deleteAll();
              _atualizarLista();
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
          
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controllerAdicionar,
                    decoration: const InputDecoration(
                      hintText: 'Nova tarefa...',
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () async {
                    if (_controllerAdicionar.text.isNotEmpty) {
                      await DatabaseHelper().insertTarefa(_controllerAdicionar.text);
                      _controllerAdicionar.clear();
                      _atualizarLista();
                    }
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),

          
            TextField(
              decoration: const InputDecoration(
                labelText: 'Buscar tarefa...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (texto) => _atualizarLista(texto),
            ),
            const SizedBox(height: 16),

            Expanded(
              child: ListView.builder(
                itemCount: _listaTarefas.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(_listaTarefas[index]['titulo']),
                  );
                },
              ),
            ),
          ],
        ),
      ),

      
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16.0),
        color: Colors.blueAccent,
        child: Text(
          'Total de tarefas registradas: ${_listaTarefas.length}',
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}