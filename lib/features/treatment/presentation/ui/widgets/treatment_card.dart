// 🐦 Flutter imports:
import 'package:flutter/material.dart';

import 'package:intl/intl.dart';

// 🌎 Project imports:
import '../../../../../shared/extensions/build_context_extensions.dart';
import '../../../../../shared/ui/ui.dart';

class TreatmentCard extends StatefulWidget {
  const TreatmentCard({super.key, required this.name, required this.createdAt, required this.description});

  final String name;
  final DateTime createdAt;
  final String description;

  @override
  State<TreatmentCard> createState() => _TreatmentCardState();
}

class _TreatmentCardState extends State<TreatmentCard> {
  bool expanded = false;

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context).toString();
    final formattedDate = DateFormat.yMd(locale).format(widget.createdAt);

    return GestureDetector(
      onTap: () => setState(() {
        expanded = !expanded;
      }),
      child: Card(
        elevation: 4,
        surfaceTintColor: context.getApplyedColorScheme.secondaryContainer,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              EZTMarqueeOnDemand(text: widget.name, textStyle: TextStyles(context).titleMoreBoldHeadingColored),
              const SizedBox(height: 2),
              Text(context.l10n.createdOn(formattedDate), style: TextStyles.bodyMinRegular),
              const SizedBox(height: 16),
              Text(
                widget.description,
                maxLines: expanded ? 100 : 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.justify,
                style: TextStyles(context).bodyRegular.copyWith(fontSize: 16.0),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
