import 'dart:convert';

class Character {
  String name;
  String email;
  String password;
  String password_confirmation;
  String address;
  String contact;
  int type_user_id; // 1 for simple user, 2 for business user

  Character({
    required this.name,
    required this.email,
    required this.password,
    required this.password_confirmation,
    required this.address,
    required this.contact,
    required this.type_user_id,
  });

  Character copyWith({
    String? name,
    String? email,
    String? password,
    String? password_confirmation,
    String? address,
    String? contact,
    int? type_user_id,
  }) {
    return Character(
      name: name ?? this.name,
      email: email ?? this.email,
      password: password ?? this.password,
      password_confirmation: password_confirmation ?? this.password_confirmation,
      address: address ?? this.address,
      contact: contact ?? this.contact,
      type_user_id: type_user_id ?? this.type_user_id,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'email': email,
      'password': password,
      'password_confirmation': password_confirmation, // ✅ Add this
      'address': address,
      'contact': contact,
      'type_user_id': type_user_id,
    };
  }

  factory Character.fromMap(Map<String, dynamic> map) {
    return Character(
      name: map['name'] as String,
      email: map['email'] as String,
      password: map['password'] as String,
      password_confirmation: map['password_confirmation'] as String? ?? '',
      address: map['address'] as String,
      contact: map['contact'] as String,
      type_user_id: map['type_user_id'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory Character.fromJson(String source) =>
      Character.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'User(name: $name, email: $email, password: $password, password_confirmation: $password_confirmation, address: $address, contact: $contact, type_user_id: $type_user_id)';
  }

  @override
  bool operator ==(covariant Character other) {
    if (identical(this, other)) return true;

    return other.name == name &&
        other.email == email &&
        other.password == password &&
        other.password_confirmation == password_confirmation &&
        other.address == address &&
        other.contact == contact &&
        other.type_user_id == type_user_id;
  }

  @override
  int get hashCode {
    return name.hashCode ^
        email.hashCode ^
        password.hashCode ^
        password_confirmation.hashCode ^
        address.hashCode ^
        contact.hashCode ^
        type_user_id.hashCode;
  }
}
