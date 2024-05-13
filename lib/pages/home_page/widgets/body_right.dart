import 'package:chat_app/models/message.model.dart';
import 'package:chat_app/states/app_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BodyRight extends StatefulWidget {
  const BodyRight({
    super.key,
    required this.selectedUserInd,
  });

  final int selectedUserInd;

  @override
  State<BodyRight> createState() => _BodyRightState();
}

class _BodyRightState extends State<BodyRight> {
  final TextEditingController _messageController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    var selectedUser = appState.users[widget.selectedUserInd];
    var messages = appState.messages[selectedUser.id] ?? [];
    return Column(
      children: [
        ListTile(
          title: Text(selectedUser.name),
          subtitle: Text(selectedUser.status),
          leading: const CircleAvatar(
            child: Icon(Icons.account_circle),
          ),
        ),
        Expanded(
          child: Card(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 8.0,
              ),
              child: Column(
                children: [
                  const Row(),
                  ...(messages.map((e) {
                    if (e.receiver == appState.user!.id &&
                        e.sender != appState.user!.id) {
                      return RecievedMessage(message: e);
                    } else {
                      return SentMessage(message: e);
                    }
                  }).toList()),
                ],
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _messageController,
                  decoration: const InputDecoration(
                    hintText: 'Type a message',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                    ),
                  ),
                ),
              ),
              IconButton(
                onPressed: () {
                  if (_messageController.text.isNotEmpty) {
                    appState.sendMessage(
                      selectedUser.id,
                      _messageController.text,
                    );
                    _messageController.clear();
                  }
                },
                icon: const Icon(Icons.send),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class SentMessage extends StatelessWidget {
  const SentMessage({
    super.key,
    required this.message,
  });

  final MessageModel message;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Card(
            elevation: 0,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  minWidth: 100,
                  minHeight: 8,
                ),
                child: Text(message.message),
              ),
            ),
          ),
          const SizedBox(width: 8),
          const CircleAvatar(
            child: Icon(Icons.account_circle),
          ),
        ],
      ),
    );
  }
}

class RecievedMessage extends StatelessWidget {
  const RecievedMessage({
    super.key,
    required this.message,
  });
  final MessageModel message;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircleAvatar(
            child: Icon(Icons.account_circle),
          ),
          const SizedBox(width: 8),
          Card(
            elevation: 0,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  minWidth: 100,
                  minHeight: 8,
                ),
                child: Text(message.message),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
