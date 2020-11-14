import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoder/geocoder.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:proyect_nortenio_app/data/models/geolocalizacion.dart';
import 'package:proyect_nortenio_app/global_widgets/botonRedondo.dart';
import 'package:proyect_nortenio_app/global_widgets/loading_widget.dart';
import 'package:proyect_nortenio_app/utils/colores.dart';
import 'package:proyect_nortenio_app/utils/responsive.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

import '../punto_venta_controller.dart';

class GeolocalizacionPuntoVenta extends StatefulWidget {
  const GeolocalizacionPuntoVenta({
    Key key,
  }) : super(key: key);
  @override
  _GeolocalizacionPuntoVentaState createState() =>
      _GeolocalizacionPuntoVentaState();
}

class _GeolocalizacionPuntoVentaState extends State<GeolocalizacionPuntoVenta> {
  bool _isVisible = true;
  PuntoVentaControllerM _puntoVentaController = Get.find();

  Location _tracker = Location();
  Marker marker;
  Circle circle;
  GoogleMapController _googleMapController;
  StreamSubscription _streamSubscription;
  RoundedLoadingButtonController _btnControllerRegistrar;
  Geolocalizacion geolocalizacion;

  bool isSelectedLocation = true;

  static final CameraPosition initialLocation = CameraPosition(
    target: LatLng(-8.1243565, -79.0478844),
    zoom: 14.4746,
  );

  //function menu options
  void showMenuOptions() {
    setState(() {
      _isVisible = !_isVisible;
    });
  }

  @override
  void initState() {
    _btnControllerRegistrar = new RoundedLoadingButtonController();
    _init();
    super.initState();
  }

  @override
  void dispose() {
    if (_streamSubscription != null) {
      _streamSubscription.cancel();
    }
    super.dispose();
  }

  _init() {
    this.geolocalizacion = new Geolocalizacion(
        departamento: _puntoVentaController
            .puntoVentaEditar.value.geolocalizacion.departamento,
        direccion: _puntoVentaController
            .puntoVentaEditar.value.geolocalizacion.direccion,
        distrito: _puntoVentaController
            .puntoVentaEditar.value.geolocalizacion.distrito,
        latitud: _puntoVentaController
            .puntoVentaEditar.value.geolocalizacion.latitud,
        longitud: _puntoVentaController
            .puntoVentaEditar.value.geolocalizacion.longitud,
        pais: _puntoVentaController.puntoVentaEditar.value.geolocalizacion.pais,
        provincia: _puntoVentaController
            .puntoVentaEditar.value.geolocalizacion.provincia,
        id: _puntoVentaController.puntoVentaEditar.value.geolocalizacion.id,
        puntoVentasId: _puntoVentaController
            .puntoVentaEditar.value.geolocalizacion.puntoVentasId);
  }

  //Function for updateMarkerAndCircle
  void updateMarker(LocationData newLocalData) {
    LatLng latlng = LatLng(newLocalData.latitude, newLocalData.longitude);
    this.setState(() {
      marker = Marker(
        onDragEnd: (latlng) {
          geolocalizacion.latitud = latlng.latitude;
          geolocalizacion.longitud = latlng.longitude;
        },
        markerId: MarkerId("marcador"),
        position: latlng,
        draggable: true,
        zIndex: 2,
        anchor: Offset(0.5, 0.5),
      );
    });
  }

