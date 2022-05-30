// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:flutter_svg/flutter_svg.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:provider/provider.dart';

// 🌎 Project imports:
import 'package:enzitech_app/src/features/create_account/create_account_controller.dart';
import 'package:enzitech_app/src/features/create_account/widgets/create_account_first_step.dart';
import 'package:enzitech_app/src/features/create_account/widgets/create_account_second_step.dart';
import 'package:enzitech_app/src/shared/routes/route_generator.dart';
import 'package:enzitech_app/src/shared/themes/app_complete_theme.dart';
import 'package:enzitech_app/src/shared/widgets/ezt_button.dart';
import 'package:enzitech_app/src/shared/widgets/ezt_textfield.dart';

class CreateAccountPage extends StatefulWidget {
  const CreateAccountPage({Key? key}) : super(key: key);

  @override
  CreateAccountPageState createState() => CreateAccountPageState();
}

class CreateAccountPageState extends State<CreateAccountPage> {
  late final CreateAccountController controller;

  final _pageController = PageController(initialPage: 0);
  final ScrollController _scrollController = PageController();

  @override
  void initState() {
    super.initState();
    controller = context.read<CreateAccountController>();
  }

  // Widget get _textFields {
  //   return Column(
  //     children: [
  //       EZTTextField(
  //         eztTextFieldType: EZTTextFieldType.underline,
  //         labelText: "Nome",
  //         usePrimaryColorOnFocusedBorder: true,
  //         keyboardType: TextInputType.emailAddress,
  //         controller: _nameFieldController,
  //         onChanged: (value) => print(value),
  //       ),
  //       const SizedBox(height: 10),
  //       EZTTextField(
  //         eztTextFieldType: EZTTextFieldType.underline,
  //         labelText: "Instituição",
  //         usePrimaryColorOnFocusedBorder: true,
  //         keyboardType: TextInputType.emailAddress,
  //         controller: _institutionFieldController,
  //         onChanged: (value) => print(value),
  //         obscureText: true,
  //       ),
  //     ],
  //   );
  // }

  // Widget get _firstPage {
  //   return ;
  // }

  // Widget get _firstPage2 {
  //   return Center(
  //     child: SingleChildScrollView(
  //       child: Container(
  //         padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 64),
  //         child: Column(
  //           mainAxisAlignment: MainAxisAlignment.center,
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           children: [
  //             Align(
  //               alignment: Alignment.center,
  //               child: SvgPicture.asset(
  //                 AppSvgs.iconLogo,
  //                 alignment: Alignment.center,
  //                 width: 75,
  //               ),
  //             ),
  //             const SizedBox(height: 16),
  //             Center(
  //               child: Text(
  //                 "222Cadastre-se",
  //                 style: TextStyles.titleHome,
  //               ),
  //             ),
  //             const SizedBox(height: 64),
  //             Row(
  //               children: [
  //                 const Icon(
  //                   PhosphorIcons.identificationCardBold,
  //                   color: AppColors.greyLight,
  //                 ),
  //                 const SizedBox(width: 4),
  //                 Text(
  //                   'Dados pessoais',
  //                   style: TextStyles.detailBold,
  //                 ),
  //               ],
  //             ),
  //             _textFields,
  //             const SizedBox(height: 64),
  //             EZTButton(
  //               text: 'Próximo',
  //               onPressed: () {
  //                 Navigator.of(context).pushNamedAndRemoveUntil(
  //                     RouteGenerator.home, (route) => false);
  //               },
  //             ),
  //             const SizedBox(height: 16),
  //             EZTButton(
  //               text: 'Voltar',
  //               eztButtonType: EZTButtonType.outline,
  //               onPressed: () {
  //                 _pageController.animateTo(
  //                   0,
  //                   duration: const Duration(milliseconds: 150),
  //                   curve: Curves.easeIn,
  //                 );
  //               },
  //             ),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }

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
