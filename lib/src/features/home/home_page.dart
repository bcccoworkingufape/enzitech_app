// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:flutter_svg/svg.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:provider/provider.dart';
import 'package:toggle_switch/toggle_switch.dart';

// 🌎 Project imports:
import 'package:enzitech_app/src/features/home/components/experiment_card.dart';
import 'package:enzitech_app/src/features/home/home_controller.dart';
import 'package:enzitech_app/src/shared/validator/validator.dart';
import '../../shared/themes/app_colors.dart';
import '../../shared/themes/app_text_styles.dart';
import '../../shared/widgets/ezt_textfield.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final HomeController controller;

  final _searchTermController = TextEditingController(text: '');
  List<bool> isSelected = [true, false];
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    controller = context.read<HomeController>();
    if (mounted) {
      controller.addListener(() {
        if (controller.state == HomeState.error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(controller.failure!.message),
            ),
          );
        }
      });
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget get _searchTermInput {
    final validations = <ValidateRule>[
      ValidateRule(
        ValidateTypes.name,
      ),
    ];

    final fieldValidator = FieldValidator(validations, context);

    return EZTTextField(
      controller: _searchTermController,
      lineHeight: 1.8,
      eztTextFieldType: EZTTextFieldType.underline,
      hintText: "Pesquisar experimento",
      usePrimaryColorOnFocusedBorder: true,
      keyboardType: TextInputType.name,
      suffixIcon: const Icon(
        PhosphorIcons.magnifyingGlass,
        color: AppColors.primary,
        size: 35,
      ),
      fieldValidator: fieldValidator,
    );
  }

  Widget _buildExperimentsList(double height) {
    if (controller.state == HomeState.loading) {
      return Column(
        children: [
          SizedBox(
            height: height / 3,
          ),
          const CircularProgressIndicator(),
          SizedBox(
            height: height / 3,
          ),
        ],
      );
    }

    return Visibility(
      visible: controller.mockedList.isNotEmpty,
      replacement: Column(
        children: [
          SizedBox(height: height / 4),
          Column(
            children: const [
              Icon(PhosphorIcons.folderDotted, size: 64),
              Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 35.0),
                  child: Text(
                    "Não existem experimentos!",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                      color: AppColors.greyDark,
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: height / 4)
        ],
      ),
      child: ListView.builder(
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        itemCount: controller.mockedList.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: controller.mockedList[index],
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var widthMQ = MediaQuery.of(context).size.width;
    var heightMQ = MediaQuery.of(context).size.height;
    final controller = context.watch<HomeController>();

    return Scaffold(
      appBar: AppBar(
        title: SvgPicture.asset(
          'assets/images/logo.svg',
          fit: BoxFit.contain,
          alignment: Alignment.center,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: _searchTermInput,
            ),
            const SizedBox(
              height: 16,
            ),
            ToggleSwitch(
              minWidth: widthMQ,
              totalSwitches: 2,
              labels: const ['Em andamento', 'Concluído'],
              activeFgColor: AppColors.white,
              inactiveFgColor: AppColors.primary,
              activeBgColor: const [AppColors.primary],
              inactiveBgColor: AppColors.white,
              borderColor: const [AppColors.primary],
              borderWidth: 1.5,
              onToggle: (index) {
                print(index);
                // call controller to update search when this changes
              },
            ),
            const SizedBox(
              height: 16,
            ),
            Expanded(
              child: ScrollConfiguration(
                behavior: const ScrollBehavior(),
                child: GlowingOverscrollIndicator(
                  axisDirection: AxisDirection.down,
                  color: AppColors.primary,
                  child: _buildExperimentsList(heightMQ),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          //TODO: REMOVER ESTE TESTE
          if (controller.mockedList.isEmpty) {
            controller.setMockedList([
              ExperimentCard(
                name: 'Experimento 1',
                modifiedAt: DateTime.now(),
                description:
                    'Esta é uma descrição opcional muito grande de experimento, bem detalhado, com muitas linhas, onde será permitido no máximo quatro linhas...',
                progress: .55,
              ),
            ]);
          } else {
            controller.setMockedList([]);
          }
        },
        label: Text(
          "Cadastrar\nexperimento",
          style: TextStyles.buttonBackground,
        ),
        icon: const Icon(
          PhosphorIcons.pencilLine,
          color: AppColors.white,
          size: 30,
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(PhosphorIcons.flask),
            label: 'Experimentos',
          ),
          BottomNavigationBarItem(
            icon: Icon(PhosphorIcons.testTube),
            label: 'Tratamentos',
          ),
          BottomNavigationBarItem(
            icon: Icon(PhosphorIcons.userCircleGear),
            label: 'Perfil',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: AppColors.white,
        backgroundColor: AppColors.primary,
        onTap: _onItemTapped,
      ),
    );
  }
}
