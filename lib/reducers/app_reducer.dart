import 'package:redux_persist/redux_persist.dart';
import 'package:dating/models/app_state.dart';

import 'package:dating/reducers/auth_reducer.dart';
import 'package:dating/reducers/card_reducer.dart';

AppState appReducer(AppState state, action){
  if (action is PersistLoadedAction<AppState>) {
        return action.state ?? state;
  } else {
      return new AppState(
          auth: authReducer(state.auth, action),
          card: cardReducer(state.card, action)
      );
  }
}