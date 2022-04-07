class UserModel {
  final String? fullName;
  final String? email;
  final String? password;
  final String? phoneNumber;
  final String? imageUrl;
  final double? balance;

  bool? isAdmin;
  final bool? isOnline;
  final int? lastSeen;
  final String? userId;

  UserModel({
    this.fullName,
    this.email,
    this.userId,
    this.password,
    this.phoneNumber,
    this.imageUrl,
    this.balance,
    this.isOnline,
    this.lastSeen,
  });

  Map<String, dynamic> toJson() => {
        'fullName': fullName,
        'email': email,
        'password': password,
        'phoneNumber': phoneNumber,
        'imageUrl': imageUrl,
        'balance': balance,
        'isOnline': isOnline,
        'lastSeen': lastSeen,
        'isAdmin': isAdmin,
        'userId': userId,
      };

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        fullName: json['fullName'],
        email: json['email'],
        userId: json['userId'],
        phoneNumber: json['phoneNumber'],
        imageUrl: json['imageUrl'],
        isOnline: json['isOnline'],
        lastSeen: json['lastSeen'],
      );
}
