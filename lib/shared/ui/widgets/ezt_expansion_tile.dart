// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// ignore_for_file: unnecessary_null_comparison

// 🐦 Flutter imports:
import 'package:material_ui/material_ui.dart';

const Duration _kExpand = Duration(milliseconds: 200);

/// Um [ListTile] de uma linha com um ícone de seta de expansão que expande ou recolhe
/// o tile para revelar ou ocultar os [children].
///
/// Este widget é tipicamente usado com [ListView] para criar uma entrada
/// "expandir / recolher" da lista. Quando usado com widgets de rolagem como
/// [ListView], um [PageStorageKey] único deve ser especificado para permitir que
/// [EZTExpansionTile] salve e restaure seu estado expandido quando é rolado
/// para dentro e para fora da visão.
///
/// Esta classe sobrescreve as propriedades de tema [ListTileThemeData.iconColor] e [ListTileThemeData.textColor]
/// do seu [ListTile]. Essas cores animam entre valores quando
/// o tile é expandido e recolhido: entre [iconColor], [collapsedIconColor] e
/// entre [textColor] e [collapsedTextColor].
///
/// O ícone de seta de expansão é mostrado à direita por padrão em idiomas da esquerda para a direita
/// (ou seja, na borda trailing). Isso pode ser alterado usando [controlAffinity]. Isso mapeia
/// para as propriedades [leading] e [trailing] de [EZTExpansionTile].
///
/// {@tool dartpad}
/// Este exemplo demonstra diferentes configurações de ExpansionTile.
///
/// ** Veja o código em examples/api/lib/material/expansion_tile/expansion_tile.0.dart **
/// {@end-tool}
///
/// Veja também:
///
///  * [ListTile], útil para criar [children] de expansion tile quando o
///    expansion tile representa uma sublista.
///  * A seção "Expandir e recolher" de
///    <https://material.io/components/lists#types>
class EZTExpansionTile extends StatefulWidget {
  /// Cria um [ListTile] de uma linha com um ícone de seta de expansão que expande ou recolhe
  /// o tile para revelar ou ocultar os [children]. A propriedade [initiallyExpanded] deve
  /// ser não nula.
  const EZTExpansionTile({
    super.key,
    this.leading,
    required this.title,
    this.subtitle,
    this.onExpansionChanged,
    this.children = const <Widget>[],
    this.trailing,
    this.disableTrailing = false,
    this.initiallyExpanded = false,
    this.maintainState = false,
    this.tilePadding,
    this.expandedCrossAxisAlignment,
    this.expandedAlignment,
    this.childrenPadding,
    this.backgroundColor,
    this.collapsedBackgroundColor,
    this.textColor,
    this.collapsedTextColor,
    this.iconColor,
    this.collapsedIconColor,
    this.controlAffinity,
  }) : assert(initiallyExpanded != null),
       assert(maintainState != null),
       assert(
         expandedCrossAxisAlignment != CrossAxisAlignment.baseline,
         'CrossAxisAlignment.baseline is not supported since the expanded children '
         'are aligned in a column, not a row. Try to use another constant.',
       );

  /// Um widget a ser exibido antes do título.
  ///
  /// Normalmente, um widget [CircleAvatar].
  ///
  /// Observe que, dependendo do valor de [controlAffinity], o widget [leading]
  /// pode substituir o ícone de seta de expansão rotativo.
  final Widget? leading;

  /// O conteúdo principal do item da lista.
  ///
  /// Normalmente, um widget [Text].
  final Widget title;

  /// Conteúdo adicional exibido abaixo do título.
  ///
  /// Normalmente, um widget [Text].
  final Widget? subtitle;

  /// Chamado quando o tile é expandido ou recolhido.
  ///
  /// Quando o tile começa a expandir, essa função é chamada com o valor
  /// true. Quando o tile começa a recolher, essa função é chamada com o valor
  /// false.
  final ValueChanged<bool>? onExpansionChanged;

  /// Os widgets exibidos quando o tile é expandido.
  ///
  /// Normalmente, widgets [ListTile].
  final List<Widget> children;

  /// A cor exibida atrás da sublista quando ela está expandida.
  ///
  /// Se esta propriedade for null, então [ExpansionTileThemeData.backgroundColor] é usado. Se isso
  /// também for null, então Colors.transparent é usado.
  ///
  /// Veja também:
  ///
  /// * [ExpansionTileTheme.of], que retorna o [ExpansionTileTheme] mais próximo
  ///   [ExpansionTileThemeData].
  final Color? backgroundColor;

