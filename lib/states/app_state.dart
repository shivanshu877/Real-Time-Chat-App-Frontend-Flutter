import 'package:chat_app/api/api.dart';
import 'package:chat_app/models/message.model.dart';
import 'package:flutter/material.dart';
import 'package:chat_app/models/user.model.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

class AppState extends ChangeNotifier {
  UserModel? user;
  Map<String, List<MessageModel>> messages = {};
  List<UserModel> users = [];

  io.Socket socket = io.io(
    Api.baseURL,
    io.OptionBuilder()
        .setTransports(['websocket'])
        .disableAutoConnect()
        .build(),
  );

  void setUser(UserModel? value) {
    if (value == user) return;
    user = value;
    initSocket();
    notifyListeners();
  }

  void setUsers(List<UserModel> value) {
    users = value;
    notifyListeners();
  }

  void addMessage(String contactId, MessageModel message) {
    if (messages[contactId] == null) {
      messages[contactId] = [];
    }
    messages[contactId]!.add(message);
    notifyListeners();
  }

  void setMessages(String contactId, List<MessageModel> value) {
    messages[contactId] = value;
    notifyListeners();
  }

  void sendMessage(String contactId, String message) {
    socket.emit('sendMessage', {
      "to": contactId,
      "message": message,
    });

    addMessage(
        contactId,
        MessageModel(
          message: message,
          sender: user!.id,
          receiver: contactId,
          id: "-1",
          time: DateTime.now().toLocal().toString(),
        ));
  }

  void setStatus(String status) {
    user!.status = status;
    socket.emit('userStatusUpdate', {
      "status": status,
    });
    notifyListeners();
  }

  void update() {
    notifyListeners();
  }

  void initSocket() {
    debugPrint('initSocket');
    if (socket.connected) {
      socket.disconnect();
    }
    socket.connect();
    socket.onConnect((_) {
      debugPrint('connected');
      socket.emit('userLoggedIn', {"userId": user!.id});
    });

    socket.onDisconnect((_) {
      debugPrint('disconnected');
    });

    socket.onError((err) {
      debugPrint('error $err');
    });

    socket.on('incomingMessage', (data) {
      final msg = data as Map<String, dynamic>;
      if (msg["from"] == user!.id) return;

      addMessage(
        msg["from"],
        MessageModel(
          message: msg["content"],
          sender: msg["from"],
          receiver: user!.id,
          id: "-1",
          time: DateTime.now().toLocal().toString(),
        ),
      );

      debugPrint('message $msg');
    });

    socket.on('userStatusUpdated', (data) {
      debugPrint('userStatusUpdated $data');
      final status = data as Map<String, dynamic>;
      final user_ =
          users.firstWhere((element) => element.id == status["userId"]);
      user_.status = status["status"];
      notifyListeners();
    });
  }
}
