import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  await Hive.initFlutter();
  await Hive.openBox('rotina');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rotina Semanal',
      theme: ThemeData(primarySwatch: Colors.pink),
      home: const RotinaScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class RotinaScreen extends StatefulWidget {
  const RotinaScreen({super.key});

  @override
  State<RotinaScreen> createState() => _RotinaScreenState();
}

class _RotinaScreenState extends State<RotinaScreen> {
  final Box box = Hive.box('rotina');

  final List<String> dias = ['Seg', 'Ter', 'Qua', 'Qui', 'Sex', 'Sáb', 'Dom'];

  final List<Map<String, dynamic>> tarefas = [
    {'nome': 'Escovar os dentes	🪥', 'periodo': 'dia'},
    {'nome': 'Colocar roupa	👕', 'periodo': 'dia'},
    {'nome': 'Bombinha 	🫁', 'periodo': 'dia'},
    {'nome': 'Arrumar cabelo 💇', 'periodo': 'dia'},
    {'nome': 'Ir para escola 🎒', 'periodo': 'dia'},
    {'nome': 'Banho + Roupa 🛁 + 👕', 'periodo': 'noite'},
    {'nome': 'Escovar os dentes	🪥', 'periodo': 'noite'},
    {'nome': 'Bombinha 	🫁', 'periodo': 'noite'},
    {'nome': 'Lavar nariz 👃', 'periodo': 'noite'},
    {'nome': 'Lavar cabelo e penteado 💆‍♀️', 'periodo': 'noite'},
    {'nome': 'Dormir 🛏️', 'periodo': 'noite'},
  ];

  bool getTarefaFeita(String tarefa, String dia, String periodo) {
    return box.get('$tarefa-$dia-$periodo', defaultValue: false);
  }

  void toggleTarefa(String tarefa, String dia, String periodo) {
    final chave = '$tarefa-$dia-$periodo';
    final atual = box.get(chave, defaultValue: false);
    box.put(chave, !atual);
    setState(() {});
  }

  bool mostrarTarefa(String nome, String dia) {
    if (nome == 'Lavar cabelo e penteado' && !(dia == 'Qua' || dia == 'Dom')) {
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Rotina Semanal')),
      body: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Table(
            defaultColumnWidth: const FixedColumnWidth(80.0),
            border: TableBorder.all(),
            children: [
              TableRow(
                children: [
                  const TableCell(child: Center(child: Text('Tarefa'))),
                  for (var dia in dias)
                    TableCell(child: Center(child: Text(dia))),
                ],
              ),
              for (var tarefa in tarefas)
                TableRow(
                  decoration: BoxDecoration(
                    color: tarefa['periodo'] == 'dia'
                        ? Colors.pink.shade50
                        : Colors.purple.shade50,
                  ),
                  children: [
                    TableCell(
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Text(tarefa['nome']),
                      ),
                    ),
                    for (var dia in dias)
                      mostrarTarefa(tarefa['nome'], dia)
                          ? TableCell(
                              child: Checkbox(
                                value: getTarefaFeita(
                                  tarefa['nome'],
                                  dia,
                                  tarefa['periodo'],
                                ),
                                onChanged: (_) => toggleTarefa(
                                  tarefa['nome'],
                                  dia,
                                  tarefa['periodo'],
                                ),
                              ),
                            )
                          : const TableCell(child: SizedBox()),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
