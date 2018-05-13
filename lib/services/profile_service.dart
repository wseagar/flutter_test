import 'dart:async';
import 'dart:math';

import '../models/profile.dart';

final Duration delay = const Duration(milliseconds: 3000);


Future<List<Profile>> getProfiles() {
  return new Future.delayed(delay)
    .then((_) {
      return _profiles();
  });
}

List<Profile> _profiles() {
  var profiles = new List<Profile>();
  profiles.add(new Profile("Will", 24, 'assets/will.jpg', 3, 5));
  profiles.add(new Profile("Will", 24, 'assets/will.jpg', 3, 5));
  profiles.add(new Profile("Will", 24, 'assets/will.jpg', 3, 5));
  profiles.add(new Profile("Will", 24, 'assets/will.jpg', 3, 5));
  profiles.add(new Profile("Will", 24, 'assets/will.jpg', 3, 5));

  return profiles;
}




