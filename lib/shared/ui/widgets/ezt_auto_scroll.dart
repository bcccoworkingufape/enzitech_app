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

  /// Widget to display in loop
  ///
  /// required
  final Widget child;

  /// Duration to wait before starting animation
  ///
  /// Default set to Duration(seconds: 1).
  ///
  final Duration delay;

  /// Duration of animation
  ///
  /// Default set to Duration(seconds: 30).
  final Duration duration;

  /// Sized between end of child and beginning of next child instance
  ///
  /// Default set to 25.
  final double gap;

  /// The axis along which the scroll view scrolls.
  ///
  /// required
  final Axis scrollDirection;

  ///
  /// true : Right to Left
  ///
  // |___________________________<--Scrollbar-Starting-Right-->|
  ///
  /// fasle : Left to Right (Default)
  ///
  // |<--Scrollbar-Starting-Left-->____________________________|
  final bool reverseScroll;

  /// The number of times duplicates child. So when the user scrolls then, he can't find the end.
  ///
  /// Default set to 25.
  ///
  final int duplicateChild;

  ///User scroll input
  ///
  ///Default set to true
  final bool enableScrollInput;

  /// Duration to wait before starting animation, after user scroll Input.
  ///
  /// Default set to Duration(seconds: 1).
  ///
  final Duration delayAfterScrollInput;
  @override
  State<EZTAutoScroll> createState() => _EZTAutoScrollState();
}

class _EZTAutoScrollState extends State<EZTAutoScroll>
    with SingleTickerProviderStateMixin {
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

    animationController = AnimationController(
      duration: widget.duration,
      vsync: this,
    );

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

  animationHandler() async {
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
      physics: widget.enableScrollInput
          ? const BouncingScrollPhysics()
          : const NeverScrollableScrollPhysics(),
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
                                  right: shouldScroll && !widget.reverseScroll
                                      ? widget.gap
                                      : 0,
                                  left: shouldScroll && widget.reverseScroll
                                      ? widget.gap
                                      : 0),
                              child: widget.child,
                            )))
                : Column(
                    children: List.generate(
                    widget.duplicateChild,
                    (index) => Padding(
                      padding: EdgeInsets.only(
                          bottom: shouldScroll && !widget.reverseScroll
                              ? widget.gap
                              : 0,
                          top: shouldScroll && widget.reverseScroll
                              ? widget.gap
                              : 0),
                      child: widget.child,
                    ),
                  ));
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
