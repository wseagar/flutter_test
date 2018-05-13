import 'package:dating/actions/auth_actions.dart';
import 'package:dating/models/app_state.dart';
import 'package:dating/models/user.dart';
import 'package:dating/presentation/platform_adaptive.dart';
import 'package:dating/screens/loading_screen.dart';
import 'package:dating/services/auth_service.dart';
import 'package:dating/styles/colors.dart';

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

class LoginForm extends StatefulWidget {
  @override
  _LoginFormState createState() => new _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final formKey = new GlobalKey<FormState>();
  Store<AppState> store;

  String _username;
  String _password;

  bool _autoValidate = false;

  void _submit() {
    final form = formKey.currentState;

    if (form.validate()) {
      form.save();
      store.dispatch(new UserLoginRequest());

      login(_username, _password)
        .then((user) => _loginSuccess(user))
        .catchError((e) => _loginError(e));
      
    } else {
      this.setState(() => _autoValidate = true);
    }
  }

  void _loginSuccess(User user) {
    store.dispatch(new UserLoginSuccess(user));
    Navigator.of(context).pushNamedAndRemoveUntil('/main', (_) => false);
  }

  void _loginError(e) {
    this.setState(() => _autoValidate = false);
    
    store.dispatch(new UserLoginFailure(e.toString()));
    
    Scaffold.of(context).showSnackBar(new SnackBar(
          content: new Text(e.toString()),
          duration: Duration(seconds: 3),
        ));
  }

  @override
  Widget build(BuildContext context) {
    store = StoreProvider.of(context);

    return new StoreConnector<AppState, _ViewModel>(
        converter: (Store<AppState> store) => _ViewModel.fromStore(store),
        builder: (BuildContext context, vm) {
          if (vm.isAuthenticating) {
            return new Center(
              child: new CircularProgressIndicator(
                  backgroundColor: colorStyles['gray'], strokeWidth: 2.0),
            );
          }
          return new Form(
              key: formKey,
              autovalidate: _autoValidate,
              child: new Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  new Container(
                      padding: EdgeInsets.only(right: 24.0 + 16.0),
                      child: new Column(
                        children: <Widget>[
                          buildUsernameField(),
                          buildPasswordField(),
                        ],
                      )),
                  new Container(
                      padding: new EdgeInsets.only(
                          top: 20.0, left: 40.0, right: 40.0),
                      child: new Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            buildLoginButton(),
                            new Padding(
                                padding: new EdgeInsets.only(top: 10.0)),
                            buildSignupButton()
                          ])),
                ],
              ));
        });
  }

  RichText buildSignupButton() {
    return new RichText(
        textAlign: TextAlign.center,
        text: new TextSpan(
            text: "Don't have an account? ",
            style: new TextStyle(color: colorStyles["light_font"]),
            children: <TextSpan>[
              new TextSpan(
                  text: "Signup here",
                  style: new TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                      decoration: TextDecoration.underline,
                      decorationColor: Colors.black))
            ]));
  }

  RaisedButton buildLoginButton() {
    return new RaisedButton(
        color: colorStyles["primary_light"],
        onPressed: () => _submit(),
        child: new Text("LOGIN",
            style: new TextStyle(color: colorStyles["light_font"])));
  }

  TextFormField buildPasswordField() {
    return new TextFormField(
      decoration: const InputDecoration(
          labelText: 'Password', icon: const Icon(Icons.lock)),
      validator: (val) => val.isEmpty ? 'Please enter your password' : null,
      onSaved: (val) => _password = val,
      obscureText: true,
    );
  }

  TextFormField buildUsernameField() {
    return new TextFormField(
      initialValue: _username ?? "",
      decoration: const InputDecoration(
          labelText: 'Username', icon: const Icon(Icons.person)),
      validator: (val) => val.isEmpty ? 'Please enter your username' : null,
      onSaved: (val) => _username = val,
    );
  }

  
}

class _ViewModel {
  final bool isAuthenticating;
  final String error;

  _ViewModel({this.isAuthenticating, this.error});

  static _ViewModel fromStore(Store<AppState> store) {
    return _ViewModel(
        error: store.state.auth.error,
        isAuthenticating: store.state.auth.isAuthenticating);
  }
}
