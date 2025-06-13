import 'package:flutter/material.dart';
import 'package:flutter_application/constants.dart';
import 'package:flutter_application/controllers/controller_usuario.dart';
import 'package:flutter_application/pages/juegos/ahorcado/ahorcado.dart';
import 'package:flutter_application/pages/juegos/sopa_de_letras/sopa_de_letras.dart';
import 'package:get/get.dart';

class ListaVideojuegosPage extends StatefulWidget {
  final String? materiaEstudiante;

  const ListaVideojuegosPage({
    super.key,
    this.materiaEstudiante,
  });

  @override
  State<ListaVideojuegosPage> createState() => _ListaVideojuegosPageState();
}

class _ListaVideojuegosPageState extends State<ListaVideojuegosPage> {
  UsuarioController usuarioController = Get.find<UsuarioController>();
  String? areaSeleccionada;

  final List<Map<String, String>> videojuegos = [
    {
      'nombre': 'Juego del Ahorcado',
      'descripcion': 'Adivina la palabra antes de que se complete el ahorcado.',
      'imagen': 'ahorcado.png',
    },
    {
      'nombre': 'Sopa de Letras',
      'descripcion': 'Encuentra las palabras escondidas en la cuadrícula.',
      'imagen': 'sopaletras.png',
    },
    {
      'nombre': 'Más Juegos',
      'descripcion': 'Explora y juega más juegos educativos.',
      'imagen': 'mas_juegos.png',
    },
  ];

  @override
  void initState() {
    super.initState();
    final rol = usuarioController.usuario.value?.tipo;
    areaSeleccionada = rol == 'profesor' ? 'biologia' : widget.materiaEstudiante.toString();
  }

  @override
  Widget build(BuildContext context) {
    final rol = usuarioController.usuario.value?.tipo;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Videojuegos Educativos',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Stack(
            children: [
              // Círculos de fondo
              Positioned(
                bottom: -150,
                left: 230,
                child: Container(
                  width: 300,
                  height: 250,
                  decoration: BoxDecoration(
                    color: gColorTheme1_700.withOpacity(0.8),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              Positioned(
                bottom: -150,
                right: 230,
                child: Container(
                  width: 300,
                  height: 250,
                  decoration: BoxDecoration(
                    color: gColorTheme1_600.withOpacity(0.8),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              Column(
                children: [
                  if (rol == 'profesor')
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25.0),
                        child: DropdownButton<String>(
                          value: areaSeleccionada,
                          onChanged: (String? nuevaArea) {
                            setState(() {
                              areaSeleccionada = nuevaArea!;
                            });
                          },
                          items: <String>['biologia', 'quimica', 'fisica'].map((String area) {
                            return DropdownMenuItem<String>(
                              value: area,
                              child: Text(area.capitalize!, style: const TextStyle(fontSize: 18)),
                            );
                          }).toList(),
                          iconSize: 30,
                        ),
                      ),
                    ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: videojuegos.length,
                      itemBuilder: (context, index) {
                        final juego = videojuegos[index];
                        return ListTile(
                          leading: CircleAvatar(
                            backgroundImage: AssetImage('assets/images/banners/${juego['imagen']}'),
                          ),
                          title: Text(juego['nombre'] ?? ''),
                          subtitle: Text(juego['descripcion'] ?? ''),
                          onTap: () {
                            String area = rol == 'profesor'
                                ? areaSeleccionada!
                                : widget.materiaEstudiante ?? 'biologia';

                            if (juego['nombre'] == 'Juego del Ahorcado') {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => AhorcadoApp(area: area)),
                              );
                            } else if (juego['nombre'] == 'Sopa de Letras') {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => SopaDeLetrasPage(asignatura: area)),
                              );
                            } else if (juego['nombre'] == 'Más Juegos') {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text('Próximamente'),
                                  content: const Text('Estamos trabajando en eso.'),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: const Text('Aceptar'),
                                    ),
                                  ],
                                ),
                              );
                            }
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}
