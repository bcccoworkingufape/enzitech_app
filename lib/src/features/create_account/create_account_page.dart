// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:provider/provider.dart';

// 🌎 Project imports:
import 'package:enzitech_app/src/features/create_account/create_account_controller.dart';
import 'package:enzitech_app/src/features/create_account/widgets/create_account_first_step.dart';
import 'package:enzitech_app/src/features/create_account/widgets/create_account_second_step.dart';

class CreateAccountPage extends StatefulWidget {
  const CreateAccountPage({Key? key}) : super(key: key);

  @override
  CreateAccountPageState createState() => CreateAccountPageState();
}

class CreateAccountPageState extends State<CreateAccountPage> {
  late final CreateAccountController controller;

  final _pageController = PageController(initialPage: 0);

  @override
  void initState() {
    super.initState();
    controller = context.read<CreateAccountController>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          CreateAccountFirstStep(pageController: _pageController),
          CreateAccountSecondStep(pageController: _pageController),
        ],
      ),
    );
  }
}
