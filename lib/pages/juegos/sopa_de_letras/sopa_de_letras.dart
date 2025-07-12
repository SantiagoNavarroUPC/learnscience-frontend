import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_application/components/coustom_bottom_nav_bar.dart';
import 'package:flutter_application/enums.dart';

class SopaDeLetrasPage extends StatefulWidget {
  final String asignatura;
  const SopaDeLetrasPage({super.key, required this.asignatura});

  @override
  State<SopaDeLetrasPage> createState() => _SopaDeLetrasPageState();
}

class _SopaDeLetrasPageState extends State<SopaDeLetrasPage> {
  static const int gridSize = 12;
  late List<List<String>> grid;
  late List<String> palabras;
  List<String> palabrasEncontradas = [];

  List<Offset> seleccionadas = [];
  Timer? validacionTimer;
  late AudioPlayer _player;

  final Map<String, List<String>> bancoPalabras = {
    'biologia': ["CELULA", "ADN", "GEN", "ENZIMA", "REINO", "ORGANO", "CROMOSOMA", "MITOSIS", "ECOLOGIA", "BACTERIA"],
    'quimica': ["ATOMO", "MOLECULA", "ION", "ACIDO", "BASE", "PH", "ELECTRON", "PROTON", "NEUTRON", "CATALISIS"],
    'fisica': ["FUERZA", "ENERGIA", "MASA", "VELOCIDAD", "GRAVEDAD", "MOVIMIENTO", "ONDA", "FRECUENCIA", "TRABAJO", "POTENCIA"]
  };

  @override
  void initState() {
    super.initState();
    _player = AudioPlayer();
    palabras = bancoPalabras[widget.asignatura.toLowerCase()] ?? [];
    grid = List.generate(gridSize, (_) => List.generate(gridSize, (_) => ''));
    colocarPalabras();
    llenarVacios();
  }

  Future<void> _reproducirSonido(String nombre) async {
    await _player.play(AssetSource('sounds/$nombre.mp3'));
  }

  void colocarPalabras() {
    final random = Random();
    for (String palabra in palabras) {
      bool colocada = false;
      while (!colocada) {
        int fila = random.nextInt(gridSize);
        int col = random.nextInt(gridSize);
        int dir = random.nextInt(8);
        int dx = [0, 1, 1, 1, 0, -1, -1, -1][dir];
        int dy = [1, 1, 0, -1, -1, -1, 0, 1][dir];

        if (puedeColocar(palabra, fila, col, dx, dy)) {
          for (int i = 0; i < palabra.length; i++) {
            grid[fila + i * dy][col + i * dx] = palabra[i];
          }
          colocada = true;
        }
      }
    }
  }

  bool puedeColocar(String palabra, int fila, int col, int dx, int dy) {
    for (int i = 0; i < palabra.length; i++) {
      int newRow = fila + i * dy;
      int newCol = col + i * dx;
      if (newRow < 0 || newRow >= gridSize || newCol < 0 || newCol >= gridSize) return false;
      if (grid[newRow][newCol].isNotEmpty && grid[newRow][newCol] != palabra[i]) return false;
    }
    return true;
  }

  void llenarVacios() {
    final abc = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    final random = Random();
    for (int i = 0; i < gridSize; i++) {
      for (int j = 0; j < gridSize; j++) {
        if (grid[i][j].isEmpty) {
          grid[i][j] = abc[random.nextInt(abc.length)];
        }
      }
    }
  }

  void seleccionarCelda(int fila, int col) {
    final pos = Offset(fila.toDouble(), col.toDouble());
    if (seleccionadas.contains(pos)) {
      seleccionadas.remove(pos);
    } else {
      seleccionadas.add(pos);
    }

    validacionTimer?.cancel();
    validacionTimer = Timer(const Duration(seconds: 2), validarSeleccion);

    setState(() {});
  }

