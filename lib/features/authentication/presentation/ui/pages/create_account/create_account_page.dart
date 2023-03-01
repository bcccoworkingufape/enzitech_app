// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:get_it/get_it.dart';

// 🌎 Project imports:
import '../../../../../../core/enums/enums.dart';
import '../../../../../../core/failures/failures.dart';
import '../../../../../../core/routing/routing.dart';
import '../../../../../../shared/ui/ui.dart';
import '../../../viewmodel/create_account_viewmodel.dart';
import 'components/create_account_first_step.dart';
import 'components/create_account_second_step.dart';

class CreateAccountPage extends StatefulWidget {
  const CreateAccountPage({Key? key}) : super(key: key);

  @override
  CreateAccountPageState createState() => CreateAccountPageState();
}

class CreateAccountPageState extends State<CreateAccountPage> {
  late final CreateAccountViewmodel _createAccountViewmodel;

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
    userDataCache.updateAll((key, value) => '');

    _createAccountViewmodel = GetIt.I.get<CreateAccountViewmodel>();

    _createAccountViewmodel.addListener(() {
      if (_createAccountViewmodel.state == StateEnum.error) {
        EZTSnackBar.show(
          context,
          HandleFailure.of(
            _createAccountViewmodel.failure!,
            overrideDefaultMessage: true,
          ),
          eztSnackBarType: EZTSnackBarType.error,
        );
      } else if (_createAccountViewmodel.state == StateEnum.success) {
        EZTSnackBar.show(
          context,
          "Conta criada com sucesso!",
          eztSnackBarType: EZTSnackBarType.success,
        );

        Navigator.pushNamedAndRemoveUntil(
          context,
          Routing.login,
          (Route<dynamic> route) => false,
        );
      }
    });
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
