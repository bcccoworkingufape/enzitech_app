// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:provider/provider.dart';

// 🌎 Project imports:
import 'package:enzitech_app/src/features/auth/auth_controller.dart';
import 'package:enzitech_app/src/shared/routes/route_generator.dart';
import '../../shared/failures/failures.dart';
import 'components/auth_button.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({Key? key}) : super(key: key);

  @override
  AuthPageState createState() => AuthPageState();
}

class AuthPageState extends State<AuthPage> {
  late final AuthController controller;

  @override
  void initState() {
    super.initState();
    controller = context.read<AuthController>();

    if (mounted) {
      controller.addListener(() {
        if (controller.state == AuthState.error) {
          if (controller.failure is ForbiddenFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(controller.failure!.message)));
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Erro na autenticação')));
          }
        } else if (controller.state == AuthState.success) {
          Navigator.of(context).pushReplacementNamed(RouteGenerator.home);
        }
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Auth'),
        actions: const [AuthButton()],
      ),
      body: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Email',
              ),
              onChanged: (value) {
                //Do something
              },
            ),
            const SizedBox(height: 10),
            TextField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Password',
              ),
              onChanged: (value) {
                //Do something
              },
            ),
            const SizedBox(height: 13),
            const AuthButton(),
          ],
        ),
      ),
    );
  }
}
