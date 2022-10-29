// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:provider/provider.dart';

// 🌎 Project imports:
import 'package:enzitech_app/src/features/create_account/ui/components/create_account_first_step.dart';
import 'package:enzitech_app/src/features/create_account/ui/components/create_account_second_step.dart';
import 'package:enzitech_app/src/features/create_account/viewmodel/create_account_viewmodel.dart';
import 'package:enzitech_app/src/shared/business/domain/enums/enums.dart';
import 'package:enzitech_app/src/shared/ui/ui.dart';
import 'package:enzitech_app/src/shared/utilities/utilities.dart';

class CreateAccountPage extends StatefulWidget {
  const CreateAccountPage({Key? key}) : super(key: key);

  @override
  CreateAccountPageState createState() => CreateAccountPageState();
}

class CreateAccountPageState extends State<CreateAccountPage> {
  late final CreateAccountViewmodel viewmodel;

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
    viewmodel = context.read<CreateAccountViewmodel>();
    userDataCache.updateAll((key, value) => '');
    if (mounted) {
      viewmodel.addListener(() {
        if (viewmodel.state == StateEnum.error && mounted) {
          EZTSnackBar.show(
            context,
            HandleFailure.of(
              viewmodel.failure!,
              overrideDefaultMessage: true,
            ),
            eztSnackBarType: EZTSnackBarType.error,
          );
        } else if (viewmodel.state == StateEnum.success) {
          EZTSnackBar.show(
            context,
            "Conta criada com sucesso!",
            eztSnackBarType: EZTSnackBarType.success,
          );

          Navigator.pushNamedAndRemoveUntil(
            context,
            RouteGenerator.auth,
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
