class UserModel {
  final int? id;
  final String name;
  final String? nik;
  final String username;
  final String email;
  final String password;
  final String? phone;
  final String? address;
  final int createdAt;

  UserModel({
    this.id,
    required this.name,
    this.nik,
    required this.username,
    required this.email,
    required this.password,
    this.phone,
    this.address,
    int? createdAt,
  }) : createdAt = createdAt ?? DateTime.now().millisecondsSinceEpoch;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'nik': nik,
      'username': username,
      'email': email,
      'password': password,
      'phone': phone,
      'address': address,
      'createdAt': createdAt,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] as int?,
      name: map['name'] as String,
      nik: map['nik'] as String?,
      username: map['username'] as String? ?? '',
      email: map['email'] as String,
      password: map['password'] as String,
      phone: map['phone'] as String?,
      address: map['address'] as String?,
      createdAt: map['createdAt'] as int?,
    );
  }
}
