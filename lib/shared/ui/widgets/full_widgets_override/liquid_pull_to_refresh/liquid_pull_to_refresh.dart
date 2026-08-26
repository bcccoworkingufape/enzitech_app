library;

// 🎯 Dart imports:
import 'dart:async';
import 'dart:math' as math;
import 'dart:math';

// 🐦 Flutter imports:
import 'package:material_ui/material_ui.dart';

// 🌎 Project imports:
import 'src/circular_progress.dart';
import 'src/clipper.dart';

// A distância de over-scroll que move o indicador até o máximo
// de deslocamento, como percentual da extensão do contêiner rolável.
const double _kDragContainerExtentPercentage = 0.25;

// Quanto o gesto de arrasto da rolagem pode ultrapassar o deslocamento do LiquidPullToRefresh;
// deslocamento máximo = _kDragSizeFactorLimit * deslocamento.
const double _kDragSizeFactorLimit = 1.5;

// Quando a rolagem termina, a duração da animação do indicador de progresso
// até o deslocamento do LiquidPullToRefresh.
// const Duration _kIndicatorSnapDuration = Duration(milliseconds: 150);

// A duração da ScaleTransitionIn da caixa que começa quando a ação de
// refresh é concluída.
const Duration _kIndicatorScaleDuration = Duration(milliseconds: 200);

/// A assinatura de uma função chamada quando o usuário arrasta um
/// [LiquidPullToRefresh] o suficiente para demonstrar que deseja que o app
/// atualize. O [Future] retornado deve completar quando a operação de refresh
/// terminar.
///
/// Usada por [LiquidPullToRefresh.onRefresh].
typedef RefreshCallback = Future<void> Function();

// A máquina de estados percorre estes modos somente quando a rolagem
// identificada por scrollableKey foi rolada até seu limite mínimo ou máximo.
enum _LiquidPullToRefreshMode {
  drag, // Pointer is down.
  armed, // Dragged far enough that an up event will run the onRefresh callback.
  snap, // Animating to the indicator's final "displacement".
  refresh, // Running the refresh callback.
  done, // Animating the indicator's fade-out after refreshing.
  canceled, // Animating the indicator's fade-out after not arming.
}

class LiquidPullToRefresh extends StatefulWidget {
  const LiquidPullToRefresh({
    super.key,
    this.animSpeedFactor = 1.0,
    required this.child,
    required this.onRefresh,
    this.color,
    this.backgroundColor,
    this.backgroundImage,
    this.height,
    this.springAnimationDurationInMilliseconds = 1000,
    this.borderWidth = 2.0,
    this.showChildOpacityTransition = true,
  }) : assert(animSpeedFactor >= 1.0);

  /// O widget abaixo deste widget na árvore.
  ///
  /// O indicador de progresso será empilhado sobre esse child. O indicador
  /// aparecerá quando o descendente Scrollable do child for over-scrolled.
  ///
  /// Normalmente um [ListView] ou [CustomScrollView].
  final Widget child;

  /// A distância da borda superior ou inferior do child até onde a caixa
  /// vai se acomodar após o efeito de mola.
  ///
  /// o padrão é 100.0
  final double? height;

  /// Duração em milissegundos do efeito elástico que ocorre quando
  /// deixamos de arrastar após um arrasto completo.
  ///
  /// o padrão é 1000
  final int springAnimationDurationInMilliseconds;

  /// Para regular a "velocidade da animação" no final.
  /// Para acelerá-la, dê um valor > 1.0 e vice-versa.
  ///
  /// o padrão é 1.0
  final double animSpeedFactor;

  /// Largura da borda do círculo de progresso no indicador de progresso.
  ///
  /// o padrão é 2.0
  final double borderWidth;

  /// Se deve mostrar ou não a transição de opacidade do child.
  ///
  /// o padrão é true
  final bool showChildOpacityTransition;

  /// Uma função chamada quando o usuário arrasta o indicador de progresso
  /// o suficiente para demonstrar que quer atualizar o app. O [Future] retornado
  /// deve completar quando a operação de refresh terminar.
  final RefreshCallback onRefresh;

