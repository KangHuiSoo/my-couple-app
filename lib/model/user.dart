class User {
  final String id;
  final String name;
  final String? photoURL;
  final String? email;

  User({
    required this.id,
    required this.name,
    this.photoURL,
    this.email,
  });

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'] as String,
      name: map['name'] as String,
      photoURL: map['photoURL'] as String?,
      email: map['email'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'photoURL': photoURL,
      'email': email,
    };
  }
}
