class UserModel {
  String? userId, name, photo, email;

  UserModel({this.name, this.email, this.photo, this.userId});

  UserModel.fromJson(Map<dynamic, dynamic>? map) {
    if (map == null) {
      return;
    }
    userId = map['userId'];
    name = map['name'];
    photo = map['photo'];
    email = map['email'];
  }

  toJson() {
    return {
      'userId': userId,
      'name': name,
      'photo': photo,
      'email': email,
    };
  }
}
