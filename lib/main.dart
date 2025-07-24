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

  final List<String> tarefas = [
    'Escovar dentes',
    'Tomar banho',
    'Pentear cabelo',
    'Colocar roupa',
    'Ir para a escola',
  ];

  bool getTarefaFeita(String tarefa, String dia) {
    return box.get('$tarefa-$dia', defaultValue: false);
  }

  void toggleTarefa(String tarefa, String dia) {
    final chave = '$tarefa-$dia';
    final atual = box.get(chave, defaultValue: false);
    box.put(chave, !atual);
    setState(() {});
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
                  children: [
                    TableCell(
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Text(tarefa),
                      ),
                    ),
                    for (var dia in dias)
                      TableCell(
                        child: Checkbox(
                          value: getTarefaFeita(tarefa, dia),
                          onChanged: (_) => toggleTarefa(tarefa, dia),
                        ),
                      ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
