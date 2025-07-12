import 'package:flutter/material.dart';
import 'package:flutter_application/constants.dart';
import 'package:flutter_application/theme.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class ConfiguracionPage extends StatefulWidget {
  const ConfiguracionPage({Key? key}) : super(key: key);

  @override
  State<ConfiguracionPage> createState() => _ConfiguracionPageState();
}

class _ConfiguracionPageState extends State<ConfiguracionPage> {
  final ThemeService _themeService = ThemeService();
  bool isDark = Get.isDarkMode;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Configuración", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Stack(
            children: [
              // Círculos decorativos
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
                    color: gColorTheme1_400.withOpacity(0.8),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              // Contenido
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: ListView(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.grade),
                      title: const Text("Ver Calificaciones"),
                      onTap: () => Navigator.pushNamed(context, '/listar_calificaciones'),
                    ),
                    ListTile(
                      leading: const Icon(Icons.add),
                      title: const Text("Agregar Otra Asignatura"),
                      onTap: () => Navigator.pushNamed(context, '/agregar_asignatura'),
                    ),
                    SwitchListTile(
                      secondary: const Icon(Icons.dark_mode),
                      title: const Text('Activar Modo Oscuro'),
                      value: isDark,
                      onChanged: (value) {
                        setState(() {
                          isDark = value;
                          _themeService.switchTheme(value);
                        });
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.info_outline),
                      title: const Text("Créditos"),
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text("Créditos"),
                            content: const Text("Realizado por Santiago Navarro y Duvan Lozano."),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text("Aceptar"),
                              )
                            ],
                          ),
                        );
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.support_agent),
                      title: const Text("Soporte por WhatsApp"),
                      onTap: () async {
                        final url = Uri.parse("https://wa.me/573217832643?text=Necesito%20ayuda%20con%20la%20aplicación");
                        if (await canLaunchUrl(url)) {
                          await launchUrl(url);
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
