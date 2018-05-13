import 'dart:async';
import 'dart:math';

import 'package:dating/models/user.dart';


final Duration delay = const Duration(milliseconds: 3000);

Future<User> login(String username, String password) {
  return new Future.delayed(delay)
    .then((_) {
      if (username.toLowerCase().contains("fail")){
        throw new Exception("Invalid password");
      }
      return new User(_randomString(32), username);
  });
}

String _randomString(int length) {
  var rand = new Random();
  var codeUnits = new List.generate(
    length, 
    (index){
        return rand.nextInt(33)+89;
    }
  );
  return new String.fromCharCodes(codeUnits);
}