  /// Quando não nulo, define a cor de fundo do tile quando a sublista está recolhida.
  ///
  /// Se esta propriedade for null, então [ExpansionTileThemeData.collapsedBackgroundColor] é usado.
  /// Se isso também for null, então Colors.transparent é usado.
  ///
  /// Veja também:
  ///
  /// * [ExpansionTileTheme.of], que retorna o [ExpansionTileTheme] mais próximo
  ///   [ExpansionTileThemeData].
  final Color? collapsedBackgroundColor;

  /// Um widget a ser exibido após o título.
  ///
  /// Observe que, dependendo do valor de [controlAffinity], o widget [trailing]
  /// pode substituir o ícone de seta de expansão rotativo.
  final Widget? trailing;

  /// Especifica se o ícone de trailing é exibido no tile.
  ///
  /// Quando true, o ícone de trailing não será exibido.
  /// Quando false (padrão), o ícone de trailing será exibido.
  final bool disableTrailing;

  /// Especifica se o tile de lista está inicialmente expandido (true) ou recolhido (false, o padrão).
  final bool initiallyExpanded;

  /// Especifica se o estado dos children é mantido quando o tile expande e recolhe.
  ///
  /// Quando true, os children são mantidos na árvore enquanto o tile está recolhido.
  /// Quando false (padrão), os children são removidos da árvore quando o tile é
  /// recolhido e recriados na expansão.
  final bool maintainState;

  /// Especifica o padding para o [ListTile].
  ///
  /// Análogo a [ListTile.contentPadding], esta propriedade define os insets para
  /// os widgets [leading], [title], [subtitle] e [trailing]. Ela não aplica inset
  /// aos widgets expandidos [children].
  ///
  /// Se esta propriedade for null, então [ExpansionTileThemeData.tilePadding] é usado. Se isso
  /// também for null, então o padding do tile é `EdgeInsets.symmetric(horizontal: 16.0)`.
  ///
  /// Veja também:
  ///
  /// * [ExpansionTileTheme.of], que retorna o [ExpansionTileTheme]'s mais próximo
  ///   [ExpansionTileThemeData].
  final EdgeInsetsGeometry? tilePadding;

  /// Especifica o alinhamento de [children], que são organizados em uma coluna quando
  /// o tile é expandido.
  ///
  /// Os internals do tile expandido usam um widget [Column] para
  /// [children] e um widget [Align] para alinhar a coluna. O parâmetro `expandedAlignment`
  /// é passado diretamente para o [Align].
  ///
  /// Modificar esta propriedade controla o alinhamento da coluna dentro do
  /// tile expandido, não o alinhamento dos widgets [children] dentro da coluna.
  /// Para alinhar cada child dentro de [children], veja [expandedCrossAxisAlignment].
  ///
  /// A largura da coluna é a largura do widget child mais largo em [children].
  ///
  /// Se esta propriedade for null, então [ExpansionTileThemeData.expandedAlignment] é usado. Se isso
  /// também for null, então o valor de `expandedAlignment` é [Alignment.center].
  ///
  /// Veja também:
  ///
  /// * [ExpansionTileTheme.of], que retorna o [ExpansionTileTheme]'s mais próximo
  ///   [ExpansionTileThemeData].
  final Alignment? expandedAlignment;

  /// Especifica o alinhamento de cada child dentro de [children] quando o tile é expandido.
  ///
  /// Os internals do tile expandido usam um widget [Column] para
  /// [children], e o parâmetro `crossAxisAlignment` é passado diretamente para o [Column].
  ///
  /// Modificar esta propriedade controla o alinhamento cruzado de cada child
  /// dentro de seu [Column]. Note que a largura do [Column] que abriga
  /// [children] será a mesma do widget child mais largo em [children]. Não é
  /// necessariamente a largura de [Column] igual à largura do tile expandido.
  ///
  /// Para alinhar o [Column] ao longo do tile expandido, use a propriedade [expandedAlignment]
  /// em vez disso.
  ///
  /// Quando o valor é null, o valor de `expandedCrossAxisAlignment` é [CrossAxisAlignment.center].
  final CrossAxisAlignment? expandedCrossAxisAlignment;

