import 'package:chat_app/api/api.dart';
import 'home_page/home_page.dart';
import 'package:chat_app/states/app_state.dart';
import 'package:flutter/material.dart';
import 'package:chat_app/pages/signin_page.dart';
import 'package:provider/provider.dart';

class SignupPage extends StatelessWidget {
  const SignupPage({super.key});

  static String routeName = '/signup';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 400),
                  child: const SignUpForm(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SignUpForm extends StatefulWidget {
  const SignUpForm({
    super.key,
  });

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String _error = '';

  void _signUp() async {
    setState(() {
      _error = "";
    });
    Api.signUp(
      _usernameController.text,
      _emailController.text,
      _passwordController.text,
    ).then((value) {
      var (error, message, user) = value;
      if (error) {
        setState(() {
          _error = message;
        });
      } else {
        Provider.of<AppState>(context, listen: false).user = user;
        Navigator.pushNamed(context, HomePage.routeName);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            const Spacer(),
            Text(
              'Fill the following info to signup',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const Spacer(),
          ],
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _usernameController,
          decoration: const InputDecoration(
            labelText: 'Username',
            hintText: 'Enter your username',
          ),
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _emailController,
          decoration: const InputDecoration(
            labelText: 'Email',
            hintText: 'Enter your email',
          ),
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _passwordController,
          decoration: const InputDecoration(
            labelText: 'Password',
            hintText: 'Enter your password',
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FilledButton.tonal(
              onPressed: _signUp,
              child: const Text('Sign Up'),
            ),
            const SizedBox(width: 16),
            OutlinedButton(
              onPressed: () {
                Navigator.pushNamed(context, SignInPage.routeName);
              },
              child: const Text('Sign In'),
            ),
          ],
        ),
        if (_error.isNotEmpty) ...[
          const SizedBox(height: 16),
          Text(
            _error,
            style: const TextStyle(color: Colors.red),
          ),
        ]
      ],
    );
  }
}
