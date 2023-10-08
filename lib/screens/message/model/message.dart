import 'dart:convert';

class MessageModel {
  int orderId;
  int senderId;
  int receiverId;
  String message;
  MessageModel({
    required this.orderId,
    required this.senderId,
    required this.receiverId,
    required this.message,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'orderId': orderId,
      'senderId': senderId,
      'receiverId': receiverId,
      'message': message,
    };
  }

  factory MessageModel.fromMap(Map<String, dynamic> map) {
    return MessageModel(
      orderId: map['orderId'] as int,
      senderId: map['senderId'] as int,
      receiverId: map['receiverId'] as int,
      message: map['message'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory MessageModel.fromJson(String source) =>
      MessageModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
