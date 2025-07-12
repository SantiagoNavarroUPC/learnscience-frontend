import 'package:flutter/material.dart';
import 'package:flutter_application/constants.dart';
import 'package:flutter_application/models/Usuario.dart';
import 'package:flutter_application/models/usuario.dart' hide UsuarioModel;
import 'package:get/get.dart';
import '../../controllers/controller_usuario.dart';

class RegistrarUsuarioScreen extends StatefulWidget {
  const RegistrarUsuarioScreen({super.key});

  @override
  _RegistrarUsuarioScreenState createState() => _RegistrarUsuarioScreenState();
}

class _RegistrarUsuarioScreenState extends State<RegistrarUsuarioScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController correoController = TextEditingController();
  final TextEditingController contrasenaController = TextEditingController();
  final TextEditingController confirmacionContrasenaController = TextEditingController();
  final UsuarioController usuarioController = Get.put(UsuarioController());
  bool _obscureText = true;
  bool _aceptaTerminos = false;
  int _selectedRoleIndex = 0;


  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final usuario = UsuarioModel(
        correo: correoController.text,
        contrasena: contrasenaController.text,
        tipo: _selectedRoleIndex == 0 ? 'estudiante' : 'profesor',
      );
      try {
        final success = await usuarioController.registrarUsuario(usuario);
        if (success) {
          Get.toNamed("/login");
          Get.snackbar(
            'Éxito',
            'Usuario registrado con éxito',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: gColorTheme1_900,
            colorText: Colors.white,
          );
        } else {
          Get.snackbar(
            'Error',
            usuarioController.errorMessage.value,
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: gColorThemeError,
            colorText: Colors.white,

          );
        }
      } catch (e) {
        Get.snackbar(
          'Error',
          'Error al registrar usuario: $e',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: gColorThemeInactive,
          colorText: Colors.white,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final height = constraints.maxHeight;
          return Stack(
            children: [
              Positioned(
                top: height * -0.17,
                left: -0.25,
                right: -0.25,
                child: Container(
                  width: 500, // Aumenta el ancho
                  height: 200, // Mantén la altura
                  decoration: BoxDecoration(
                    color: gColorTheme1_600.withOpacity(0.8),
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(100), // Ajusta el radio del borde para mantener la curva
                  ),
                ),
              ),
              // Forma inferior derecha
              Positioned(
                bottom: -150,
                left: 230,
                child: Container(
                  width: 300,
                  height: 250,
                  decoration: BoxDecoration(
                    color: gColorTheme1_400.withOpacity(0.8),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              // Forma superior derecha
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
              // Contenido principal centrado
              Center(
                child: FractionallySizedBox(
                  widthFactor: 0.8,
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Título grande en negrita
                          const Text(
                            'Bienvenido a\nLearnScience',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 42,
                              fontWeight: FontWeight.w900,
                              color: Colors.black, // Color del título
                            ),
                          ),
                          const SizedBox(height: 32), // Espacio debajo del título
                          TextFormField(
                            controller: correoController,
                            decoration: const InputDecoration(
                              labelStyle: TextStyle(color: Colors.black), // Color de la etiqueta cuando no está enfocado// Color de la etiqueta cuando está enfocado
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: gColorTheme1_900), // Color del borde inferior cuando está enfocado
                              ),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.black), // Color del borde inferior cuando no está enfocado
                              ),
                              labelText: 'Correo Electrónico',
                            ),
                            keyboardType: TextInputType.emailAddress,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Por favor ingrese el correo electrónico';
                              }
                              if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                                return 'Por favor ingrese un correo electrónico válido';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: contrasenaController,
                            decoration: InputDecoration(
                              labelText: 'Contraseña',
                              labelStyle: const TextStyle(color: Colors.black), // Color de la etiqueta cuando no está enfocado// Color de la etiqueta cuando está enfocado
                              focusedBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(color: gColorTheme1_900), // Color del borde inferior cuando está enfocado
                              ),
                              enabledBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.black), // Color del borde inferior cuando no está enfocado
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscureText ? Icons.visibility : Icons.visibility_off,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _obscureText = !_obscureText;
                                  });
                                },
                              ),
                            ),
                            obscureText: _obscureText,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Por favor ingrese la contraseña';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: confirmacionContrasenaController,
                            decoration: const InputDecoration(
                              labelText: 'Confirmar Contraseña',
                              labelStyle: TextStyle(color: Colors.black), // Color de la etiqueta cuando no está enfocado// Color de la etiqueta cuando está enfocado
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: gColorTheme1_900), // Color del borde inferior cuando está enfocado
                              ),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.black), // Color del borde inferior cuando no está enfocado
                              ),
                            ),
                            obscureText: _obscureText,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Por favor confirme la contraseña';
                              }
                              if (value != contrasenaController.text) {
                                return 'Las contraseñas no coinciden';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          ToggleButtons(
                            isSelected: [_selectedRoleIndex == 0, _selectedRoleIndex == 1],
                            onPressed: (int index) {
                              setState(() {
                                _selectedRoleIndex = index;
                              });
                            },
                            children: const [
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 16.0),
                                child: Text('Estudiante'),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 16.0),
                                child: Text('Profesor'),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                           Row(
                            children: [
                              Checkbox(
                              value: _aceptaTerminos,
                              onChanged: (bool? value) {
                                setState(() {
                                  _aceptaTerminos = value ?? false;
                                });
                              },
                              activeColor: gColorTheme1_800, // Color del borde y del checkbox cuando está marcado
                              checkColor: gColorTheme1_1, // Color del icono dentro del checkbox cuando está marcado
                            ),
                              const Expanded(
                                child: Text('Acepta términos y condiciones'),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          SizedBox(
                            width: double.infinity, // Ocupa todo el ancho disponible
                            child: ElevatedButton(
                              onPressed: _aceptaTerminos ? _submitForm : null, 
                              style: ElevatedButton.styleFrom(
                                foregroundColor: gColorTheme1_900, // Color del texto del botón// Relleno del botón
                              ),
                                child: const Padding(
                                padding: EdgeInsets.symmetric(vertical: 16.0),
                                child: Text(
                                  'Registrarse',
                                  style: TextStyle(fontSize: 18,),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