  /// Especifica o padding para [children].
  ///
  /// Se esta propriedade for null, então [ExpansionTileThemeData.childrenPadding] é usado. Se isso
  /// também for null, então o valor de `childrenPadding` é [EdgeInsets.zero].
  ///
  /// Veja também:
  ///
  /// * [ExpansionTileTheme.of], que retorna o [ExpansionTileTheme]'s mais próximo
  ///   [ExpansionTileThemeData].
  final EdgeInsetsGeometry? childrenPadding;

  /// A cor do ícone de seta de expansão do tile quando a sublista está expandida.
  ///
  /// Usado para sobrescrever [ListTileThemeData.iconColor].
  ///
  /// Se esta propriedade for null, então [ExpansionTileThemeData.iconColor] é usado. Se isso
  /// também for null, então o valor de [ListTileThemeData.iconColor] é usado.
  ///
  /// Veja também:
  ///
  /// * [ExpansionTileTheme.of], que retorna o [ExpansionTileTheme]'s mais próximo
  ///   [ExpansionTileThemeData].
  final Color? iconColor;

  /// A cor do ícone de seta de expansão do tile quando a sublista está recolhida.
  ///
  /// Usado para sobrescrever [ListTileThemeData.iconColor].
  final Color? collapsedIconColor;

  /// A cor dos títulos do tile quando a sublista está expandida.
  ///
  /// Usado para sobrescrever [ListTileThemeData.textColor].
  ///
  /// Se esta propriedade for null, então [ExpansionTileThemeData.textColor] é usado. Se isso
  /// também for null, então o valor de [ListTileThemeData.textColor] é usado.
  ///
  /// Veja também:
  ///
  /// * [ExpansionTileTheme.of], que retorna o [ExpansionTileTheme]'s mais próximo
  ///   [ExpansionTileThemeData].
  final Color? textColor;

  /// A cor dos títulos do tile quando a sublista está recolhida.
  ///
  /// Usado para sobrescrever [ListTileThemeData.textColor].
  ///
  /// Se esta propriedade for null, então [ExpansionTileThemeData.collapsedTextColor] é usado. Se isso
  /// também for null, então o valor de [ListTileThemeData.textColor] é usado.
  ///
  /// Veja também:
  ///
  /// * [ExpansionTileTheme.of], que retorna o [ExpansionTileTheme]'s mais próximo
  ///   [ExpansionTileThemeData].
  final Color? collapsedTextColor;

  /// Normalmente usado para forçar o ícone de seta de expansão para a borda leading ou trailing do tile.
  ///
  /// Por padrão, o valor de `controlAffinity` é [ListTileControlAffinity.platform],
  /// o que significa que o ícone de seta de expansão aparecerá na borda trailing do tile.
  final ListTileControlAffinity? controlAffinity;

  @override
  State<EZTExpansionTile> createState() => _EZTExpansionTileState();
}

class _EZTExpansionTileState extends State<EZTExpansionTile> with SingleTickerProviderStateMixin {
  static final Animatable<double> _easeOutTween = CurveTween(curve: Curves.easeOut);
  static final Animatable<double> _easeInTween = CurveTween(curve: Curves.easeIn);
  static final Animatable<double> _halfTween = Tween<double>(begin: 0.0, end: 0.5);

  final ColorTween _borderColorTween = ColorTween();
  final ColorTween _headerColorTween = ColorTween();
  final ColorTween _iconColorTween = ColorTween();
  final ColorTween _backgroundColorTween = ColorTween();

