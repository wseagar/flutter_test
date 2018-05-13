import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux_persist_flutter/redux_persist_flutter.dart';

import 'package:dating/presentation/platform_adaptive.dart';
import 'package:dating/store/store.dart';
import 'package:dating/middleware/middleware.dart';
import 'package:dating/models/app_state.dart';

import 'package:dating/screens/loading_screen.dart';
import 'package:dating/screens/login_screen.dart';
import 'package:dating/screens/main_screen.dart';

import 'package:flutter/rendering.dart';


void main() {
  debugPaintSizeEnabled = false;
  runApp(new DatingApp());
}
class DatingApp extends StatelessWidget {
  final store = createStore();

  @override
  Widget build(BuildContext context) {
      return new PersistorGate(
        persistor: persistor,
        loading: new LoadingScreen(),
        builder: (context) => new StoreProvider<AppState>(
          store: store,
          child: new MaterialApp(
            title: "DatingApp",
            theme: defaultTargetPlatform == TargetPlatform.iOS ? kIOSTheme : kDefaultTheme,
            routes: <String, WidgetBuilder>{
              '/' : (BuildContext context) => new StoreConnector<AppState, dynamic>(
                converter: (store) => store.state.auth.isAuthenticated,
                builder: (BuildContext context, isAuthenticated) => isAuthenticated ? new MainScreen() : new LoginScreen()
              ),
              '/login': (BuildContext) => new LoginScreen(),
              '/main': (BuildContext) => new MainScreen()
            }
          )
        )
      );
    }
}
