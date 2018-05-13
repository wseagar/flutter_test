import 'package:flutter/material.dart';
import 'package:dating/styles/colors.dart' show colorStyles;

import '../containers/login_form.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Container(
          child: new Padding(
              padding: new EdgeInsets.fromLTRB(
                  32.0, MediaQuery.of(context).padding.top + 32.0, 32.0, 16.0),
              child: new Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    new Expanded(
                        flex: 5,
                        child: new Center(
                            child: new FlutterLogo(
                                colors: colorStyles['primary'], size: 200.0))),
                    new LoginForm(),
                    new Expanded(
                        flex: 1,
                        child: new Align(
                            alignment: FractionalOffset.bottomCenter,
                            child: buildTOCText()))
                  ]))),
    );
  }

  RichText buildTOCText() {
    return new RichText(
        textAlign: TextAlign.center,
        text: new TextSpan(
            text: "By signing up you agree to our ",
            style:
                new TextStyle(color: colorStyles["light_font"], fontSize: 12.0),
            children: <TextSpan>[
              new TextSpan(
                  text: "Terms", style: new TextStyle(color: Colors.black)),
              new TextSpan(
                  text: " and ",
                  style: new TextStyle(color: colorStyles["light_font"])),
              new TextSpan(
                  text: "Privacy Policy.",
                  style: new TextStyle(color: Colors.black))
            ]));
  }
}
