import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:toggle_switch/toggle_switch.dart';

import '../../shared/themes/app_colors.dart';
import '../../shared/themes/app_text_styles.dart';
import '../../shared/widgets/ezt_textfield.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final _searchFieldController = TextEditingController(text: '');
  List<bool> isSelected = [true, false];
  int _selectedIndex = 0;

   List<Widget> _widgetOptions = [
     Container(),
     Container(),
     Container()
   ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: SvgPicture.asset(
            'assets/images/logo.svg',
            fit: BoxFit.contain,
            alignment: Alignment.center,
          ),
        ),
        body: Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            children: [

              EZTTextField(
                eztTextFieldType: EZTTextFieldType.underline,
                labelText: "Pesquisar Experimento",
                usePrimaryColorOnFocusedBorder: true,
                keyboardType: TextInputType.name,
                controller: _searchFieldController,
                suffixIcon: const Icon(
                  Icons.search,
                  color: AppColors.primary,
                  size: 35,
                ),
              ),

              const SizedBox(height: 20,),

              Container(
                height: 45,
                child: ToggleSwitch(
                  minWidth: 500,
                  initialLabelIndex: 0,
                  totalSwitches: 2,
                  labels: ['Em andamento', 'Concluído'],
                  inactiveBgColor: AppColors.background,
                  inactiveFgColor: AppColors.primary,
                  activeFgColor: AppColors.background,
                  borderColor: [AppColors.primary,AppColors.primary],
                  borderWidth: 2,
                  customTextStyles: [
                    isSelected[0] ? TextStyles.buttonBoldBackground : TextStyles.buttonBoldPrimary,
                    isSelected[1] ? TextStyles.buttonBoldBackground : TextStyles.buttonBoldPrimary
                  ],
                  onToggle: (index) {
                    print(index);
                    print(isSelected);
                    print("----------");
                    if(index == 0 && !isSelected[0]){
                      isSelected[0] = !isSelected[0];
                      isSelected[1] = !isSelected[1];
                    }else if(index == 1 && !isSelected[1]){
                      isSelected[1] = !isSelected[1];
                      isSelected[0] = !isSelected[0];
                    }
                    print(index);
                    print(isSelected);
                  }
                ),
              ),

              const SizedBox(height: 20,),

              Expanded(
                  child: ScrollConfiguration(
                    behavior: const ScrollBehavior(),
                    child: GlowingOverscrollIndicator(
                      axisDirection: AxisDirection.down,
                      color: AppColors.primary,
                      child: ListView(
                        children: [

                          Container(
                            color: Colors.white24,
                            padding: const EdgeInsets.all(10),

                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Experimento 1",
                                        style: TextStyles.titleHome,
                                      ),
                                      SizedBox(height: 5,),
                                      Text(
                                        "Modificado em 01/01/2020",
                                        style: TextStyles.bodyMinRegular,
                                      ),
                                      SizedBox(height: 10,),
                                      Text(
                                        "Descrição opcional de experimento bem detalhado com no máximo quatro linhas...",
                                        style: TextStyles.bodyRegular,
                                      ),
                                    ],
                                  ),
                                ),

                                SizedBox(width: 20,),

                                CircularPercentIndicator(
                                  radius: 40,
                                  lineWidth: 10.0,
                                  percent: 0.66,
                                  center: Text(
                                    "66%",
                                    style: TextStyles.buttonPrimary,
                                  ),
                                  progressColor: AppColors.primary,
                                ),

                                SizedBox(width: 10,),
                              ],
                            ),

                          ),

                          SizedBox(height: 10,),

                          Container(
                            color: Colors.white24,
                            padding: const EdgeInsets.all(10),

                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Experimento 2",
                                        style: TextStyles.titleHome,
                                      ),
                                      SizedBox(height: 5,),
                                      Text(
                                        "Modificado em 01/01/2020",
                                        style: TextStyles.bodyMinRegular,
                                      ),
                                      SizedBox(height: 10,),
                                      Text(
                                        "Descrição opcional de experimento bem detalhado com no máximo quatro linhas...",
                                        style: TextStyles.bodyRegular,
                                      ),
                                    ],
                                  ),
                                ),

                                SizedBox(width: 20,),

                                CircularPercentIndicator(
                                  radius: 40,
                                  lineWidth: 10.0,
                                  percent: 0.66,
                                  center: Text(
                                    "66%",
                                    style: TextStyles.buttonPrimary,
                                  ),
                                  progressColor: AppColors.primary,
                                ),

                                SizedBox(width: 10,),
                              ],
                            ),

                          ),

                          SizedBox(height: 10,),

                          Container(
                            color: Colors.white24,
                            padding: const EdgeInsets.all(10),

                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Experimento 3",
                                        style: TextStyles.titleHome,
                                      ),
                                      SizedBox(height: 5,),
                                      Text(
                                        "Modificado em 01/01/2020",
                                        style: TextStyles.bodyMinRegular,
                                      ),
                                      SizedBox(height: 10,),
                                      Text(
                                        "Descrição opcional de experimento bem detalhado com no máximo quatro linhas...",
                                        style: TextStyles.bodyRegular,
                                      ),
                                    ],
                                  ),
                                ),

                                SizedBox(width: 20,),

                                CircularPercentIndicator(
                                  radius: 40,
                                  lineWidth: 10.0,
                                  percent: 0.66,
                                  center: Text(
                                    "66%",
                                    style: TextStyles.buttonPrimary,
                                  ),
                                  progressColor: AppColors.primary,
                                ),

                                SizedBox(width: 10,),
                              ],
                            ),

                          ),

                          SizedBox(height: 10,),

                          Container(
                            color: Colors.white24,
                            padding: const EdgeInsets.all(10),

                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Experimento 4",
                                        style: TextStyles.titleHome,
                                      ),
                                      SizedBox(height: 5,),
                                      Text(
                                        "Modificado em 01/01/2020",
                                        style: TextStyles.bodyMinRegular,
                                      ),
                                      SizedBox(height: 10,),
                                      Text(
                                        "Descrição opcional de experimento bem detalhado com no máximo quatro linhas...",
                                        style: TextStyles.bodyRegular,
                                      ),
                                    ],
                                  ),
                                ),

                                SizedBox(width: 20,),

                                CircularPercentIndicator(
                                  radius: 40,
                                  lineWidth: 10.0,
                                  percent: 0.66,
                                  center: Text(
                                    "66%",
                                    style: TextStyles.buttonPrimary,
                                  ),
                                  progressColor: AppColors.primary,
                                ),

                                SizedBox(width: 10,),
                              ],
                            ),

                          ),

                          SizedBox(height: 10,),

                          Container(
                            color: Colors.white24,
                            padding: const EdgeInsets.all(10),

                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Experimento 5",
                                        style: TextStyles.titleHome,
                                      ),
                                      SizedBox(height: 5,),
                                      Text(
                                        "Modificado em 01/01/2020",
                                        style: TextStyles.bodyMinRegular,
                                      ),
                                      SizedBox(height: 10,),
                                      Text(
                                        "Descrição opcional de experimento bem detalhado com no máximo quatro linhas...",
                                        style: TextStyles.bodyRegular,
                                      ),
                                    ],
                                  ),
                                ),

                                SizedBox(width: 20,),

                                CircularPercentIndicator(
                                  radius: 40,
                                  lineWidth: 10.0,
                                  percent: 0.66,
                                  center: Text(
                                    "66%",
                                    style: TextStyles.buttonPrimary,
                                  ),
                                  progressColor: AppColors.primary,
                                ),

                                SizedBox(width: 10,),
                              ],
                            ),

                          ),

                          SizedBox(height: 10,),



                        ],
                      ),
                    ),
                  ),
              ),


            ],
          ),
        ),

        floatingActionButton: FloatingActionButton.extended(
            onPressed: () {},
            label: Text(
              "Cadastrar\nExperimento",
              style: TextStyles.buttonBoldBackground,
            ),
          icon: Icon(Icons.add, color: AppColors.background, size: 30),
        ),

        bottomNavigationBar: BottomNavigationBar(
          items: const [
            BottomNavigationBarItem(
              icon: Icon(MdiIcons.beakerOutline),
              label: 'Experimentos',
            ),
            BottomNavigationBarItem(
              icon: Icon(MdiIcons.testTube),
              label: 'Tratamentos',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.people_outline),
              label: 'Perfil',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: AppColors.background,
          backgroundColor: AppColors.primary,
          onTap: _onItemTapped,

    ),


    );
  }
}



