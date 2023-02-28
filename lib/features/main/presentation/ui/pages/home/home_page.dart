// 🎯 Dart imports:
import 'dart:async';
import 'dart:math' as math;

// 🐦 Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
// 📦 Package imports:
import 'package:flutter_svg/svg.dart';
import 'package:get_it/get_it.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

// 🌎 Project imports:
import '../../../../../../core/domain/service/connection_checker/connection_checker.dart';
import '../../../../../../core/enums/enums.dart';
import '../../../../../../core/failures/failures.dart';
import '../../../../../../core/routing/routing.dart';
import '../../../../../../shared/ui/ui.dart';
import '../../../../../../shared/ui/widgets/ezt_blink.dart';
import '../../../viewmodel/fragments/account_viewmodel.dart';
import '../../../viewmodel/fragments/enzymes_viewmodel.dart';
import '../../../viewmodel/fragments/experiments_viewmodel.dart';
import '../../../viewmodel/fragments/treatments_viewmodel.dart';
import '../../../viewmodel/home_viewmodel.dart';
import 'fragments/account_page.dart';
import 'fragments/enzymes_page.dart';
import 'fragments/experiments_page.dart';
import 'fragments/treatments_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  final GlobalKey _scaffold = GlobalKey();
  late final HomeViewmodel _homeViewmodel;
  late final AccountViewmodel _accountViewmodel;
  late final EnzymesViewmodel _enzymesViewmodel;
  late final ExperimentsViewmodel _experimentsViewmodel;
  late final TreatmentsViewmodel _treatmentsViewmodel;
  late final ConnectionChecker _connectionChecker;

  late final AnimationController animationControllerLogo = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 2),
  )..repeat();

  late List<Widget> _fragments;

  var _isVisibleExperimentButton; // ignore: prefer_typing_uninitialized_variables
  var _isVisibleTreatmentButton; // ignore: prefer_typing_uninitialized_variables
  var _isVisibleEnzymeButton; // ignore: prefer_typing_uninitialized_variables

  late StreamSubscription _connectivitySubscription;

  @override
  void initState() {
    super.initState();
    _homeViewmodel = GetIt.I.get<HomeViewmodel>();
    _accountViewmodel = GetIt.I.get<AccountViewmodel>();
    _enzymesViewmodel = GetIt.I.get<EnzymesViewmodel>();
    _experimentsViewmodel = GetIt.I.get<ExperimentsViewmodel>();
    _treatmentsViewmodel = GetIt.I.get<TreatmentsViewmodel>();
    _connectionChecker = GetIt.I.get<ConnectionChecker>();

    _connectionChecker.initialize();

    //Listen for connection change
    _connectivitySubscription =
        _connectionChecker.connectionChange.listen((event) {
      _homeViewmodel.setHasInternetConnection(event);

      if (!_homeViewmodel.hasInternetConnection) {
        EZTSnackBar.clear(context);
        noInternet(context);
      } else {
        if (_homeViewmodel.notifyInternetConnection) {
          EZTSnackBar.clear(context);
          EZTSnackBar.show(
            context,
            "✓ Conexão reestabelecida",
            centerTitle: true,
            eztSnackBarType: EZTSnackBarType.success,
          );
        }
      }
    });

    if (mounted) {
      setAllButtonsVisible();
      initFragements();

      _homeViewmodel.addListener(
        () {
          if (_homeViewmodel.state == StateEnum.error) {
            EZTSnackBar.show(
              context,
              HandleFailure.of(_homeViewmodel.failure!),
              eztSnackBarType: EZTSnackBarType.error,
            ).whenComplete(() async {
              if (_homeViewmodel.failure is ExpiredTokenOrWrongUserFailure ||
                  _homeViewmodel.failure is UserNotFoundOrWrongTokenFailure ||
                  _homeViewmodel.failure is SessionNotFoundFailure) {
                debugPrint("SAIR :)");
                _accountViewmodel.logout();

                if (_accountViewmodel.state == StateEnum.success && mounted) {
                  EZTSnackBar.show(
                    context,
                    "Faça seu login novamente.",
                  );
                  await Future.delayed(const Duration(milliseconds: 500));
                  if (mounted) {
                    Navigator.pushReplacementNamed(context, Routing.login);
                    _homeViewmodel.setFragmentIndex(0);
                  }
                }
              }
            });
          }
        },
      );

      _experimentsViewmodel.scrollController.addListener(() {
        if (_experimentsViewmodel
                .scrollController.position.userScrollDirection ==
            ScrollDirection.reverse) {
          if (_isVisibleExperimentButton == true && mounted) {
            setState(() {
              _isVisibleExperimentButton = false;
            });
          }
        }
        if (_experimentsViewmodel
                .scrollController.position.userScrollDirection ==
            ScrollDirection.forward) {
          if (_isVisibleExperimentButton == false && mounted) {
            setState(() {
              _isVisibleExperimentButton = true;
            });
          }
        }
      });

      _treatmentsViewmodel.scrollController.addListener(() {
        if (_treatmentsViewmodel
                .scrollController.position.userScrollDirection ==
            ScrollDirection.reverse) {
          if (_isVisibleTreatmentButton == true && mounted) {
            setState(() {
              _isVisibleTreatmentButton = false;
            });
          }
        }
        if (_treatmentsViewmodel
                .scrollController.position.userScrollDirection ==
            ScrollDirection.forward) {
          if (_isVisibleTreatmentButton == false && mounted) {
            setState(() {
              _isVisibleTreatmentButton = true;
            });
          }
        }
      });

      _enzymesViewmodel.scrollController.addListener(() {
        if (_enzymesViewmodel.scrollController.position.userScrollDirection ==
            ScrollDirection.reverse) {
          if (_isVisibleEnzymeButton == true && mounted) {
            setState(() {
              _isVisibleEnzymeButton = false;
            });
          }
        }
        if (_enzymesViewmodel.scrollController.position.userScrollDirection ==
            ScrollDirection.forward) {
          if (_isVisibleEnzymeButton == false && mounted) {
            setState(() {
              _isVisibleEnzymeButton = true;
            });
          }
        }
      });
    }
  }

  @override
  dispose() {
    _connectivitySubscription.cancel();

    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        animationControllerLogo.dispose();
      }
    });
    super.dispose();
  }

  setAllButtonsVisible() {
    if (mounted) {
      setState(() {
        _isVisibleExperimentButton = true;
        _isVisibleTreatmentButton = true;
        _isVisibleEnzymeButton = true;
      });
    }
  }

  initFragements() {
    _fragments = const [
      ExperimentsPage(),
      TreatmentsPage(),
      EnzymesPage(),
      AccountPage(),
    ];
  }

  // Widget errmsg(String text, bool show) {
  //   //error message widget.
  //   if (show == true) {
  //     //if error is true then show error message box
  //     return Container(
  //       padding: EdgeInsets.all(10.00),
  //       margin: EdgeInsets.only(bottom: 10.00),
  //       color: Colors.red,
  //       child: Row(children: [
  //         Container(
  //           margin: EdgeInsets.only(right: 6.00),
  //           child: Icon(Icons.info, color: Colors.white),
  //         ), // icon for error message

  //         Text(text, style: TextStyle(color: Colors.white)),
  //         //show error message text
  //       ]),
  //     );
  //   } else {
  //     return Container();
  //     //if error is false, return empty container.
  //   }
  // }

  Widget? get dealWithFloatingActionButton {
    if (_homeViewmodel.fragmentIndex == 0 && _isVisibleExperimentButton) {
      return FloatingActionButton.extended(
        onPressed: () {
          Navigator.pushNamed(
            context,
            Routing.createExperiment,
          );
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
      );
    }

    if (_homeViewmodel.fragmentIndex == 1 && _isVisibleTreatmentButton) {
      return FloatingActionButton.extended(
        onPressed: () {
          Navigator.pushNamed(
            context,
            Routing.createTreatment,
          );
        },
        label: Text(
          "Cadastrar\ntratamento",
          style: TextStyles.buttonBackground,
        ),
        icon: const Icon(
          PhosphorIcons.pencilLine,
          color: AppColors.white,
          size: 30,
        ),
      );
    }

    if (_accountViewmodel.user != null) {
      if (_homeViewmodel.fragmentIndex == 2 &&
          _accountViewmodel.user!.userType == UserTypeEnum.admin &&
          _isVisibleEnzymeButton) {
        return FloatingActionButton.extended(
          onPressed: () {
            Navigator.pushNamed(
              context,
              Routing.createEnzyme,
            );
          },
          label: Text(
            "Cadastrar\nenzima",
            style: TextStyles.buttonBackground,
          ),
          icon: const Icon(
            PhosphorIcons.pencilLine,
            color: AppColors.white,
            size: 30,
          ),
        );
      }

      return null;
    }
    return null;
  }

  static noInternet(context) {
    return EZTSnackBar.show(
      context,
      "⚠ Sem conexão com a internet: Você está visualizando informações previamente carregadas e sem atualizações!\n\nPara atualizar, conecte-se a uma rede com conexão à internet.",
      eztSnackBarType: EZTSnackBarType.error,
      duration: const Duration(seconds: 10),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _homeViewmodel,
      builder: (context, child) {
        return Scaffold(
          key: _scaffold,
          appBar: AppBar(
            title: SvgPicture.asset(
              AppSvgs.logo,
              fit: BoxFit.contain,
              alignment: Alignment.center,
            ),
            actions: [
              !_homeViewmodel.hasInternetConnection
                  ? Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: GestureDetector(
                        onTap: () => noInternet(context),
                        child: const EZTBlink(
                          interval: 750,
                          children: <Widget>[
                            Icon(
                              PhosphorIcons.wifiSlash,
                              color: Colors.white,
                            ),
                            // Icon(
                            //   PhosphorIcons.wifiSlash,
                            //   color: Colors.red[200],
                            // ),
                            Icon(
                              PhosphorIcons.wifiSlashBold,
                              color: Colors.red,
                            ),
                            // Icon(
                            //   PhosphorIcons.wifiSlash,
                            //   color: Colors.red[900],
                            // ),
                          ],
                        ),
                      ),
                    )
                  : Container(),
            ],
          ),
          body: AnimatedBuilder(
            animation: _homeViewmodel,
            builder: (context, child) {
              if (_homeViewmodel.state == StateEnum.loading) {
                return Center(
                  child: AnimatedBuilder(
                    animation: animationControllerLogo,
                    builder: (_, child) {
                      return Transform.rotate(
                        angle: animationControllerLogo.value * 2 * math.pi,
                        child: child,
                      );
                    },
                    child: SvgPicture.asset(
                      AppSvgs.iconLogo,
                      alignment: Alignment.center,
                      width: 75,
                    ),
                  ),
                );
              }

              return _fragments[_homeViewmodel.fragmentIndex];
            },
          ),
          floatingActionButton: dealWithFloatingActionButton,
          bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.shifting,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(PhosphorIcons.flask),
                label: 'Experimentos',
                backgroundColor: AppColors.primary,
              ),
              BottomNavigationBarItem(
                icon: Icon(PhosphorIcons.testTube),
                label: 'Tratamentos',
                backgroundColor: AppColors.primary,
              ),
              BottomNavigationBarItem(
                icon: Icon(PhosphorIcons.atom),
                label: 'Enzimas',
                backgroundColor: AppColors.primary,
              ),
              BottomNavigationBarItem(
                icon: Icon(PhosphorIcons.userCircleGear),
                label: 'Conta',
                backgroundColor: AppColors.primary,
              ),
            ],
            currentIndex: _homeViewmodel.fragmentIndex,
            selectedItemColor: AppColors.white,
            unselectedItemColor: Colors.white70,
            backgroundColor: AppColors.primary,
            onTap: (index) {
              setAllButtonsVisible();
              int beforeSet = _homeViewmodel.fragmentIndex;
              _homeViewmodel.setFragmentIndex(index);
              if (index == 0 &&
                  beforeSet == 0 &&
                  _experimentsViewmodel.scrollController.hasClients) {
                _experimentsViewmodel.scrollController.animateTo(
                  _experimentsViewmodel
                          .scrollController.position.minScrollExtent +
                      (kBottomNavigationBarHeight / 10000),
                  duration: const Duration(milliseconds: 1500),
                  curve: Curves.fastOutSlowIn,
                );
              } else if (index == 1 &&
                  beforeSet == 1 &&
                  _treatmentsViewmodel.scrollController.hasClients) {
                _treatmentsViewmodel.scrollController.animateTo(
                  _treatmentsViewmodel
                          .scrollController.position.minScrollExtent +
                      (kBottomNavigationBarHeight / 10000),
                  duration: const Duration(milliseconds: 1500),
                  curve: Curves.fastOutSlowIn,
                );
              } else if (index == 2 &&
                  beforeSet == 2 &&
                  _enzymesViewmodel.scrollController.hasClients) {
                _enzymesViewmodel.scrollController.animateTo(
                  _enzymesViewmodel.scrollController.position.minScrollExtent +
                      (kBottomNavigationBarHeight / 10000),
                  duration: const Duration(milliseconds: 1500),
                  curve: Curves.fastOutSlowIn,
                );
              }
            },
          ),
        );
      },
    );
  }
}
