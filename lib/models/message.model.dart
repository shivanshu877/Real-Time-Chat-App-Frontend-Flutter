class MessageModel {
  String message;
  String sender;
  String receiver;
  String time;
  String id;

  MessageModel({
    required this.message,
    required this.sender,
    required this.receiver,
    required this.time,
    required this.id,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      message: json['content'] as String,
      sender: json['sender'] as String,
      receiver: json['recipient'] as String,
      time: json['timestamp'] as String,
      id: json['_id'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'sender': sender,
      'receiver': receiver,
      'time': time,
      'id': id,
    };
  }
}
