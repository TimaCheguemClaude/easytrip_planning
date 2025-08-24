// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';



class User {
  String email;
  String password;
  bool remember_me = false;
  User({
    required this.email,
    required this.password,
    required this.remember_me,
  });

  User copyWith({
    String? email,
    String? password,
    bool? remember_me,
  }) {
    return User(
      email: email ?? this.email,
      password: password ?? this.password,
      remember_me: remember_me ?? this.remember_me,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'email': email,
      'password': password,
      'remember_me': remember_me,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      email: map['email'] as String,
      password: map['password'] as String,
      remember_me: map['remember_me'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) => User.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'User(email: $email, password: $password, remember_me: $remember_me)';

  @override
  bool operator ==(covariant User other) {
    if (identical(this, other)) return true;
  
    return 
      other.email == email &&
      other.password == password &&
      other.remember_me == remember_me;
  }

  @override
  int get hashCode => email.hashCode ^ password.hashCode ^ remember_me.hashCode;
}