  /// A cor de primeiro plano do indicador de progresso. O valor padrão é
  /// [Theme.of(context).colorScheme.secondary] do tema atual.
  final Color? color;

  /// A cor de fundo do indicador de progresso. O valor padrão é
  /// [ThemeData.canvasColor] do tema atual.
  final Color? backgroundColor;

  /// A imagem de fundo do indicador de progresso.
  /// [null] por padrão.
  final ImageProvider? backgroundImage;

  @override
  LiquidPullToRefreshState createState() => LiquidPullToRefreshState();
}

class LiquidPullToRefreshState extends State<LiquidPullToRefresh> with TickerProviderStateMixin<LiquidPullToRefresh> {
  late AnimationController _springController;
  late Animation<double> _springAnimation;

  late AnimationController _progressingController;
  late Animation<double> _progressingRotateAnimation;
  late Animation<double> _progressingPercentAnimation;
  late Animation<double> _progressingStartAngleAnimation;

  late AnimationController _ringDisappearController;
  late Animation<double> _ringRadiusAnimation;
  late Animation<double> _ringOpacityAnimation;

  late AnimationController _showPeakController;
  late Animation<double> _peakHeightUpAnimation;
  late Animation<double> _peakHeightDownAnimation;

  late AnimationController _indicatorMoveWithPeakController;
  late Animation<double> _indicatorTranslateWithPeakAnimation;
  late Animation<double> _indicatorRadiusWithPeakAnimation;

  late AnimationController _indicatorTranslateInOutController;
  late Animation<double> _indicatorTranslateAnimation;

  late AnimationController _radiusController;
  late Animation<double> _radiusAnimation;

  late Animation<double> _childOpacityAnimation;

  late AnimationController _positionController;
  late Animation<double> _value;
  late Animation<Color?> _valueColor;

  _LiquidPullToRefreshMode? _mode;
  Future<void>? _pendingRefreshFuture;
  bool? _isIndicatorAtTop;
  double? _dragOffset;

  static final Animatable<double> _threeQuarterTween = Tween<double>(begin: 0.0, end: 0.75);
  static final Animatable<double> _oneToZeroTween = Tween<double>(begin: 1.0, end: 0.0);