  late AnimationController _controller;
  late Animation<double> _iconTurns;
  late Animation<double> _heightFactor;
  late Animation<Color?> _borderColor;
  late Animation<Color?> _headerColor;
  late Animation<Color?> _iconColor;
  late Animation<Color?> _backgroundColor;

  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: _kExpand, vsync: this);
    _heightFactor = _controller.drive(_easeInTween);
    _iconTurns = _controller.drive(_halfTween.chain(_easeInTween));
    _borderColor = _controller.drive(_borderColorTween.chain(_easeOutTween));
    _headerColor = _controller.drive(_headerColorTween.chain(_easeInTween));
    _iconColor = _controller.drive(_iconColorTween.chain(_easeInTween));
    _backgroundColor = _controller.drive(_backgroundColorTween.chain(_easeOutTween));

    _isExpanded = PageStorage.of(context).readState(context) as bool? ?? widget.initiallyExpanded;
    if (_isExpanded) {
      _controller.value = 1.0;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTap() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _controller.forward();
      } else {
        _controller.reverse().then<void>((void value) {
          if (!mounted) {
            return;
          }
          setState(() {
            // Rebuild without widget.children.
          });
        });
      }
      PageStorage.of(context).writeState(context, _isExpanded);
    });
    widget.onExpansionChanged?.call(_isExpanded);
  }

  // Platform or null affinity defaults to trailing.
  ListTileControlAffinity _effectiveAffinity(ListTileControlAffinity? affinity) {
    switch (affinity ?? ListTileControlAffinity.trailing) {
      case ListTileControlAffinity.leading:
        return ListTileControlAffinity.leading;
      case ListTileControlAffinity.trailing:
      case ListTileControlAffinity.platform:
        return ListTileControlAffinity.trailing;
    }
  }

  Widget? _buildIcon(BuildContext context) {
    return RotationTransition(turns: _iconTurns, child: const Icon(Icons.expand_more));
  }

  Widget? _buildLeadingIcon(BuildContext context) {
    if (_effectiveAffinity(widget.controlAffinity) != ListTileControlAffinity.leading) {
      return null;
    }
    return _buildIcon(context);
  }

  Widget? _buildTrailingIcon(BuildContext context) {
    if (widget.disableTrailing == true) {
      return null;
    }

    if (_effectiveAffinity(widget.controlAffinity) != ListTileControlAffinity.trailing) {
      return null;
    }
    return _buildIcon(context);
  }

  Widget _buildChildren(BuildContext context, Widget? child) {
    final ExpansionTileThemeData expansionTileTheme = ExpansionTileTheme.of(context);
    final Color borderSideColor = _borderColor.value ?? Colors.transparent;

    return Container(
      decoration: BoxDecoration(
        color: _backgroundColor.value ?? expansionTileTheme.backgroundColor ?? Colors.transparent,
        border: Border(
          top: BorderSide(color: borderSideColor),
          bottom: BorderSide(color: borderSideColor),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTileTheme.merge(
            iconColor: _iconColor.value ?? expansionTileTheme.iconColor,
            textColor: _headerColor.value,
            child: ListTile(
              onTap: _handleTap,
              contentPadding: widget.tilePadding ?? expansionTileTheme.tilePadding,
              leading: widget.leading ?? _buildLeadingIcon(context),
              title: widget.title,
              subtitle: widget.subtitle,
              trailing: (widget.trailing != null && !widget.disableTrailing)
                  ? widget.trailing
                  : _buildTrailingIcon(context),
            ),
          ),
          ClipRect(
            child: Align(
              alignment: widget.expandedAlignment ?? expansionTileTheme.expandedAlignment ?? Alignment.center,
              heightFactor: _heightFactor.value,
              child: child,
            ),
          ),
        ],
      ),
    );
  }

  @override
  void didChangeDependencies() {
    final ThemeData theme = Theme.of(context);
    final ExpansionTileThemeData expansionTileTheme = ExpansionTileTheme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    _borderColorTween.end = theme.dividerColor;
    _headerColorTween
      ..begin = widget.collapsedTextColor ?? expansionTileTheme.collapsedTextColor ?? theme.textTheme.titleMedium!.color
      ..end = widget.textColor ?? expansionTileTheme.textColor ?? colorScheme.primary;
    _iconColorTween
      ..begin = widget.collapsedIconColor ?? expansionTileTheme.collapsedIconColor ?? theme.unselectedWidgetColor
      ..end = widget.iconColor ?? expansionTileTheme.iconColor ?? colorScheme.primary;
    _backgroundColorTween
      ..begin = widget.collapsedBackgroundColor ?? expansionTileTheme.collapsedBackgroundColor
      ..end = widget.backgroundColor ?? expansionTileTheme.backgroundColor;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final ExpansionTileThemeData expansionTileTheme = ExpansionTileTheme.of(context);
    final bool closed = !_isExpanded && _controller.isDismissed;
    final bool shouldRemoveChildren = closed && !widget.maintainState;

    final Widget result = Offstage(
      offstage: closed,
      child: TickerMode(
        enabled: !closed,
        child: Padding(
          padding: widget.childrenPadding ?? expansionTileTheme.childrenPadding ?? EdgeInsets.zero,
          child: Column(
            crossAxisAlignment: widget.expandedCrossAxisAlignment ?? CrossAxisAlignment.center,
            children: widget.children,
          ),
        ),
      ),
    );

    return AnimatedBuilder(
      animation: _controller.view,
      builder: _buildChildren,
      child: shouldRemoveChildren ? null : result,
    );
  }
}
