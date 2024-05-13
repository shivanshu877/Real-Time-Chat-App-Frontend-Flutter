class UserModel {
  final String id;
  final String name;
  final String email;
  String status;
  String prevStatus;

  static const List<String> statuses = ["AVAILABLE", "BUSY", "ONLINE"];

  bool isAvailable() {
    return status == statuses[0];
  }

  bool isBusy() {
    return status == statuses[1];
  }

  bool isOnline() {
    return status == statuses[2];
  }

  void setAvailable() {
    status = statuses[0];
  }

  void setBusy() {
    status = statuses[1];
  }

  void setOnline() {
    status = statuses[2];
  }

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.status,
    required this.prevStatus,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      name: json['username'] as String,
      email: json['email'] as String,
      status: json['status'] as String,
      prevStatus: json['prevstatus'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'status': status,
      'prevStatus': prevStatus,
    };
  }
}
