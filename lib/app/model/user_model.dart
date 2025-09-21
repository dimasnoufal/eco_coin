class UserModel {
  final String uid;
  final String email;
  final String namaLengkap;
  final String namaPanggilan;
  final String? phoneNumber;
  final String? address;
  final String? bio;
  final DateTime createdAt;
  final DateTime updatedAt;

  UserModel({
    required this.uid,
    required this.email,
    required this.namaLengkap,
    required this.namaPanggilan,
    this.phoneNumber,
    this.address,
    this.bio,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      uid: json['uid'] ?? '',
      email: json['email'] ?? '',
      namaLengkap: json['namaLengkap'] ?? '',
      namaPanggilan: json['namaPanggilan'] ?? '',
      phoneNumber: json['phoneNumber'],
      address: json['address'],
      bio: json['bio'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'email': email,
      'namaLengkap': namaLengkap,
      'namaPanggilan': namaPanggilan,
      'phoneNumber': phoneNumber,
      'address': address,
      'bio': bio,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  UserModel copyWith({
    String? uid,
    String? email,
    String? namaLengkap,
    String? namaPanggilan,
    String? phoneNumber,
    String? address,
    String? bio,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      namaLengkap: namaLengkap ?? this.namaLengkap,
      namaPanggilan: namaPanggilan ?? this.namaPanggilan,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      address: address ?? this.address,
      bio: bio ?? this.bio,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
