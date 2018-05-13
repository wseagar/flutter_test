import 'package:dating/models/auth_state.dart';
import 'package:dating/models/card_state.dart';
import 'package:meta/meta.dart';

@immutable
class AppState {
  final AuthState auth;
  final CardState card;

    AppState({AuthState auth, CardState card}):
        auth = auth ?? new AuthState(), card = card ?? new CardState();
        
  static AppState rehydrationJSON(dynamic json) => new AppState(
    auth: new AuthState.fromJSON(json['auth'])
  );

  Map<String, dynamic> toJson() => {
        'auth': auth.toJSON(),
    };

    AppState copyWith({
        bool rehydrated,
        AuthState auth,
    }) {
        return new AppState(
            auth: auth ?? this.auth,
            card: card ?? this.card
        );
    }

    @override
    String toString() {
        return '''AppState{
            auth: $auth,
            card: $card
        }''';
    }
}