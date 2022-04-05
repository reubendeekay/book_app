class UserModel {
  final String? fullName;
  final String? email;
  final String? password;
  final String? phoneNumber;
  final String? imageUrl;
  final double? balance;

  final String? chatRoomId;

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
    this.isAdmin,
    this.chatRoomId,
  });
}
