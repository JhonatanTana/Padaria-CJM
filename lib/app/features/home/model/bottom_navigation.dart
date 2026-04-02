import 'package:flutter/material.dart';

import '../router/app_router.dart';

class BottomNavigation {
  String title;
  Icon icon;
  Icon actionIcon;
  String action;

  BottomNavigation({
    required this.title,
    required this.icon,
    required this.actionIcon,
    required this.action
  });
}