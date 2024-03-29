import 'package:dating/actions/auth_actions.dart';
import 'package:dating/models/app_state.dart';
import 'package:dating/models/user.dart';
import 'package:dating/containers/cards_container.dart';
import 'package:dating/styles/colors.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

class MainScreen extends StatelessWidget {
  Store<AppState> store;

  @override
  Widget build(BuildContext context) {
    store = StoreProvider.of(context);

    return new StoreConnector<AppState, User>(
      converter: (Store<AppState> store) => store.state.auth.user,
      builder: (BuildContext context, User vm) => new DefaultTabController(
            length: 2,
            child: new Scaffold(
              drawer: new Drawer(
                child: new ListView(
                  // Important: Remove any padding from the ListView.
                  padding: EdgeInsets.zero,
                  children: <Widget>[
                    new UserAccountsDrawerHeader(
                      accountName: new Text(vm.id),
                      accountEmail: new Text(vm.id + "@gmail.com"),
                      currentAccountPicture: new CircleAvatar(
                        backgroundImage: new AssetImage('assets/will.jpg'),
                      ),
                    ),
                    new ListTile(
                      title: new Text('Logout'),
                      onTap: () {
                        store.dispatch(new UserLogoutRequest());
                        Navigator.of(context).pushNamedAndRemoveUntil('/login', (_) => false);
                      },
                    ),
                  ],
                ),
              ),
              appBar: new AppBar(
                title: new Text(
                  "Movies",
                  style: new TextStyle(color: colorStyles['primary']),
                ),
                actions: <Widget>[
                  new Icon(Icons.folder_special),
                ],
                iconTheme: new IconThemeData(
                  color: colorStyles['gray'],
                ),
                centerTitle: true,
                backgroundColor: Colors.white,
              ),
              body: new TabBarView(
                physics: new NeverScrollableScrollPhysics(),
                children: <Widget>[new CardsContainer(), new Text("Chat goes here")],
              ),
            ),
          ),
    );
  }
}
