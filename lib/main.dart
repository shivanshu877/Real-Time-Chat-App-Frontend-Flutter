import 'package:flutter/material.dart';
import "pages/home_page/home_page.dart";
import "pages/signup_page.dart";
import 'package:provider/provider.dart';
import 'package:chat_app/states/app_state.dart';
import 'package:chat_app/pages/signin_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AppState()),
      ],
      child: MaterialApp(
        title: 'Chat App',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        darkTheme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.grey,
            brightness: Brightness.dark,
          ),
          useMaterial3: true,
        ),
        themeMode: ThemeMode.dark,
        routes: {
          HomePage.routeName: (context) => const HomePage(),
          SignupPage.routeName: (context) => const SignupPage(),
          SignInPage.routeName: (context) => const SignInPage(),
        },
        initialRoute: SignupPage.routeName,
      ),
    );
  }
}
