import 'package:get/get.dart';
import 'package:proyect_nortenio_app/data/providers/remote/usuario_api.dart';
import 'package:meta/meta.dart' show required;

class UsuarioRepository {
  final UsuarioApi _api = Get.find<UsuarioApi>();

  Future<dynamic> iniciarSesion({
    @required String userName,
    @required String password,
    @required String token,
  }) =>
      _api.iniciarSesion(
        userName: userName,
        password: password,
        token: token,
      );
}
