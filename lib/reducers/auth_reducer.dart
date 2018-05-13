import 'package:redux/redux.dart';

import 'package:dating/actions/auth_actions.dart';
import 'package:dating/models/auth_state.dart';

Reducer<AuthState> authReducer = combineReducers([
  new TypedReducer<AuthState, UserLoginRequest>(userLoginRequestReducer),
  new TypedReducer<AuthState, UserLoginSuccess>(userLoginSuccessReducer),
  new TypedReducer<AuthState, UserLoginFailure>(userLoginFailureReducer),
  new TypedReducer<AuthState, UserLogoutRequest>(userLogoutRequestReducer)
]);

AuthState userLoginRequestReducer(AuthState auth, UserLoginRequest action) {
  return new AuthState().copyWith(
    isAuthenticated: false,
    isAuthenticating: true,
    error: null,
    user: null,
  );
}

AuthState userLoginSuccessReducer(AuthState auth, UserLoginSuccess action) {
  return new AuthState().copyWith(
    isAuthenticated: true,
    isAuthenticating: false,
    error: null,
    user: action.user
  );
}


AuthState userLoginFailureReducer(AuthState auth, UserLoginFailure action) {
  return new AuthState().copyWith(
    isAuthenticated: false,
    isAuthenticating: false,
    error: action.error,
    user: null
  );
}

AuthState userLogoutRequestReducer(AuthState auth, UserLogoutRequest action) {
  return new AuthState().copyWith(
    isAuthenticated: false,
    isAuthenticating: false,
    error: null,
    user: null
  );
}

