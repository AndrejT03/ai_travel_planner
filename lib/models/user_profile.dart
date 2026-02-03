class UserProfile {
  final String uid;
  final String fullName;
  final String username;
  final String address;
  final String phone;
  final String email;

  const UserProfile({
    required this.uid,
    required this.fullName,
    required this.username,
    required this.address,
    required this.phone,
    required this.email,
  });

  Map<String, dynamic> toMap() => {
    'fullName': fullName,
    'username': username,
    'address': address,
    'phone': phone,
    'email': email,
  };

  factory UserProfile.fromMap(String uid, Map<String, dynamic> map) {
    return UserProfile(
      uid: uid,
      fullName: (map['fullName'] ?? '') as String,
      username: (map['username'] ?? '') as String,
      address: (map['address'] ?? '') as String,
      phone: (map['phone'] ?? '') as String,
      email: (map['email'] ?? '') as String,
    );
  }
}