  void validarSeleccion() async {
    if (seleccionadas.length < 2) return;

    seleccionadas.sort((a, b) {
      if (a.dy != b.dy) return a.dy.compareTo(b.dy);
      return a.dx.compareTo(b.dx);
    });

    int dx = (seleccionadas[1].dx - seleccionadas[0].dx).round();
    int dy = (seleccionadas[1].dy - seleccionadas[0].dy).round();

    for (int i = 1; i < seleccionadas.length; i++) {
      int currentDx = (seleccionadas[i].dx - seleccionadas[i - 1].dx).round();
      int currentDy = (seleccionadas[i].dy - seleccionadas[i - 1].dy).round();
      if (currentDx != dx || currentDy != dy) {
        await _reproducirSonido("error");
        reiniciarSeleccion();
        return;
      }
    }

    String palabra = seleccionadas.map((e) => grid[e.dx.toInt()][e.dy.toInt()]).join('');

    if (palabras.contains(palabra) && !palabrasEncontradas.contains(palabra)) {
      palabrasEncontradas.add(palabra);
      await _reproducirSonido("correcto");

      if (palabrasEncontradas.length == palabras.length) {
        await Future.delayed(const Duration(milliseconds: 500));
        await _reproducirSonido("nivel_completado");

        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text('¡Felicidades!'),
            content: const Text('Has encontrado todas las palabras.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Aceptar'),
              ),
            ],
          ),
        );
      }
    } else {
      await _reproducirSonido("error");
      reiniciarSeleccion();
    }

    setState(() {
      seleccionadas.clear();
    });
  }

  void reiniciarSeleccion() {
    seleccionadas.clear();
    setState(() {});
  }

  bool esSeleccionada(int row, int col) {
    return seleccionadas.contains(Offset(row.toDouble(), col.toDouble()));
  }

  bool esEncontrada(int row, int col) {
    for (String palabra in palabrasEncontradas) {
      for (int dir = 0; dir < 8; dir++) {
        int dx = [0, 1, 1, 1, 0, -1, -1, -1][dir];
        int dy = [1, 1, 0, -1, -1, -1, 0, 1][dir];

        for (int i = 0; i < palabra.length; i++) {
          int startX = row - i * dx;
          int startY = col - i * dy;
          int endX = startX + (palabra.length - 1) * dx;
          int endY = startY + (palabra.length - 1) * dy;

          if (startX < 0 || startX >= gridSize || startY < 0 || startY >= gridSize) continue;
          if (endX < 0 || endX >= gridSize || endY < 0 || endY >= gridSize) continue;

          bool match = true;
          for (int j = 0; j < palabra.length; j++) {
            int x = startX + j * dx;
            int y = startY + j * dy;
            if (grid[x][y] != palabra[j]) {
              match = false;
              break;
            }
          }

          if (match) {
            for (int j = 0; j < palabra.length; j++) {
              int x = startX + j * dx;
              int y = startY + j * dy;
              if (x == row && y == col) return true;
            }
          }
        }
      }
    }
    return false;
  }

  @override
  void dispose() {
    validacionTimer?.cancel();
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sopa de Letras - ${widget.asignatura}',
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
      ),
      body: Column(
        children: [
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(4),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: gridSize,
              ),
              itemCount: gridSize * gridSize,
              itemBuilder: (context, index) {
                int row = index ~/ gridSize;
                int col = index % gridSize;
                bool seleccionado = esSeleccionada(row, col);
                bool encontrado = esEncontrada(row, col);

                return GestureDetector(
                  onTap: () => seleccionarCelda(row, col),
                  child: Container(
                    margin: const EdgeInsets.all(1),
                    decoration: BoxDecoration(
                      color: encontrado
                          ? Colors.green
                          : (seleccionado ? Colors.lightGreenAccent : Colors.white),
                      border: Border.all(color: Colors.grey.shade400),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      grid[row][col],
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                  ),
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8),
            color: Colors.grey.shade200,
            child: Wrap(
              spacing: 6,
              children: palabras.map((pal) {
                final encontrada = palabrasEncontradas.contains(pal);
                return Chip(
                  label: Text(pal),
                  backgroundColor: encontrada ? Colors.green : Colors.grey.shade300,
                );
              }).toList(),
            ),
          ),
        ],
      ),
      bottomNavigationBar: const CustomBottomNavBar(selectedMenu: MenuState.game),
    );
  }
}
