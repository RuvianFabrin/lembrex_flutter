import 'package:flutter/material.dart';

import '../../core/utils/platform_utils.dart';
import '../../features/layout/desktop_layout.dart';
import '../../features/layout/mobile_layout.dart';

class LayoutWrapper extends StatelessWidget {
  const LayoutWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return isDesktop ? const DesktopLayout() : const MobileLayout();
  }
}
