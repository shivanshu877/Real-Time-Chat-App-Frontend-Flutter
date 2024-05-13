import 'package:chat_app/api/api.dart';
import 'package:chat_app/models/message.model.dart';
import 'package:chat_app/models/user.model.dart';
import 'package:chat_app/states/app_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'widgets/body_right.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  static String routeName = '/home';

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Padding(
        padding: EdgeInsets.all(8.0),
        child: HomePageBody(),
      ),
    );
  }
}

class HomePageBody extends StatefulWidget {
  const HomePageBody({
    super.key,
  });

  @override
  State<HomePageBody> createState() => _HomePageBodyState();
}

class _HomePageBodyState extends State<HomePageBody> {
  List<UserModel> users = [];

  int selectedUserInd = 0;

  void updateSelectedUser(int index) {
    var appState = Provider.of<AppState>(context, listen: false);
    if (appState.messages[users[index].id] != null) {
      setState(() {
        selectedUserInd = index;
      });
      return;
    }

    Api.getMessages(users[selectedUserInd].id, appState.user!.id).then((value) {
      var (error, _, messages_) = value;
      if (error) {
        return;
      }
      setState(() {
        appState.setMessages(users[index].id, messages_!);
        selectedUserInd = index;
      });
    });
  }

  @override
  void initState() {
    super.initState();

    Api.getAllUsers().then((value) {
      var (error, _, users_) = value;
      if (error) {
        return;
      }

      setState(() {
        users = users_!;
        updateSelectedUser(0);
        Provider.of<AppState>(context, listen: false).setUsers(users);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: BodyLeft(
            selectedUserInd: selectedUserInd,
            updateSelectedUser: updateSelectedUser,
          ),
        ),
        if (users.isNotEmpty)
          Expanded(
            flex: 7,
            child: BodyRight(
              selectedUserInd: selectedUserInd,
            ),
          ),
      ],
    );
  }
}

class BodyLeft extends StatelessWidget {
  const BodyLeft({
    super.key,
    required this.selectedUserInd,
    required this.updateSelectedUser,
  });

  final int selectedUserInd;
  final Function(int) updateSelectedUser;

  @override
  Widget build(BuildContext context) {
    var appState = Provider.of<AppState>(context);

    return Column(
      children: [
        Row(
          children: [
            const CircleAvatar(
              child: Icon(Icons.account_circle),
            ),
            const SizedBox(width: 8),
            Text(appState.user!.name),
            const Spacer(),
            const Text("Busy"),
            const SizedBox(width: 8),
            Checkbox(
                value: appState.user!.isBusy(),
                onChanged: (v) {
                  if (v!) {
                    appState.setStatus("BUSY");
                  } else {
                    appState.setStatus("AVAILABLE");
                  }
                }),
            const SizedBox(width: 16),
          ],
        ),
        const SizedBox(height: 32),
        Expanded(
          child: ListView.builder(
            itemCount: appState.users.length,
            itemBuilder: (context, index) {
              var user = appState.users[index];
              return ListTile(
                dense: false,
                selectedTileColor:
                    Theme.of(context).hoverColor.withOpacity(0.1),
                title: Text(user.name),
                subtitle: Text(user.status),
                leading: const CircleAvatar(
                  child: Icon(Icons.account_circle),
                ),
                trailing: const Icon(Icons.arrow_forward_ios),
                selected: index == selectedUserInd,
                onTap: () {
                  updateSelectedUser(index);
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
