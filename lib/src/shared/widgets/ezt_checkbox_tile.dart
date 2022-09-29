// 🐦 Flutter imports:
import 'package:flutter/material.dart';

class EZTCheckBoxTile extends StatelessWidget {
  const EZTCheckBoxTile({
    Key? key,
    required this.selected,
    required this.onTap,
    this.onTapTrailing,
    required this.title,
    this.color,
  }) : super(key: key);

  final String title;
  final bool selected;
  final VoidCallback onTap;
  final VoidCallback? onTapTrailing;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      trailing: color != null
          ? GestureDetector(
              onTap: onTapTrailing,
              child: Icon(
                Icons.circle,
                color: color,
                size: 16,
              ),
            )
          : null,
      title: Text(title),
      onTap: onTap,
      leading: Checkbox(
        value: selected,
        onChanged: (val) {
          onTap();
        },
      ),
    );
  }
}