  @override
  void initState() {
    super.initState();
    _springController = AnimationController(vsync: this);
    _springAnimation = _springController.drive(Tween<double>(begin: 1.0, end: -1.0));

    _progressingController = AnimationController(vsync: this, duration: const Duration(milliseconds: 1000));
    _progressingRotateAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _progressingController, curve: const Interval(0.0, 1.0)));
    _progressingPercentAnimation = Tween<double>(begin: 0.25, end: 5 / 6).animate(
      CurvedAnimation(
        parent: _progressingController,
        curve: Interval(0.0, 1.0, curve: ProgressRingCurve()),
      ),
    );
    _progressingStartAngleAnimation = Tween<double>(
      begin: -2 / 3,
      end: 1 / 2,
    ).animate(CurvedAnimation(parent: _progressingController, curve: const Interval(0.5, 1.0)));

    _ringDisappearController = AnimationController(vsync: this);
    _ringRadiusAnimation = Tween<double>(begin: 1.0, end: 1.25).animate(
      CurvedAnimation(
        parent: _ringDisappearController,
        curve: const Interval(0.0, 0.2, curve: Curves.easeOut),
      ),
    );
    _ringOpacityAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _ringDisappearController,
        curve: const Interval(0.0, 0.2, curve: Curves.easeIn),
      ),
    );

    _showPeakController = AnimationController(vsync: this);
    _peakHeightUpAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _showPeakController,
        curve: const Interval(0.1, 0.2, curve: Curves.easeOut),
      ),
    );
    _peakHeightDownAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _showPeakController,
        curve: const Interval(0.2, 0.3, curve: Curves.easeIn),
      ),
    );

    _indicatorMoveWithPeakController = AnimationController(vsync: this);
    _indicatorTranslateWithPeakAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _indicatorMoveWithPeakController,
        curve: const Interval(0.1, 0.2, curve: Curves.easeOut),
      ),
    );
    _indicatorRadiusWithPeakAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _indicatorMoveWithPeakController,
        curve: const Interval(0.1, 0.2, curve: Curves.easeOut),
      ),
    );

    _indicatorTranslateInOutController = AnimationController(vsync: this);
    _indicatorTranslateAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _indicatorTranslateInOutController,
        curve: const Interval(0.2, 0.6, curve: Curves.easeOut),
      ),
    );

    _radiusController = AnimationController(vsync: this);
    _radiusAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _radiusController, curve: Curves.easeIn));

    _positionController = AnimationController(vsync: this);
    _value = _positionController.drive(_threeQuarterTween);

    _childOpacityAnimation = _positionController.drive(_oneToZeroTween);
  }

  @override
  void didChangeDependencies() {
    final ThemeData theme = Theme.of(context);
    _valueColor = _positionController.drive(
      ColorTween(
        begin: (widget.color ?? theme.colorScheme.secondary).withValues(alpha: 0.0),
        end: (widget.color ?? theme.colorScheme.secondary).withValues(alpha: 1.0),
      ).chain(CurveTween(curve: const Interval(0.0, 1.0 / _kDragSizeFactorLimit))),
    );
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _springController.dispose();
    _progressingController.dispose();
    _positionController.dispose();
    _ringDisappearController.dispose();
    _showPeakController.dispose();
    _indicatorMoveWithPeakController.dispose();
    _indicatorTranslateInOutController.dispose();
    _radiusController.dispose();
    super.dispose();
  }

  bool _handleScrollNotification(ScrollNotification notification) {
    if (notification is ScrollStartNotification &&
        notification.metrics.extentBefore == 0.0 &&
        _mode == null &&
        _start(notification.metrics.axisDirection)) {
      setState(() {
        _mode = _LiquidPullToRefreshMode.drag;
      });
      return false;
    }
    bool? indicatorAtTopNow;
    switch (notification.metrics.axisDirection) {
      case AxisDirection.down:
        indicatorAtTopNow = true;
        break;
      case AxisDirection.up:
        indicatorAtTopNow = false;
        break;
      case AxisDirection.left:
      case AxisDirection.right:
        indicatorAtTopNow = null;
        break;
    }
    if (indicatorAtTopNow != _isIndicatorAtTop) {
      if (_mode == _LiquidPullToRefreshMode.drag || _mode == _LiquidPullToRefreshMode.armed) {
        _dismiss(_LiquidPullToRefreshMode.canceled);
      }
    } else if (notification is ScrollUpdateNotification) {
      if (_mode == _LiquidPullToRefreshMode.drag || _mode == _LiquidPullToRefreshMode.armed) {
        if (notification.metrics.extentBefore > 0.0) {
          _dismiss(_LiquidPullToRefreshMode.canceled);
        } else {
          if (_dragOffset != null) {
            _dragOffset = _dragOffset! - notification.scrollDelta!;
          }
          _checkDragOffset(notification.metrics.viewportDimension);
        }
      }
      if (_mode == _LiquidPullToRefreshMode.armed && notification.dragDetails == null) {
        // No iOS, inicia o refresh quando o Scrollable quica de volta do
        // OverScroll (ScrollNotification indicando que não possui dragDetails
        // porque a atividade de rolagem não é acionada diretamente por um arrasto).
        _show();
      }
    } else if (notification is OverscrollNotification) {
      if (_mode == _LiquidPullToRefreshMode.drag || _mode == _LiquidPullToRefreshMode.armed) {
        if (_dragOffset != null) {
          _dragOffset = _dragOffset! - notification.overscroll / 2.0;
        }
        _checkDragOffset(notification.metrics.viewportDimension);
      }
    } else if (notification is ScrollEndNotification) {
      switch (_mode) {
        case _LiquidPullToRefreshMode.armed:
          _show();
          break;
        case _LiquidPullToRefreshMode.drag:
          _dismiss(_LiquidPullToRefreshMode.canceled);
          break;
        default:
          // do nothing
          break;
      }
    }
    return false;
  }

  bool _handleGlowNotification(OverscrollIndicatorNotification notification) {
    if (notification.depth != 0 || !notification.leading) return false;
    if (_mode == _LiquidPullToRefreshMode.drag) {
      notification.disallowIndicator();
      return true;
    }
    return false;
  }

  // Para de mostrar o indicador de progresso.
  Future<void> _dismiss(_LiquidPullToRefreshMode newMode) async {
    await Future<void>.value();
    // Isso só pode ser chamado a partir de _show() durante o refresh e
    // _handleScrollNotification em resposta a um ScrollEndNotification ou
    // mudança de direção.
    assert(newMode == _LiquidPullToRefreshMode.canceled || newMode == _LiquidPullToRefreshMode.done);
    setState(() {
      _mode = newMode;
    });
    switch (_mode) {
      case _LiquidPullToRefreshMode.done:
        // interrompe a animação de progresso
        _progressingController.stop();

        // animação de desaparecimento do anel de progresso
        _ringDisappearController.animateTo(
          1.0,
          duration: Duration(
            milliseconds: (widget.springAnimationDurationInMilliseconds / widget.animSpeedFactor).round(),
          ),
          curve: Curves.linear,
        );

        // indicador sai em translação
        _indicatorMoveWithPeakController.animateTo(
          0.0,
          duration: Duration(
            milliseconds: (widget.springAnimationDurationInMilliseconds / widget.animSpeedFactor).round(),
          ),
          curve: Curves.linear,
        );
        _indicatorTranslateInOutController.animateTo(
          0.0,
          duration: Duration(
            milliseconds: (widget.springAnimationDurationInMilliseconds / widget.animSpeedFactor).round(),
          ),
          curve: Curves.linear,
        );

        // o valor inicial do controller é 1.0
        await _showPeakController.animateTo(
          0.3,
          duration: Duration(
            milliseconds: (widget.springAnimationDurationInMilliseconds / widget.animSpeedFactor).round(),
          ),
          curve: Curves.linear,
        );

        _radiusController.animateTo(
          0.0,
          duration: Duration(
            milliseconds: (widget.springAnimationDurationInMilliseconds / (widget.animSpeedFactor * 5)).round(),
          ),
          curve: Curves.linear,
        );

        _showPeakController.value = 0.175;
        await _showPeakController.animateTo(
          0.1,
          duration: Duration(
            milliseconds: (widget.springAnimationDurationInMilliseconds / (widget.animSpeedFactor * 5)).round(),
          ),
          curve: Curves.easeOut,
        );
        _showPeakController.value = 0.0;

        await _positionController.animateTo(
          0.0,
          duration: Duration(
            milliseconds: (widget.springAnimationDurationInMilliseconds / widget.animSpeedFactor).round(),
          ),
        );
        break;

      case _LiquidPullToRefreshMode.canceled:
        await _positionController.animateTo(0.0, duration: _kIndicatorScaleDuration);
        break;
      default:
        assert(false);
    }
    if (mounted && _mode == newMode) {
      _dragOffset = null;
      _isIndicatorAtTop = null;
      setState(() {
        _mode = null;
      });
    }
  }

  bool _start(AxisDirection direction) {
    assert(_mode == null);
    assert(_isIndicatorAtTop == null);
    assert(_dragOffset == null);
    switch (direction) {
      case AxisDirection.down:
        _isIndicatorAtTop = true;
        break;
      case AxisDirection.up:
        _isIndicatorAtTop = false;
        break;
      case AxisDirection.left:
      case AxisDirection.right:
        _isIndicatorAtTop = null;
        // não suportamos scroll views horizontais.
        return false;
    }
    _dragOffset = 0.0;
    _positionController.value = 0.0;
    _springController.value = 0.0;
    _progressingController.value = 0.0;
    _ringDisappearController.value = 1.0;
    _showPeakController.value = 0.0;
    _indicatorMoveWithPeakController.value = 0.0;
    _indicatorTranslateInOutController.value = 0.0;
    _radiusController.value = 1.0;
    return true;
  }

  void _checkDragOffset(double containerExtent) {
    assert(_mode == _LiquidPullToRefreshMode.drag || _mode == _LiquidPullToRefreshMode.armed);
    double newValue = _dragOffset! / (containerExtent * _kDragContainerExtentPercentage);
    if (_mode == _LiquidPullToRefreshMode.armed) {
      newValue = math.max(newValue, 1.0 / _kDragSizeFactorLimit);
    }
    _positionController.value = newValue.clamp(0.0, 1.0); // this triggers various rebuilds
    if (_mode == _LiquidPullToRefreshMode.drag && _valueColor.value!.a == 1.0) {
      _mode = _LiquidPullToRefreshMode.armed;
    }
  }

  void _show() {
    assert(_mode != _LiquidPullToRefreshMode.refresh);
    assert(_mode != _LiquidPullToRefreshMode.snap);
    final Completer<void> completer = Completer<void>();
    _pendingRefreshFuture = completer.future;
    _mode = _LiquidPullToRefreshMode.snap;

    _positionController.animateTo(
      1.0 / _kDragSizeFactorLimit,
      duration: Duration(milliseconds: widget.springAnimationDurationInMilliseconds),
      curve: Curves.linear,
    );

    _showPeakController.animateTo(
      1.0,
      duration: Duration(milliseconds: widget.springAnimationDurationInMilliseconds),
      curve: Curves.linear,
    );

    // indicador entra em translação com pico
    _indicatorMoveWithPeakController.animateTo(
      1.0,
      duration: Duration(milliseconds: widget.springAnimationDurationInMilliseconds),
      curve: Curves.linear,
    );

    // indicador se move para o centro
    _indicatorTranslateInOutController.animateTo(
      1.0,
      duration: Duration(milliseconds: widget.springAnimationDurationInMilliseconds),
      curve: Curves.linear,
    );

    // o anel de progresso entra em fade
    _ringDisappearController.animateTo(
      0.0,
      duration: Duration(milliseconds: widget.springAnimationDurationInMilliseconds),
    );

    _springController
        .animateTo(
          0.5,
          duration: Duration(milliseconds: widget.springAnimationDurationInMilliseconds),
          curve: Curves.elasticOut,
        )
        .then<void>((void value) {
          if (mounted && _mode == _LiquidPullToRefreshMode.snap) {
            setState(() {
              // Mostra o indicador de progresso indeterminado.
              _mode = _LiquidPullToRefreshMode.refresh;
            });

            // executa a animação de progresso
            _progressingController.repeat();

            final Future<void> refreshResult = widget.onRefresh();

            refreshResult.whenComplete(() {
              if (mounted && _mode == _LiquidPullToRefreshMode.refresh) {
                completer.complete();

                _dismiss(_LiquidPullToRefreshMode.done);
              }
            });
          }
        });
  }

  /// Exibe o indicador de progresso e executa o callback de refresh como se tivesse
  /// sido iniciado interativamente. Se este método for chamado enquanto o callback
  /// de refresh estiver em execução, ele simplesmente não faz nada.
  ///
  /// Criar o [LiquidPullToRefresh] com um [GlobalKey<LiquidPullToRefreshState>]
  /// torna possível se referir ao [LiquidPullToRefreshState].
  ///
  /// O futuro retornado por este método completa quando o future do callback
  /// [LiquidPullToRefresh.onRefresh] for concluído.
  ///
  /// Se você aguardar o futuro retornado por esta função a partir de um [State],
  /// deve verificar se o estado ainda está [mounted] antes de chamar [setState].
  ///
  /// Quando iniciado desta forma, o indicador de progresso é independente de qualquer
  /// scroll view real. Por padrão, ele mostra o indicador no topo. Para
  /// mostrá-lo na parte inferior, defina `atTop` como false.
  Future<void>? show({bool atTop = true}) {
    if (_mode != _LiquidPullToRefreshMode.refresh && _mode != _LiquidPullToRefreshMode.snap) {
      if (_mode == null) _start(atTop ? AxisDirection.down : AxisDirection.up);
      _show();
    }
    return _pendingRefreshFuture;
  }

  final GlobalKey _key = GlobalKey();

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasMaterialLocalizations(context));

    // define a cor padrão e a cor de fundo padrão
    Color defaultColor = Theme.of(context).colorScheme.secondary;
    Color defaultBackgroundColor = Theme.of(context).canvasColor;

    // define a altura padrão
    double defaultHeight = 100.0;

    // verifica se devem ser usados os valores padrão
    Color color = (widget.color != null) ? widget.color! : defaultColor;
    Color backgroundColor = (widget.backgroundColor != null) ? widget.backgroundColor! : defaultBackgroundColor;
    double height = (widget.height != null) ? widget.height! : defaultHeight;

    final Widget child = NotificationListener<ScrollNotification>(
      key: _key,
      onNotification: _handleScrollNotification,
      child: NotificationListener<OverscrollIndicatorNotification>(
        onNotification: _handleGlowNotification,
        child: widget.child,
      ),
    );

    if (_mode == null) {
      assert(_dragOffset == null);
      assert(_isIndicatorAtTop == null);
      return child;
    }
    assert(_dragOffset != null);
    assert(_isIndicatorAtTop != null);

    return Stack(
      children: <Widget>[
        AnimatedBuilder(
          animation: _positionController,
          child: child,
          builder: (BuildContext buildContext, Widget? child) {
            if (widget.showChildOpacityTransition) {
              return Opacity(
                // -0.01 é usado para a curva elasticOut
                opacity: (widget.showChildOpacityTransition)
                    ? (_childOpacityAnimation.value - (1 / 3) - 0.01).clamp(0.0, 1.0)
                    : 1.0,
                child: child,
              );
            }
            return Transform.translate(offset: Offset(0.0, _positionController.value * height * 1.5), child: child);
          },
        ),
        AnimatedBuilder(
          animation: Listenable.merge([_positionController, _springController, _showPeakController]),
          builder: (BuildContext buildContext, Widget? child) {
            return ClipPath(
              clipper: CurveHillClipper(
                hasImage: widget.backgroundImage != null,
                centreHeight: height,
                curveHeight: height / 2 * _springAnimation.value, // 50.0
                peakHeight:
                    height *
                    3 /
                    10 *
                    ((_peakHeightUpAnimation.value != 1.0) //30.0
                        ? _peakHeightUpAnimation.value
                        : _peakHeightDownAnimation.value),
                peakWidth: (_peakHeightUpAnimation.value != 0.0 && _peakHeightDownAnimation.value != 0.0)
                    ? height *
                          35 /
                          100 //35.0
                    : 0.0,
              ),
              child: Container(
                height: _value.value * height * 2, // 100.0
                color: color,
              ),
            );
          },
        ),
        SizedBox(
          height: height, //100.0
          child: AnimatedBuilder(
            animation: Listenable.merge([
              _progressingController,
              _ringDisappearController,
              _indicatorMoveWithPeakController,
              _indicatorTranslateInOutController,
              _radiusController,
            ]),
            builder: (BuildContext buildContext, Widget? child) {
              return Align(
                alignment: Alignment(
                  0.0,
                  (1.0 -
                      (0.36 * _indicatorTranslateWithPeakAnimation.value) -
                      (0.64 * _indicatorTranslateAnimation.value)),
                ),
                child: Transform(
                  transform: Matrix4.identity()..rotateZ(_progressingRotateAnimation.value * 5 * pi / 6),
                  alignment: FractionalOffset.center,
                  child: CircularProgress(
                    backgroundColor: backgroundColor,
                    backgroundImage: widget.backgroundImage,
                    progressCircleOpacity: _ringOpacityAnimation.value,
                    innerCircleRadius:
                        height *
                        15 /
                        100 * // 15.0
                        ((_mode != _LiquidPullToRefreshMode.done)
                            ? _indicatorRadiusWithPeakAnimation.value
                            : _radiusAnimation.value),
                    progressCircleBorderWidth: widget.borderWidth,
                    //2.0
                    progressCircleRadius: (_ringOpacityAnimation.value != 0.0)
                        ? (height * 2 / 10) *
                              _ringRadiusAnimation
                                  .value //20.0
                        : 0.0,
                    startAngle: _progressingStartAngleAnimation.value * pi,
                    progressPercent: _progressingPercentAnimation.value,
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class ProgressRingCurve extends Curve {
  @override
  double transform(double t) {
    if (t <= 0.5) {
      return 2 * t;
    } else {
      return 2 * (1 - t);
    }
  }
}
