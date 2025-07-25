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
      theme: ThemeData(
        primarySwatch: Colors.purple,
        fontFamily: 'Comic Sans MS',
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.purple,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
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

class _RotinaScreenState extends State<RotinaScreen>
    with TickerProviderStateMixin {
  final Box box = Hive.box('rotina');
  late AnimationController _animationController;
  late AnimationController _bounceController;

  final List<String> dias = ['Seg', 'Ter', 'Qua', 'Qui', 'Sex', 'Sáb', 'Dom'];
  final List<String> diasCompletos = [
    'Segunda',
    'Terça',
    'Quarta',
    'Quinta',
    'Sexta',
    'Sábado',
    'Domingo',
  ];

  final List<Map<String, dynamic>> tarefas = [
    {
      'nome': 'Escovar os dentes',
      'emoji': '🪥',
      'periodo': 'dia',
      'cor': Colors.lightBlue,
    },
    {
      'nome': 'Colocar roupa',
      'emoji': '👕',
      'periodo': 'dia',
      'cor': Colors.pink,
    },
    {'nome': 'Bombinha', 'emoji': '🫁', 'periodo': 'dia', 'cor': Colors.green},
    {
      'nome': 'Arrumar cabelo',
      'emoji': '💇',
      'periodo': 'dia',
      'cor': Colors.orange,
    },
    {
      'nome': 'Ir para escola',
      'emoji': '🎒',
      'periodo': 'dia',
      'cor': Colors.purple,
    },
    {
      'nome': 'Banho + Roupa',
      'emoji': '🛁',
      'periodo': 'noite',
      'cor': Colors.cyan,
    },
    {
      'nome': 'Escovar os dentes',
      'emoji': '🪥',
      'periodo': 'noite',
      'cor': Colors.lightBlue,
    },
    {
      'nome': 'Bombinha',
      'emoji': '🫁',
      'periodo': 'noite',
      'cor': Colors.green,
    },
    {
      'nome': 'Lavar nariz',
      'emoji': '👃',
      'periodo': 'noite',
      'cor': Colors.teal,
    },
    {
      'nome': 'Lavar cabelo e penteado',
      'emoji': '💆‍♀️',
      'periodo': 'noite',
      'cor': Colors.indigo,
    },
    {
      'nome': 'Dormir',
      'emoji': '🛏️',
      'periodo': 'noite',
      'cor': Colors.deepPurple,
    },
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _bounceController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _bounceController.dispose();
    super.dispose();
  }

  bool getTarefaFeita(String tarefa, String dia, String periodo) {
    return box.get('$tarefa-$dia-$periodo', defaultValue: false);
  }

  void toggleTarefa(String tarefa, String dia, String periodo) {
    final chave = '$tarefa-$dia-$periodo';
    final atual = box.get(chave, defaultValue: false);
    box.put(chave, !atual);

    // Animação de bounce quando marca/desmarca
    _bounceController.forward().then((_) {
      _bounceController.reverse();
    });

    setState(() {});
  }

  bool mostrarTarefa(String nome, String dia) {
    if (nome == 'Lavar cabelo e penteado' && !(dia == 'Qua' || dia == 'Dom')) {
      return false;
    }
    return true;
  }

  Widget _buildAnimatedCheckbox(bool isChecked, VoidCallback onTap, Color cor) {
    return AnimatedBuilder(
      animation: _bounceController,
      builder: (context, child) {
        return Transform.scale(
          scale: 1.0 + (_bounceController.value * 0.2),
          child: GestureDetector(
            onTap: onTap,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: isChecked ? cor : Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: cor, width: 3),
                boxShadow: [
                  BoxShadow(
                    color: cor.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: isChecked
                  ? const Icon(Icons.check, color: Colors.white, size: 24)
                  : null,
            ),
          ),
        );
      },
    );
  }

  Widget _buildTarefaCard(Map<String, dynamic> tarefa, int index) {
    final isNoite = tarefa['periodo'] == 'noite';
    final cor = tarefa['cor'] as Color;

    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(
            0,
            50 * (1 - Curves.elasticOut.transform(_animationController.value)),
          ),
          child: Opacity(
            opacity: _animationController.value,
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [cor.withOpacity(0.1), cor.withOpacity(0.05)],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: cor.withOpacity(0.3), width: 2),
                boxShadow: [
                  BoxShadow(
                    color: cor.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    // Ícone da tarefa
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: cor.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Text(
                          tarefa['emoji'],
                          style: const TextStyle(fontSize: 28),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Nome da tarefa
                    Expanded(
                      flex: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            tarefa['nome'],
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: cor.withOpacity(0.8),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: isNoite ? Colors.indigo : Colors.amber,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              isNoite ? '🌙 Noite' : '☀️ Dia',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Checkboxes para cada dia
                    Expanded(
                      flex: 3,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: dias.asMap().entries.map((entry) {
                          final diaIndex = entry.key;
                          final dia = entry.value;

                          if (!mostrarTarefa(tarefa['nome'], dia)) {
                            return const SizedBox(width: 40);
                          }

                          final isChecked = getTarefaFeita(
                            tarefa['nome'],
                            dia,
                            tarefa['periodo'],
                          );

                          return Column(
                            children: [
                              Text(
                                dia,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: cor,
                                ),
                              ),
                              const SizedBox(height: 4),
                              _buildAnimatedCheckbox(
                                isChecked,
                                () => toggleTarefa(
                                  tarefa['nome'],
                                  dia,
                                  tarefa['periodo'],
                                ),
                                cor,
                              ),
                            ],
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFE3F2FD), Color(0xFFF3E5F5), Color(0xFFE8F5E8)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header animado
              AnimatedBuilder(
                animation: _animationController,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _animationController.value,
                    child: Container(
                      margin: const EdgeInsets.all(16),
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [
                            Color(0xFF6A1B9A),
                            Color(0xFF8E24AA),
                            Color(0xFFAB47BC),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.purple.withOpacity(0.3),
                            blurRadius: 15,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: const Center(
                              child: Text('📅', style: TextStyle(fontSize: 32)),
                            ),
                          ),
                          const SizedBox(width: 16),
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Minha Rotina Semanal',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  'Vamos completar nossas tarefas! 🌟',
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 14,
                                  ),
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

              // Lista de tarefas
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  itemCount: tarefas.length,
                  itemBuilder: (context, index) {
                    return _buildTarefaCard(tarefas[index], index);
                  },
                ),
              ),

              // Footer com estatísticas
              AnimatedBuilder(
                animation: _animationController,
                builder: (context, child) {
                  int totalTarefas = 0;
                  int tarefasCompletas = 0;

                  for (var tarefa in tarefas) {
                    for (var dia in dias) {
                      if (mostrarTarefa(tarefa['nome'], dia)) {
                        totalTarefas++;
                        if (getTarefaFeita(
                          tarefa['nome'],
                          dia,
                          tarefa['periodo'],
                        )) {
                          tarefasCompletas++;
                        }
                      }
                    }
                  }

                  final progresso = totalTarefas > 0
                      ? tarefasCompletas / totalTarefas
                      : 0.0;

                  return Transform.translate(
                    offset: Offset(0, 50 * (1 - _animationController.value)),
                    child: Container(
                      margin: const EdgeInsets.all(16),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Progresso da Semana',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.purple.shade700,
                                ),
                              ),
                              Text(
                                '$tarefasCompletas/$totalTarefas',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.purple.shade700,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          LinearProgressIndicator(
                            value: progresso,
                            backgroundColor: Colors.grey.shade200,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.purple.shade400,
                            ),
                            minHeight: 8,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            progresso >= 1.0
                                ? '🎉 Parabéns! Você completou tudo!'
                                : progresso >= 0.7
                                ? '⭐ Muito bem! Continue assim!'
                                : progresso >= 0.3
                                ? '💪 Você está indo bem!'
                                : '🌱 Vamos começar!',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.purple.shade600,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
