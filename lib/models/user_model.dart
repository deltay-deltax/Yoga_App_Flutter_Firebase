class UserModel {
  final String uid;
  final String email;
  final String name;
  final bool membershipActive;

  UserModel({
    required this.uid,
    required this.email,
    required this.name,
    this.membershipActive = false,
  });

  Map<String, dynamic> toMap() => {
        'uid': uid,
        'email': email,
        'name': name,
        'membership_active': membershipActive,
      };

  factory UserModel.fromMap(Map<String, dynamic> map) => UserModel(
        uid: map['uid'] ?? '',
        email: map['email'] ?? '',
        name: map['name'] ?? '',
        membershipActive: map['membership_active'] ?? false,
      );
}
