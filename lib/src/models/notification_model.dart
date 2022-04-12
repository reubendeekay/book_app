import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationModel {
  final String? id;
  final String? imageUrl;
  final String? message;
  final Timestamp? createdAt;

  NotificationModel({this.id, this.imageUrl, this.message, this.createdAt});

  factory NotificationModel.fromJson(dynamic json) {
    return NotificationModel(
      id: json['id'],
      imageUrl: json['imageUrl'],
      message: json['message'],
      createdAt: json['createdAt'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'imageUrl': imageUrl,
        'message': message,
        'createdAt': createdAt,
      };
}
