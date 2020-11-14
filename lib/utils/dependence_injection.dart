import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:proyect_nortenio_app/data/providers/local/local_auth.dart';
import 'package:proyect_nortenio_app/data/providers/local/local_distribuidor.dart';
import 'package:proyect_nortenio_app/data/providers/local/local_distribuidor_perfil.dart';
import 'package:proyect_nortenio_app/data/providers/local/local_gerente.dart';
import 'package:proyect_nortenio_app/data/providers/local/local_gerente_perfil.dart';
import 'package:proyect_nortenio_app/data/providers/local/local_motorizado.dart';
import 'package:proyect_nortenio_app/data/providers/remote/distribuidor/motorizado_api_D.dart';
import 'package:proyect_nortenio_app/data/providers/remote/distribuidor/punto_venta_api_D.dart';
import 'package:proyect_nortenio_app/data/providers/remote/gerente/billete_distribuidor_api_G.dart';
import 'package:proyect_nortenio_app/data/providers/remote/motorizado_perfil_api.dart';
import 'package:proyect_nortenio_app/data/providers/remote/distribuidor/principal_distribuidor_api.dart';
import 'package:proyect_nortenio_app/data/providers/remote/gerente/distribuidor_api_G.dart';
import 'package:proyect_nortenio_app/data/providers/remote/gerente/edicion_api_G.dart';
import 'package:proyect_nortenio_app/data/providers/remote/gerente/maps_api_G.dart';
import 'package:proyect_nortenio_app/data/providers/remote/gerente/principal_api_G.dart';
import 'package:proyect_nortenio_app/data/providers/remote/gerente/reporte_api_G.dart';
import 'package:proyect_nortenio_app/data/providers/remote/usuario_api.dart';
import 'package:proyect_nortenio_app/data/providers/remote/gerente/zona_api_G.dart';
import 'package:proyect_nortenio_app/data/repositories/local/local_distribuidor_repository.dart';
import 'package:proyect_nortenio_app/data/repositories/local/local_gerente_perfil_repository.dart';
import 'package:proyect_nortenio_app/data/repositories/local/local_gerente_repository.dart';
import 'package:proyect_nortenio_app/data/repositories/local/local_auth_repository.dart';
import 'package:proyect_nortenio_app/data/repositories/local/local_motorizado_perfil_repository.dart';
import 'package:proyect_nortenio_app/data/repositories/local/local_motorizado_repository.dart';
import 'package:proyect_nortenio_app/data/repositories/remote/billete_punto_venta_repository_D.dart';
import 'package:proyect_nortenio_app/data/repositories/remote/distribuidor/motorizado_repository_D.dart';
import 'package:proyect_nortenio_app/data/repositories/remote/distribuidor/punto_venta_repository_D.dart';
import 'package:proyect_nortenio_app/data/repositories/remote/gerente/billete_distribuidor_repository_G.dart';
import 'package:proyect_nortenio_app/data/repositories/remote/distribuidor/punto_venta_repository.dart';
import 'package:proyect_nortenio_app/data/repositories/remote/gerente/distribuidor_repository_G.dart';
import 'package:proyect_nortenio_app/data/repositories/remote/gerente/edicion_repository_G.dart';
import 'package:proyect_nortenio_app/data/repositories/remote/gerente/maps_repository_g.dart';
import 'package:proyect_nortenio_app/data/repositories/remote/gerente/principal_repository_G.dart';
import 'package:proyect_nortenio_app/data/repositories/remote/gerente/reporte_repository_G.dart';
import 'package:proyect_nortenio_app/data/repositories/remote/usuario_repository.dart';
import 'package:proyect_nortenio_app/data/repositories/remote/gerente/zona_repository_G.dart';
import 'package:proyect_nortenio_app/modules/distribuidor/billete_distribuidor/billete_distribuidor_controller.dart';
import 'package:proyect_nortenio_app/modules/distribuidor/billete_punto_venta/billete_punto_venta_controller.dart';
import 'package:proyect_nortenio_app/modules/distribuidor/motirizado/motirizado_controller.dart';
import 'package:proyect_nortenio_app/modules/distribuidor/punto_venta/punto_venta_controller.dart';
import 'package:proyect_nortenio_app/modules/distribuidor/tab/tab_principal_distribuidor_controller.dart';
import 'package:proyect_nortenio_app/modules/gerente/billetes/billetes_controller.dart';
import 'package:proyect_nortenio_app/modules/gerente/distribuidor/distribuidor_controller.dart';
import 'package:proyect_nortenio_app/modules/gerente/edicion/edicion_controller.dart';
import 'package:proyect_nortenio_app/modules/gerente/tab/inicio/principal_controller.dart';
import 'package:proyect_nortenio_app/modules/gerente/tab/maps/maps_controller.dart';
import 'package:proyect_nortenio_app/modules/gerente/tab/reporte/reporte_controller.dart';
import 'package:proyect_nortenio_app/modules/gerente/zona/zona_controller.dart';
import 'package:proyect_nortenio_app/modules/motorizado/billete_punto_venta/billete_punto_venta_controller.dart';
import 'package:proyect_nortenio_app/modules/motorizado/punto_venta/punto_venta_controller.dart';
import 'package:proyect_nortenio_app/modules/motorizado/tab/mapa/maps_controller.dart';
import 'package:proyect_nortenio_app/modules/motorizado/tab/tab_principal_motorizado_controller.dart';

