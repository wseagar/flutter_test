class Profile {
  final String name;
  final int age;
  final String imgPath;

  final int commonFriends;
  final int commonLikes;

  Profile(this.name, this.age, this.imgPath, this.commonFriends, this.commonLikes);

  @override
  String toString() {
    return '{name: $name, age: $age, imgPath: $imgPath, commonFriends: $commonFriends, commonLikes: $commonLikes}';
  }
}
