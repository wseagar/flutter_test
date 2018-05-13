class Profile {
  final String name;
  final int age;
  final String imgPath;

  Profile(this.name, this.age, this.imgPath);

  @override
  String toString() {
    return '{name: $name, age: $age, imgPath: $imgPath}';
  }
}