  //Function for capture your current position
  void getCurrentLocationCar() async {
    try {
      if (isSelectedLocation) {
        var location = await _tracker.getLocation();

        updateMarker(location);

        if (_streamSubscription != null) {
          _streamSubscription.cancel();
        }

        _streamSubscription = _tracker.onLocationChanged.listen((newLocalData) {
          if (_googleMapController != null) {
            if (isSelectedLocation) {
              _googleMapController.animateCamera(CameraUpdate.newCameraPosition(
                  new CameraPosition(
                      bearing: 100,
                      target:
                          LatLng(newLocalData.latitude, newLocalData.longitude),
                      tilt: 0,
                      zoom: 18.00)));

              updateMarker(newLocalData);
              isSelectedLocation = false;
            }
          }
        });
      }
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        debugPrint("Permission Denied");
      }
    }
  }

  List<Address> results = [];

  Future<bool> buscarDireccion() async {
    try {
      Coordinates coordinates =
          Coordinates(marker.position.latitude, marker.position.longitude);
      var results =
          await Geocoder.local.findAddressesFromCoordinates(coordinates);
      this.setState(() {
        this.results = results;
        if (this.results != null && this.results.length > 0) {
          Address address = this.results[0];
          geolocalizacion.departamento = address.adminArea;
          geolocalizacion.pais = address.countryName;
          geolocalizacion.direccion = address.addressLine;
          geolocalizacion.provincia = address.subAdminArea;
          geolocalizacion.distrito = address.locality;
          geolocalizacion.latitud = marker.position.latitude;
          geolocalizacion.longitud = marker.position.longitude;
          return true;
        }
      });
      return true;
    } catch (e) {
      print("Error occured: $e");
      return false;
    }
  }

  _iniciarLocalizacion() {
    if (geolocalizacion != null) {
      if (geolocalizacion.longitud != 0.0) {
        LatLng latlng =
            LatLng(geolocalizacion.latitud, geolocalizacion.longitud);
        if (_googleMapController != null) {
          _googleMapController.animateCamera(CameraUpdate.newCameraPosition(
              new CameraPosition(
                  bearing: 100,
                  target: LatLng(latlng.latitude, latlng.longitude),
                  tilt: 0,
                  zoom: 18.00)));
        }
        this.setState(() {
          marker = Marker(
            onDragEnd: (latlng) {
              geolocalizacion.latitud = latlng.latitude;
              geolocalizacion.longitud = latlng.longitude;
            },
            markerId: MarkerId("marcador"),
            position: latlng,
            draggable: true,
            zIndex: 2,
            anchor: Offset(0.5, 0.5),
          );
        });
        /* buscarDireccion(); */
      }
    }
  }

  void _updatePosition(CameraPosition _position) {
    LatLng latlng =
        LatLng(_position.target.latitude, _position.target.longitude);
    this.setState(() {
      marker = Marker(
        markerId: MarkerId("marcador"),
        onDragEnd: (latlng) {
          geolocalizacion.latitud = latlng.latitude;
          geolocalizacion.longitud = latlng.longitude;
        },
        position: latlng,
        draggable: true,
        zIndex: 2,
        anchor: Offset(0.5, 0.5),
      );
      /*  buscarDireccion(); */
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: ListTile(
            subtitle: Text(_puntoVentaController
                .puntoVentaEditar.value.geolocalizacion.direccion),
            onTap: () async {
              await mostrarDireccion(context);
            },
          ),
          leading: IconButton(
              icon: Icon(
                Icons.arrow_back_ios,
                color: Colores.textosColorGris,
              ),
              onPressed: () => Navigator.pop(context)),
          actions: [],
        ),
        body: Stack(
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: GoogleMap(
                zoomGesturesEnabled: true,
                initialCameraPosition: initialLocation,
                markers: Set.of((marker != null) ? [marker] : []),
                circles: Set.of((circle != null) ? [circle] : []),
                onMapCreated: (GoogleMapController controller) {
                  _googleMapController = controller;
                  _iniciarLocalizacion();
                },
                onCameraMove: ((_position) {
                  _updatePosition(_position);
                }),
              ),
            ),
            Obx(() => _puntoVentaController.cargando.value == true
                ? loading()
                : Container())
          ],
        ),
        floatingActionButton: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 50,
              width: 50,
              decoration:
                  BoxDecoration(shape: BoxShape.circle, color: Colors.white),
              child: IconButton(
                  icon: Icon(
                    Icons.check,
                    color: Colors.greenAccent,
                  ),
                  onPressed: () async {
                    await mostrarDireccion(context);
                  }),
            ),
            SizedBox(width: 5.0),
            Container(
              height: 50,
              width: 50,
              decoration:
                  BoxDecoration(shape: BoxShape.circle, color: Colors.white),
              child: IconButton(
                  icon: Icon(
                    Icons.location_searching,
                    color: Colors.blueAccent,
                  ),
                  onPressed: () {
                    isSelectedLocation = true;
                    getCurrentLocationCar();
                  }),
            ),
          ],
        ));
  }

  Future mostrarDireccion(BuildContext context) async {
    dynamic estados = await buscarDireccion();
    if (estados) {
      bool estado = await showModal(context);
      if (estado != null && estado == true) {
        dynamic estad = await _puntoVentaController.actualizarGeolocalizacion(
            geolocalizacion: geolocalizacion);

        if (estad) {
          Navigator.pop(context);
        }
      }
    }
  }

  Future<bool> showModal(BuildContext context) async {
    final Responsive rosponsive = Responsive.of(context);
    final double butonSize = rosponsive.widthPercent(80);
    bool estado = false;
    bool respnse = await showModalBottomSheet(
        context: context,
        builder: (builder) {
          return Container(
            color: Colors.white,
            child: ListView(
              children: [
                Container(
                  padding: EdgeInsets.all(5),
                  width: double.infinity,
                  color: Colors.yellow,
                  child: Column(
                    children: [
                      ListTile(
                        leading: Icon(Icons.location_searching),
                        title: Text("Localización"),
                        subtitle: Text(geolocalizacion.direccion),
                      ),
                    ],
                  ),
                ),
                ListTile(
                  title: Text("Pais"),
                  subtitle: Text(geolocalizacion.pais),
                ),
                ListTile(
                  title: Text("Departamento"),
                  subtitle: Text(geolocalizacion.departamento),
                ),
                ListTile(
                  title: Text("Provincia"),
                  subtitle: Text(geolocalizacion.provincia),
                ),
                ListTile(
                  title: Text("Distrito"),
                  subtitle: Text(geolocalizacion.distrito),
                ),
                ListTile(
                  title: Text("Dirección"),
                  subtitle: Text(geolocalizacion.direccion),
                ),
                BotonRedondo(
                  icon: Icon(
                    Icons.save,
                    color: Colors.white,
                    size: 30,
                  ),
                  width: butonSize * 0.9,
                  btnController: _btnControllerRegistrar,
                  titulo: "Actualizar",
                  onPressed: () {
                    estado = true;
                    _btnControllerRegistrar.reset();
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          );
        });
    if (respnse != null) {
      print("dsfds");
    }
    return estado;
  }
}
