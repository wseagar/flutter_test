import 'package:redux/redux.dart';

import 'package:dating/reducers/app_reducer.dart';
import 'package:dating/models/app_state.dart';
import 'package:dating/middleware/middleware.dart';

Store<AppState> createStore() { 
    Store<AppState> store = new Store(
        appReducer,
        initialState: new AppState(),
        middleware: createMiddleware(),
    );
    persistor.load(store);

    return store;
}