import 'package:flutter/material.dart';

class AppTopBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;

  const AppTopBar({super.key, required this.title, this.actions});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: Navigator.canPop(context) ? IconButton(icon: const Icon(Icons.chevron_left),
      onPressed: () => Navigator.pop(context)) : null,
      title: Text(
        title,
        style: const TextStyle(
          fontFamily: 'Montserrat',
          fontWeight: FontWeight.w600,
        ),
      ),
      foregroundColor: Colors.black,
      backgroundColor: const Color(0xFFF8F9FB),
      actions: actions ?? [],
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
