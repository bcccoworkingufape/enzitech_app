import 'package:flutter/material.dart';

class EZTCheckBoxTile extends StatelessWidget {
  const EZTCheckBoxTile({
    Key? key,
    required this.selected,
    required this.onTap,
    required this.title,
  }) : super(key: key);

  final String title;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
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
