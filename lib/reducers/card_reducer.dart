import 'package:redux/redux.dart';

import 'package:dating/actions/card_actions.dart';
import 'package:dating/models/card_state.dart';

Reducer<CardState> cardReducer = combineReducers([
  new TypedReducer<CardState, OpacityChangeMessage>(opacityChangeMessageReducer),
]);

CardState opacityChangeMessageReducer(CardState auth, OpacityChangeMessage action) {
  return new CardState().copyWith(
    heartOpacity: action.heartOpacity,
    crossOpacity: action.crossOpacity,
  );
}