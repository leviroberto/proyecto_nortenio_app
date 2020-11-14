import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:proyect_nortenio_app/global_widgets/botonRedondo.dart';
import 'package:proyect_nortenio_app/global_widgets/input_form.dart';
import 'package:proyect_nortenio_app/modules/iniciar_sesion/iniciar_sesion_controller.dart';
import 'package:proyect_nortenio_app/utils/colores.dart';
import 'package:proyect_nortenio_app/utils/responsive.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

class FormularioInciarSesion extends StatefulWidget {
  final BuildContext contextPadre;

  const FormularioInciarSesion({@required this.contextPadre});
  //static const routeName = 'login';

  @override
  _FormularioInciarSesionState createState() => _FormularioInciarSesionState();
}

class _FormularioInciarSesionState extends State<FormularioInciarSesion> {
  RoundedLoadingButtonController _btnControllerIniciarSesion;
  FocusNode _focusPassword;
  GlobalKey<FormState> _formKey;
  bool _passwordVisible;

  @override
  void initState() {
    _passwordVisible = false;
    _btnControllerIniciarSesion = new RoundedLoadingButtonController();
    _focusPassword = FocusNode();
    _formKey = GlobalKey();
    super.initState();
  }

  @override
  void dispose() {
    _focusPassword.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Responsive rosponsive = Responsive.of(context);

    final double butonSize = rosponsive.widthPercent(80);
    return GetBuilder<IniciarSesionController>(
      builder: (state) => SafeArea(
        top: false,
        child: Container(
          width: 330,
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                InputForm(
                  label: "Usuario",
                  icon: Icon(Icons.person),
                  hint: "l953187894",
                  onChanged: state.onUserNameChanged,
                  onFieldSubmitted: (String email) {
                    _focusPassword.nextFocus();
                  },
                ),
                InputForm(
                  onPressedIconPassword: () {
                    setState(() {
                      _passwordVisible = !_passwordVisible;
                    });
                  },
                  passwordVisible: _passwordVisible,
                  isPassword: true,
                  label: "Contraseña",
                  icon: Icon(Icons.vpn_key),
                  hint: "********",
                  onChanged: state.onPasswordChanged,
                  focusNone: _focusPassword,
                  onFieldSubmitted: (String password) {
                    state.submit(
                        btnControllerIniciarSesion: _btnControllerIniciarSesion,
                        context: widget.contextPadre);
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    CupertinoButton(
                        padding: EdgeInsets.zero,
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 1),
                          margin: EdgeInsets.symmetric(horizontal: 20),
                          child: Text(
                            "¿Olvidaste tu Contraseña?",
                            style: TextStyle(
                              color: Colores.colorButton,
                              fontSize: 12,
                              fontFamily: 'sans',
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        onPressed: () {}),
                  ],
                ),
                SizedBox(height: rosponsive.diagonalPercent(6)),
                BotonRedondo(
                  width: butonSize * 0.9,
                  btnController: _btnControllerIniciarSesion,
                  titulo: "Iniciar Sesion",
                  onPressed: () {
                    state.submit(
                        btnControllerIniciarSesion: _btnControllerIniciarSesion,
                        context: widget.contextPadre);
                  },
                ),
                SizedBox(height: rosponsive.diagonalPercent(3)),
                /*Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("¿No tienes una cuenta?"),
                    CupertinoButton(
                      child: Text(
                        "Resgistrate",
                        style: TextStyle(
                          fontFamily: 'sans',
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      onPressed: () {},
                    )
                  ],
                ),*/
              ],
            ),
          ),
        ),
      ),
    );
  }
}
