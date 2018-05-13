import 'package:flutter/material.dart';
import 'package:redux/redux.dart';

import 'package:dating/models/user.dart';
import 'package:dating/models/app_state.dart';

class UserLoginRequest {
  
}

class UserLoginSuccess {
  final User user;

  UserLoginSuccess(this.user);
}

class UserLoginFailure {
  final String error;

  UserLoginFailure(this.error);
}

class UserLogoutRequest { }