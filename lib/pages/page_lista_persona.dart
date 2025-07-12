
import 'package:flutter/material.dart';
import 'package:flutter_application/constants.dart';
import 'package:flutter_application/controllers/controller_usuario.dart';
import 'package:flutter_application/models/Persona.dart';
import 'package:flutter_application/models/Usuario.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class ListaUsuariosScreen extends StatelessWidget {
  final UsuarioController usuarioController = Get.put(UsuarioController());

  ListaUsuariosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    usuarioController.obtenerUsuarios();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Usuarios Activos',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Stack(
            children: [
              Positioned(bottom: -150, left: 230, child: _circuloFondo(gColorTheme1_700)),
              Positioned(bottom: -150, right: 230, child: _circuloFondo(gColorTheme1_400)),
              Obx(() {
                final usuarios = usuarioController.usuarios;
                return RefreshIndicator(
                  onRefresh: () async => await usuarioController.obtenerUsuarios(),
                  child: ListView.builder(
                    itemCount: usuarios.length + 1,
                    itemBuilder: (context, index) {
                      if (index == usuarios.length) {
                        return Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: GestureDetector(
                            onTap: () async {
                              final url = Uri.parse("https://wa.me/573217832643?text=Necesito%20ayuda%20debo%20ajustar%20un%20usuario");
                              if (await canLaunchUrl(url)) {
                                await launchUrl(url);
                              }
                            },
                            child: const Center(
                              child: Text(
                                "Cualquier Soporte, Contáctanos por WhatsApp",
                                style: TextStyle(
                                  color: gColorTheme1_700,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        );
                      }

                      final usuario = usuarios[index];
                      final tienePersona = usuario.personas != null && usuario.personas!.isNotEmpty;
                      final persona = tienePersona ? usuario.personas![0] : null;

                      return ListTile(
                        leading: _buildAvatar(usuario, persona),
                        title: Text(
                          tienePersona
                              ? "${persona!.nombre} ${persona.apellido}"
                              : "Falta registrarse",
                          style: TextStyle(
                            color: tienePersona ? Colors.black : Colors.red,
                            fontWeight: tienePersona ? FontWeight.normal : FontWeight.bold,
                          ),
                        ),
                        subtitle: Text(usuario.correo),
                        onTap: () {
                          if (tienePersona) {
                            _mostrarDetallesPersona(context, persona!);
                          } else {
                            _mostrarAlertaPerfilIncompleto(context);
                          }
                        },
                      );
                    },
                  ),
                );
              }),
            ],
          );
        },
      ),
    );
  }

  Widget _buildAvatar(UsuarioModel usuario, PersonaModel? persona) {
    if (persona != null && persona.foto != null && persona.foto!.isNotEmpty) {
      return CircleAvatar(
        backgroundImage: NetworkImage(persona.foto!),
        backgroundColor: Colors.grey[200],
      );
    }

    String iniciales;

    if (persona != null) {
      iniciales = "${persona.nombre[0]}${persona.apellido[0]}";
    } else {
      iniciales = usuario.correo.substring(0, 2).toUpperCase();
    }

    return CircleAvatar(
      backgroundColor: gColorTheme1_800,
      child: Text(
        iniciales,
        style: const TextStyle(color: Colors.white),
      ),
    );
  }

  Widget _circuloFondo(Color color) {
    return Container(
      width: 300,
      height: 250,
      decoration: BoxDecoration(
        color: color.withOpacity(0.8),
        shape: BoxShape.circle,
      ),
    );
  }

  void _mostrarDetallesPersona(BuildContext context, PersonaModel persona) {
    showModalBottomSheet(
      context: context,
      builder: (_) => Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Detalles de la Persona', style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 16),
            Text('Nombre: ${persona.nombre}'),
            Text('Apellido: ${persona.apellido}'),
            Text('Edad: ${persona.edad}'),
            Text('Teléfono: ${persona.telefono}'),
            Text('Dirección: ${persona.direccion}'),
            Text('Activo: ${persona.eliminado == true ? 'No' : 'Sí'}'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cerrar'),
            ),
          ],
        ),
      ),
    );
  }

  void _mostrarAlertaPerfilIncompleto(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Perfil Incompleto'),
        content: const Text('Deberías completar tu perfil para acceder a más funcionalidades.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cerrar'),
          ),
        ],
      ),
    );
  }
}

