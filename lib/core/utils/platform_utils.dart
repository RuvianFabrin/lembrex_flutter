import 'dart:io';

/// true quando rodando em Linux ou Windows.
bool get isDesktop => Platform.isLinux || Platform.isWindows;

/// true quando rodando em Android ou iOS.
bool get isMobile => Platform.isAndroid || Platform.isIOS;
