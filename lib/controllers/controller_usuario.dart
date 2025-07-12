import 'package:flutter_application/models/Usuario.dart';
import 'package:get/get.dart';
import '../requests/request_usuario.dart';
import 'package:get_storage/get_storage.dart';


class UsuarioController extends GetxController {
  final UsuarioService _usuarioService = UsuarioService();
  final box = GetStorage();

  var usuario = Rx<UsuarioModel?>(null);
  var isLoading = false.obs;
  var errorMessage = ''.obs;

  Future<void> loginUsuario(String correo, String contrasena) async {
    isLoading.value = true;
    try {
      final usuarioModel = UsuarioModel(
        correo: correo,
        contrasena: contrasena,
      );
      usuario.value = await _usuarioService.loginUsuario(usuarioModel);
      if (usuario.value != null) {
        errorMessage.value = '';
        box.write('idUsuario', usuario.value?.idUsuario);
      } else {
        errorMessage.value = 'Usuario o contraseña incorrectos';
      }
    } catch (e) {
      errorMessage.value = e.toString();
      usuario.value = null;
    } finally {
      isLoading.value = false;
    }
  }

  int? obtenerIdUsuarioGuardado() {
    return box.read('idUsuario');
  }


    Future<bool> registrarUsuario(UsuarioModel usuario) async {
    isLoading.value = true;
    try {
      final registrado = await _usuarioService.registrarUsuario(usuario);
      if (registrado) {
        errorMessage.value = 'Usuario registrado con éxito';
        return true;
      } else {
        errorMessage.value = 'Error al registrar usuario';
        return false;
      }
    } catch (e) {
      errorMessage.value = e.toString();
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  var usuarios = <UsuarioModel>[].obs;

  Future<void> obtenerUsuarios() async {
    try {
      final resultado = await _usuarioService.getUsuarios();
      usuarios.assignAll(resultado);
    } catch (e) {
      print("Error al obtener usuarios: $e");
    }
  }



  Future<void> eliminarUsuario(int idUsuario) async {
    isLoading.value = true;
    try {
      final success = await _usuarioService.eliminarUsuario(idUsuario);
      if (success) {
        errorMessage.value = 'Usuario eliminado con éxito';
      } else {
        errorMessage.value = 'Error al eliminar usuario';
      }
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }
}
