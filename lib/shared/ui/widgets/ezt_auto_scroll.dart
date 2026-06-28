// 🐦 Flutter imports:
import 'package:flutter/material.dart';

class EZTAutoScroll extends StatefulWidget {
  const EZTAutoScroll({
    required this.child,
    required this.scrollDirection,
    super.key,
    this.delay = const Duration(seconds: 1),
    this.duration = const Duration(seconds: 2),
    this.gap = 25,
    this.reverseScroll = false,
    this.duplicateChild = 25,
    this.enableScrollInput = true,
    this.delayAfterScrollInput = const Duration(seconds: 1),
  });

  /// Widget a ser exibido em loop.
  ///
  /// obrigatório
  final Widget child;

  /// Duração de espera antes de iniciar a animação.
  ///
  /// Padrão definido para Duration(seconds: 1).
  ///
  final Duration delay;

  /// Duração da animação.
  ///
  /// Padrão definido para Duration(seconds: 30).
  final Duration duration;

  /// Espaço entre o fim de um child e o início do próximo.
  ///
  /// Padrão definido para 25.
  final double gap;

  /// O eixo ao longo do qual a view de rolagem é deslocada.
  ///
  /// obrigatório
  final Axis scrollDirection;

  ///
  /// true : da direita para a esquerda
  ///
  // |___________________________<--Scrollbar-Starting-Right-->|
  ///
  /// false : da esquerda para a direita (padrão)
  ///
  // |<--Scrollbar-Starting-Left-->____________________________|
  final bool reverseScroll;

  /// O número de vezes que o child é duplicado. Assim, quando o usuário rola, ele não encontra o fim.
  ///
  /// Padrão definido para 25.
  ///
  final int duplicateChild;

  /// Entrada de rolagem do usuário.
  ///
  /// Padrão definido como true.
  final bool enableScrollInput;

  /// Duração de espera antes de iniciar a animação, após a entrada de rolagem do usuário.
  ///
  /// Padrão definido para Duration(seconds: 1).
  ///
  final Duration delayAfterScrollInput;
  @override
  State<EZTAutoScroll> createState() => _EZTAutoScrollState();
}

class _EZTAutoScrollState extends State<EZTAutoScroll> with SingleTickerProviderStateMixin {
  late final AnimationController animationController;
  late Animation<Offset> offset;

  ValueNotifier<bool> shouldScroll = ValueNotifier<bool>(false);
  late final ScrollController scrollController;

  @override
  void initState() {
    scrollController = ScrollController();

    scrollController.addListener(() async {
      if (widget.enableScrollInput) {
        if (animationController.isAnimating) {
          animationController.stop();
        } else {
          await Future.delayed(widget.delayAfterScrollInput);
          animationHandler();
        }
      }
    });

    animationController = AnimationController(duration: widget.duration, vsync: this);

    offset = Tween<Offset>(
      begin: Offset.zero,
      end: widget.scrollDirection == Axis.horizontal
          ? widget.reverseScroll
                ? const Offset(.5, 0)
                : const Offset(-.5, 0)
          : widget.reverseScroll
          ? const Offset(0, .5)
          : const Offset(0, -.5),
    ).animate(animationController);

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await Future.delayed(widget.delay);
      animationHandler();
    });

    super.initState();
  }

  Future<void> animationHandler() async {
    if (!scrollController.hasClients) return;

    if (scrollController.position.maxScrollExtent > 0) {
      shouldScroll.value = true;

      if (shouldScroll.value && mounted) {
        animationController.forward().then((_) async {
          animationController.reset();

          if (shouldScroll.value && mounted) {
            animationHandler();
          }
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: widget.enableScrollInput ? const BouncingScrollPhysics() : const NeverScrollableScrollPhysics(),
      controller: scrollController,
      scrollDirection: widget.scrollDirection,
      reverse: widget.reverseScroll,
      child: SlideTransition(
        position: offset,
        child: ValueListenableBuilder<bool>(
          valueListenable: shouldScroll,
          builder: (BuildContext context, bool shouldScroll, _) {
            return widget.scrollDirection == Axis.horizontal
                ? Row(
                    children: List.generate(
                      widget.duplicateChild,
                      (index) => Padding(
                        padding: EdgeInsets.only(
                          right: shouldScroll && !widget.reverseScroll ? widget.gap : 0,
                          left: shouldScroll && widget.reverseScroll ? widget.gap : 0,
                        ),
                        child: widget.child,
                      ),
                    ),
                  )
                : Column(
                    children: List.generate(
                      widget.duplicateChild,
                      (index) => Padding(
                        padding: EdgeInsets.only(
                          bottom: shouldScroll && !widget.reverseScroll ? widget.gap : 0,
                          top: shouldScroll && widget.reverseScroll ? widget.gap : 0,
                        ),
                        child: widget.child,
                      ),
                    ),
                  );
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }
}
