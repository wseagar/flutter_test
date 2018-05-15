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
  profiles.add(new Profile("Avengers: Infinity War", 86, 'assets/avengers.jpg', 3, 5));
  profiles.add(new Profile("Fifty Shades Freed", 60, 'assets/50shades.jpg', 3, 5));
  profiles.add(new Profile("Black Panther", 73, 'assets/panther.jpg', 3, 5));
  profiles.add(new Profile("Dirty Dead Con Men", 40, 'assets/deadconmen.jpg', 3, 5));
  profiles.add(new Profile("Zootopia", 77, 'assets/zootopia.jpg', 3, 5));

  return profiles;
}