class DependencyInjection {
  static void init() {
    Get.put<FlutterSecureStorage>(FlutterSecureStorage());
    Get.put<LocalAuth>(LocalAuth());
    Get.put<LocalGerente>(LocalGerente());
    Get.put<LocalDistribuidor>(LocalDistribuidor());
    Get.put<LocalMotorizado>(LocalMotorizado());
    Get.put<LocalMotorizadoPerfil>(LocalMotorizadoPerfil());
    Get.put<LocalGerentePerfil>(LocalGerentePerfil());

    //repositoreio
    Get.put<LocalAuthRepository>(LocalAuthRepository());
    Get.put<LocalGerenteRepository>(LocalGerenteRepository());
    Get.put<LocalDistribuidorRepository>(LocalDistribuidorRepository());
    Get.put<LocalMotorizadoPerfilRepository>(LocalMotorizadoPerfilRepository());
    Get.put<LocalMotorizadoRepository>(LocalMotorizadoRepository());
    Get.put<LocalGerentePerfilRepository>(LocalGerentePerfilRepository());

    // providers
    Get.put<UsuarioApi>(UsuarioApi());
    Get.put<DistribuidorApiG>(DistribuidorApiG());
    Get.put<ZonaApiG>(ZonaApiG());
    Get.put<PuntoVentaApiD>(PuntoVentaApiD());
    Get.put<EdicionApiG>(EdicionApiG());
    Get.put<PuntoVentaApiD>(PuntoVentaApiD());
    Get.put<BilleteDistribuidorApiG>(BilleteDistribuidorApiG());
    Get.put<BilletePuntoVentaApiD>(BilletePuntoVentaApiD());
    Get.put<ReporteApiG>(ReporteApiG());
    Get.put<MotorizadoApiD>(MotorizadoApiD());
    Get.put<MapsApiG>(MapsApiG());
    Get.put<PrincipalApiG>(PrincipalApiG());
    Get.put<PrincipalDistribuidorApi>(PrincipalDistribuidorApi());

    /// repositories
    Get.put<UsuarioRepository>(UsuarioRepository());
    Get.put<DistribuidorRepositoryG>(DistribuidorRepositoryG());
    Get.put<ZonaRepositoryG>(ZonaRepositoryG());
    Get.put<PuntoVentaRepositoryD>(PuntoVentaRepositoryD());
    Get.put<EdicionRepositoryG>(EdicionRepositoryG());
    Get.put<BilleteDistribuidorRepositoryG>(BilleteDistribuidorRepositoryG());
    Get.put<BilletePuntoVentaRepositoryD>(BilletePuntoVentaRepositoryD());
    Get.put<ReporteRepositoryG>(ReporteRepositoryG());
    Get.put<MotorizadoRepositoryD>(MotorizadoRepositoryD());
    Get.put<MapsRepositoryG>(MapsRepositoryG());
    Get.put<PrincipalRepositoryG>(PrincipalRepositoryG());
    Get.put<PrincipalDistribuidorRepository>(PrincipalDistribuidorRepository());

    //dependendias
    //distribuidor
    Get.put<PuntoVentaControllerD>(PuntoVentaControllerD());
    Get.put<MotorizadoControllerD>(MotorizadoControllerD());
    Get.put<BilleteControllerD>(BilleteControllerD());
    Get.put<BilletePuntoVentaControllerD>(BilletePuntoVentaControllerD());
    Get.put<PrincipalDistribuidorControllerD>(
        PrincipalDistribuidorControllerD());

    //gerente
    Get.put<BilletesControllerG>(BilletesControllerG());
    Get.put<DistribuidorControllerG>(DistribuidorControllerG());
    Get.put<EdicionControllerG>(EdicionControllerG());
    Get.put<ZonaControllerG>(ZonaControllerG());
    Get.put<PrincipalGerenteControllerG>(PrincipalGerenteControllerG());
    Get.put<MapsControllerG>(MapsControllerG());
    Get.put<ReporteControllerg>(ReporteControllerg());

    //motorizado
    Get.put<BilletePuntoVentaControllerM>(BilletePuntoVentaControllerM());
    Get.put<PuntoVentaControllerM>(PuntoVentaControllerM());
    Get.put<MapsControllerM>(MapsControllerM());
    Get.put<PrincipalMotorizadoController>(PrincipalMotorizadoController());
  }
}
