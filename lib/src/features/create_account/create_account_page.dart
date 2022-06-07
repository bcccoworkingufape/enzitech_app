// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:provider/provider.dart';

// 🌎 Project imports:
import 'package:enzitech_app/src/features/create_account/create_account_controller.dart';
import 'package:enzitech_app/src/features/create_account/widgets/create_account_first_step.dart';
import 'package:enzitech_app/src/features/create_account/widgets/create_account_second_step.dart';
import 'package:enzitech_app/src/shared/routes/route_generator.dart';

class CreateAccountPage extends StatefulWidget {
  const CreateAccountPage({Key? key}) : super(key: key);

  @override
  CreateAccountPageState createState() => CreateAccountPageState();
}

class CreateAccountPageState extends State<CreateAccountPage> {
  late final CreateAccountController controller;

  final _pageController = PageController(initialPage: 0);
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  var userDataCache = {
    "name": "",
    "institution": "",
    "email": "",
    "password": "",
    "confirmPassword": "",
    "enableNext": "",
  };

  @override
  void initState() {
    super.initState();
    controller = context.read<CreateAccountController>();
    userDataCache.updateAll((key, value) => '');
    if (mounted) {
      controller.addListener(() {
        if (controller.state == CreateAccountState.error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(controller.failure!.message),
            ),
          );
        } else if (controller.state == CreateAccountState.success) {
          Navigator.pushNamedAndRemoveUntil(
            context,
            RouteGenerator.home,
            (Route<dynamic> route) => false,
          );
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: PageView(
          controller: _pageController,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            CreateAccountFirstStep(
              pageController: _pageController,
              formKey: _formKey,
              userDataCache: userDataCache,
            ),
            CreateAccountSecondStep(
              pageController: _pageController,
              formKey: _formKey,
              userDataCache: userDataCache,
            ),
          ],
        ),
      ),
    );
  }
}
